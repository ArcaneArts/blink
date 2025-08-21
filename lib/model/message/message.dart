import 'package:artifact/artifact.dart';

@artifact
class BlinkMessage {
  final int time;
  final bool remote;
  final String? replyTo;
  final String? editFrom;

  const BlinkMessage({
    required this.time,
    this.remote = false,
    this.replyTo,
    this.editFrom,
  });
}
