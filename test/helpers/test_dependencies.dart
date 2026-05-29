import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> configureTestDependencies(AppConfig config) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  await configureDependencies(config, preferences: preferences);
}
