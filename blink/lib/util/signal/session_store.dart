import 'package:hive_flutter/adapters.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkSessionStore extends SessionStore {
  final LazyBox box;

  BlinkSessionStore(this.box);

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      box.containsKey("^$address");

  List<String> getSessionKeys() => box.keys
      .where((i) => i.toString().startsWith("^"))
      .map((i) => i.toString().substring(1))
      .toList();

  List<SignalProtocolAddress> getSessionAddresses() {
    return getSessionKeys()
        .map(
          (i) => SignalProtocolAddress(
            i.split(":").first,
            int.parse(i.split(":").last),
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteAllSessions(String name) =>
      Future.wait(getSessionAddresses().map(deleteSession));

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async =>
      box.delete("^$address");

  @override
  Future<List<int>> getSubDeviceSessions(String name) async =>
      getSessionAddresses()
          .where((k) => k.getName() == name && k.getDeviceId() != 1)
          .map((i) => i.getDeviceId())
          .toList();

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) => box
      .get("^$address")
      .then(
        (v) => v == null ? SessionRecord() : SessionRecord.fromSerialized(v),
      );

  @override
  Future<void> storeSession(
    SignalProtocolAddress address,
    SessionRecord record,
  ) => box.put("^$address", record.serialize());
}
