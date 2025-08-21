import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:arcane/arcane.dart';
import 'package:blink/gen/artifacts.gen.dart';
import 'package:blink/model/message/message.dart';
import 'package:blink/util/signal/iks.dart';
import 'package:blink/util/signal/msg.dart';
import 'package:blink/util/signal/pks.dart';
import 'package:blink/util/signal/session_store.dart';
import 'package:blink/util/signal/signed_pks.dart';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkSignal {
  static final Map<String, Future<BlinkSignal>> _testInstances = {};
  static Future<BlinkSignal>? _instance;
  late final LazyBox box;
  late BlinkSessionStore sessionStore;
  late BlinkPreKeyStore pkStore;
  late BlinkSignedPreKeyStore spkStore;
  late BlinkIdentityKeyStore idStore;
  late BlinkChatStore chatStore;
  late IdentityKeyPair ikp;
  late int registrationId;

  BlinkSignal._();

  Future<PreKeyBundle> getPreKeyBundle() async {
    SignedPreKeyRecord signedPreKey = await spkStore.loadSignedPreKey(0);
    await pkStore.autofillPreKeys();
    List<int> availableIds = await pkStore.getAvailablePreKeyIds();
    int selectedId = availableIds.popRandom(Random.secure());
    PreKeyRecord preKey = await pkStore.loadPreKey(selectedId);

    return PreKeyBundle(
      registrationId,
      1,
      preKey.id,
      preKey.getKeyPair().publicKey,
      signedPreKey.id,
      signedPreKey.getKeyPair().publicKey,
      signedPreKey.signature,
      idStore.identityKeyPair.getPublicKey(),
    );
  }

  Future<void> buildSession(String peerId, PreKeyBundle remoteBundle) async {
    SignalProtocolAddress address = SignalProtocolAddress(peerId, 1);
    SessionBuilder builder = SessionBuilder(
      sessionStore,
      pkStore,
      spkStore,
      idStore,
      address,
    );
    await builder.processPreKeyBundle(remoteBundle);
  }

  Future<Uint8List> encryptMessage(BlinkMessage plainMsg, String peerId) =>
      SessionCipher(
            sessionStore,
            pkStore,
            spkStore,
            idStore,
            SignalProtocolAddress(peerId, 1),
          )
          .encrypt(Uint8List.fromList(utf8.encode(plainMsg.toJson())))
          .then((i) => i.serialize());

  Future<BlinkMessage> decryptMessage(
    Uint8List ciphertextBytes,
    String peerId,
  ) async {
    if (ciphertextBytes.isEmpty) {
      throw Exception('Empty ciphertext');
    }

    SessionCipher cipher = SessionCipher(
      sessionStore,
      pkStore,
      spkStore,
      idStore,
      SignalProtocolAddress(peerId, 1),
    );

    Uint8List plaintext;
    try {
      // Try as SignalMessage (whisper) first, common for replies
      SignalMessage signalMsg = SignalMessage.fromSerialized(ciphertextBytes);
      plaintext = await cipher.decryptFromSignal(signalMsg);
    } catch (e) {
      // If fails, try as PreKeySignalMessage (initial)
      try {
        PreKeySignalMessage prekeyMsg = PreKeySignalMessage(ciphertextBytes);
        plaintext = await cipher.decrypt(prekeyMsg);
      } catch (e2) {
        throw Exception('Decryption failed: $e2 (original: $e)');
      }
    }

    return $BlinkMessage.fromJson(utf8.decode(plaintext));
  }

  static Future<BlinkSignal> get instance async {
    if (_instance == null) {
      BlinkSignal b = BlinkSignal._();
      _instance = b._init().then((_) => b);
    }

    return _instance!;
  }

  static Future<BlinkSignal> getTestInstance(String account) async {
    if (!_testInstances.containsKey(account)) {
      BlinkSignal b = BlinkSignal._();
      _testInstances[account] = b._init(key: account).then((_) => b);
    }

    return _testInstances[account]!;
  }

  Future<void> _init({String key = "blinkstate"}) async {
    box = await Hive.openLazyBox(
      key,
      encryptionCipher: HiveAesCipher(
        _hiveKey("!EKj>00Oahw6blink4allU;?0:kD;5p5W"),
      ),
    );

    await _install();
    ikp = IdentityKeyPair.fromSerialized(await box.get("?ikp"));
    registrationId = await box.get("?rid");
    sessionStore = BlinkSessionStore(box);
    pkStore = BlinkPreKeyStore(box);
    spkStore = BlinkSignedPreKeyStore(box);
    chatStore = BlinkChatStore(box);
    idStore = BlinkIdentityKeyStore(box, ikp, registrationId);
  }

  Future<void> _install() async {
    if (!box.containsKey("?ikp") || !box.containsKey("?rid")) {
      IdentityKeyPair ikp = generateIdentityKeyPair();
      int rid = generateRegistrationId(true);
      SignedPreKeyRecord spk = generateSignedPreKey(ikp, 0);
      BlinkPreKeyStore pkStore = BlinkPreKeyStore(box);

      await Future.wait([
        pkStore.autofillPreKeys(),
        BlinkSignedPreKeyStore(box).storeSignedPreKey(spk.id, spk),
        box.put("?ikp", ikp.serialize()),
        box.put("?rid", rid),
      ]);
    }
  }
}

List<int> _hiveKey(String key) {
  List<int> h = sha512
      .convert(
        utf8.encode("b1!nk?${md5.convert(utf8.encode("~b$key.!%"))}.!$key.x1"),
      )
      .bytes;
  Random random = Random(key.hashCode);
  int g(int a) =>
      h[a % h.length] ^ h[(a + random.nextInt(8192) + 1024) % h.length];
  return List.generate(
    32,
    (i) => (random.nextInt(255) ^ g(i) ^ random.nextInt(1924864)) % 255,
  );
}
