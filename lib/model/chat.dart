import 'package:artifact/artifact.dart';
import 'package:blink/gen/artifacts.gen.dart';
import 'package:blink/model/message/message.dart';

@artifact
class BlinkChat {
  final String id;
  final String peer;
  final List<int> messages;

  const BlinkChat({
    required this.id,
    required this.peer,
    required this.messages,
  });

  BlinkChat withTaggedMessage(BlinkMessage message) {
    List<int> m = [...messages, message.time];
    m.sort((a, b) => b.compareTo(a));
    return copyWith(messages: m);
  }
}
