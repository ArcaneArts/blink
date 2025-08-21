import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkPreKeyStore extends PreKeyStore {
  final LazyBox box;

  BlinkPreKeyStore(this.box);

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      box.containsKey("<$preKeyId");

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    Uint8List? v = await box.get("<$preKeyId");

    if (v == null) {
      throw InvalidKeyIdException('No such prekeyrecord! - $preKeyId');
    }

    return PreKeyRecord.fromBuffer(v);
  }

  Future<void> autofillPreKeys({int min = 75, int max = 110}) async {
    int nextId = await box.get("?npks", defaultValue: 69);
    int count = preKeyCount;
    if (count < min) {
      return generateAndStorePreKeys(nextId, max - count);
    }
  }

  int get preKeyCount => box.keys
      .where((k) => k.toString().startsWith('<'))
      .map((k) => int.tryParse(k.toString().substring(1)) ?? -1)
      .where((id) => id >= 0)
      .length;

  Future<void> generateAndStorePreKeys(int startId, int count) => Future.wait([
    ...generatePreKeys(startId, count).map((p) => storePreKey(p.id, p)),
    box.put("?npks", startId + count),
  ]);

  Future<List<int>> getAvailablePreKeyIds() async => box.keys
      .where((k) => k.toString().startsWith('<'))
      .map((k) => int.tryParse(k.toString().substring(1)) ?? -1)
      .where((id) => id >= 0)
      .toList();

  @override
  Future<void> removePreKey(int preKeyId) async => box.delete("<$preKeyId");

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async =>
      box.put("<$preKeyId", record.serialize());
}
