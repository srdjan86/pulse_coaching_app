import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/core/config/supabase_auth_config.dart';

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.backend,
    this.supabaseUrl = '',
    this.supabaseAnonKey = '',
    this.supabaseAuthRedirectUrl = SupabaseAuthConfig.defaultRedirectUrl,
  });

  final AppFlavor flavor;
  final String appName;
  final BackendType backend;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String supabaseAuthRedirectUrl;

  static AppConfig fromEnvironment() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    const appName = String.fromEnvironment(
      'APP_NAME',
      defaultValue: 'Pulse Dev',
    );
    const backend = String.fromEnvironment('BACKEND', defaultValue: 'mock');
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const supabaseAuthRedirectUrl = String.fromEnvironment(
      'SUPABASE_AUTH_REDIRECT_URL',
      defaultValue: SupabaseAuthConfig.defaultRedirectUrl,
    );

    return AppConfig(
      flavor: AppFlavor.fromString(flavor),
      appName: appName,
      backend: BackendType.fromString(backend),
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      supabaseAuthRedirectUrl: supabaseAuthRedirectUrl,
    );
  }

  bool get isProduction => flavor == AppFlavor.prod;
}
