import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.backend,
    this.supabaseUrl = '',
    this.supabaseAnonKey = '',
  });

  final AppFlavor flavor;
  final String appName;
  final BackendType backend;
  final String supabaseUrl;
  final String supabaseAnonKey;

  static AppConfig fromEnvironment() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    const appName = String.fromEnvironment(
      'APP_NAME',
      defaultValue: 'Pulse Dev',
    );
    const backend = String.fromEnvironment('BACKEND', defaultValue: 'mock');
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    return AppConfig(
      flavor: AppFlavor.fromString(flavor),
      appName: appName,
      backend: BackendType.fromString(backend),
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
  }

  bool get isProduction => flavor == AppFlavor.prod;
}
