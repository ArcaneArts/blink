import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkIdentityKeyStore extends IdentityKeyStore {
  final LazyBox box;
  final IdentityKeyPair identityKeyPair;
  final int localRegistrationId;

  BlinkIdentityKeyStore(
    this.box,
    this.identityKeyPair,
    this.localRegistrationId,
  );

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final v = await box.get("*$address");
    return v == null ? null : IdentityKey.fromBytes(v, 0);
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async => identityKeyPair;

  @override
  Future<int> getLocalRegistrationId() async => localRegistrationId;

  @override
  Future<bool> isTrustedIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
    Direction? direction,
  ) async {
    final trustedBytes = await box.get("*$address");
    if (identityKey == null) {
      return false;
    }
    return trustedBytes == null ||
        listEquals(trustedBytes, identityKey.serialize());
  }

  @override
  Future<bool> saveIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
  ) async {
    if (identityKey == null) {
      return false;
    }
    final key = "*$address";
    final existingBytes = await box.get(key);
    final newBytes = identityKey.serialize();
    if (existingBytes == null || !listEquals(existingBytes, newBytes)) {
      await box.put(key, newBytes);
      return true;
    } else {
      return false;
    }
  }
}
