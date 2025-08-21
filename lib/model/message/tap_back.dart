import 'package:artifact/artifact.dart';
import 'package:blink/model/message/message.dart';

@artifact
class BlinkMessageTapBack extends BlinkMessage {
  final String tbCode;

  const BlinkMessageTapBack({
    required super.time,
    required this.tbCode,
    super.remote = false,
    super.replyTo,
    super.editFrom,
  });
}
