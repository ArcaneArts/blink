import 'package:artifact/artifact.dart';
import 'package:blink/model/message/message.dart';

@artifact
class BlinkMessageText extends BlinkMessage {
  final String text;

  const BlinkMessageText({
    required super.time,
    required this.text,
    super.remote = false,
    super.replyTo,
    super.editFrom,
  });
}
