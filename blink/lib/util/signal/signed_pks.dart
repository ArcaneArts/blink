import 'package:hive_flutter/adapters.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkSignedPreKeyStore extends SignedPreKeyStore {
  final LazyBox box;

  BlinkSignedPreKeyStore(this.box);

  List<String> getSignedPreKeyKeys() => box.keys
      .where((i) => i.toString().startsWith("@"))
      .map((i) => i.toString())
      .toList();

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      box.containsKey("@$signedPreKeyId");

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final v = await box.get("@$signedPreKeyId");
    if (v == null) {
      throw InvalidKeyIdException(
        'No such signedprekeyrecord! $signedPreKeyId',
      );
    }
    return SignedPreKeyRecord.fromSerialized(v);
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async => Future.wait(
    getSignedPreKeyKeys().map(
      (k) async => SignedPreKeyRecord.fromSerialized(await box.get(k)),
    ),
  );

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async =>
      box.delete("@$signedPreKeyId");

  @override
  Future<void> storeSignedPreKey(
    int signedPreKeyId,
    SignedPreKeyRecord record,
  ) async => box.put("@$signedPreKeyId", record.serialize());
}
