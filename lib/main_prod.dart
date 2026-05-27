import 'package:pulse_coaching_app/app/app.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';

Future<void> main() async {
  await bootstrap(
    const AppConfig(
      flavor: AppFlavor.prod,
      appName: 'Pulse',
      backend: BackendType.mock,
    ),
  );
}
