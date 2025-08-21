import 'dart:convert';

import 'package:arcane/arcane.dart';
import 'package:blink/gen/artifacts.gen.dart';
import 'package:blink/model/chat.dart';
import 'package:blink/model/message/message.dart';
import 'package:blink/util/signal.dart';
import 'package:crypto/crypto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class BlinkChatState {
  final BlinkSignal? blinkSignal;
  BlinkChat chat;

  BlinkChatState({required this.chat, this.blinkSignal});

  Future<BlinkSignal> get bs async => blinkSignal ?? await BlinkSignal.instance;

  Future<BlinkMessage?> loadMessage(int timeCode) async {
    return await (await bs).chatStore.getMessageData(chat, timeCode);
  }

  Future<List<BlinkMessage>> getMessages({
    int? startingFrom,
    int? limit,
  }) async {
    startingFrom ??= chat.messages.firstOrNull;

    if (startingFrom == null) {
      return [];
    }

    Iterable<int> k = chat.messages.skipWhile((n) => n > startingFrom!);

    if (limit != null) {
      k = k.take(limit);
    }

    return Future.wait(
      k.map(loadMessage),
    ).then((m) => m.whereType<BlinkMessage>().toList());
  }

  Future<void> addMessageLocal(BlinkMessage message) async {
    BlinkSignal bs = await this.bs;
    chat = chat.withTaggedMessage(message);
    await Future.wait([
      _saveChat(),
      bs.chatStore.writeMessageData(
        chat,
        message.time,
        message.copyWith(remote: false),
      ),
    ]);
  }

  Future<void> addMessageRemote(BlinkMessage decryptedMessage) async {
    chat = chat.withTaggedMessage(decryptedMessage.copyWith(remote: true));
    await Future.wait([
      _saveChat(),
      (await bs).chatStore.writeMessageData(
        chat,
        decryptedMessage.time,
        decryptedMessage, // Store JSON
      ),
    ]);
  }

  Future<void> _saveChat() async => await (await bs).chatStore.writeChat(chat);

  static Future<BlinkChatState> createChat({
    required String peerId,
    required PreKeyBundle peerPKB,
    BlinkSignal? signal,
  }) async {
    BlinkSignal bs = signal ?? await BlinkSignal.instance;
    await bs.buildSession(peerId, peerPKB);
    BlinkChatState s = BlinkChatState(
      chat: BlinkChat(
        id: md5.convert(utf8.encode("$peerId-${Uuid().v4()}")).toString(),
        peer: peerId,
        messages: [],
      ),
      blinkSignal: bs,
    );
    await s._saveChat();
    return s;
  }
}
