import 'package:blink/gen/artifacts.gen.dart';
import 'package:blink/model/chat.dart';
import 'package:blink/model/message/message.dart';
import 'package:hive_flutter/adapters.dart';

class BlinkChatStore {
  final LazyBox box;

  BlinkChatStore(this.box);

  Future<void> writeMessageData(
    BlinkChat chat,
    int code,
    BlinkMessage message,
  ) => box.put('msg_${chat.id}_$code', message.toJson());

  Future<BlinkMessage?> getMessageData(BlinkChat chat, int code) async {
    String? j = await box.get('msg_${chat.id}_$code');

    if (j != null) {
      return $BlinkMessage.fromJson(j);
    } else {
      return null;
    }
  }

  Future<BlinkChat?> getChat(String id) async {
    String? chatData = await box.get("#$id");

    if (chatData != null) {
      return $BlinkChat.fromJson(chatData);
    }

    return null;
  }

  Future<void> writeChat(BlinkChat chat) =>
      box.put("#${chat.id}", chat.toJson());
}
