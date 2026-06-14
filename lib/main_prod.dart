import 'package:pulse_coaching_app/app/app.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';

Future<void> main() async {
  await bootstrap(AppConfig.fromEnvironment());
}
