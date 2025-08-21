import 'package:arcane/arcane.dart';
import 'package:blink/screen/home.dart';
import 'package:blink/util/signal.dart';
import 'package:blink/util/test.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await test();
  await Hive.initFlutter("blink");
  await BlinkSignal.instance;
  runApp("blink", BlinkApplication());
}

class BlinkApplication extends StatelessWidget {
  const BlinkApplication({super.key});

  @override
  Widget build(BuildContext context) =>
      ArcaneApp(home: HomeScreen(), title: "Blink");
}
