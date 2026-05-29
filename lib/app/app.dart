import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/app/router/app_router.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/core/theme/app_theme.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<ThemeSettingsViewModel>(),
      child: const _DeliveryAppShell(),
    );
  }
}

class _DeliveryAppShell extends StatelessWidget {
  const _DeliveryAppShell();

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    final themeSettings = context.watch<ThemeSettingsViewModel>();

    return MaterialApp.router(
      title: config.appName,
      theme: AppTheme.light(flavor: config.flavor.name),
      darkTheme: AppTheme.dark(flavor: config.flavor.name),
      themeMode: themeSettings.isLoaded
          ? themeSettings.themeMode
          : ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: createAppRouter(),
    );
  }
}

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeBackend(config);
  await configureDependencies(config);

  await getIt<ThemeSettingsViewModel>().load();

  runApp(const DeliveryApp());
}

Future<void> _initializeBackend(AppConfig config) async {
  switch (config.backend) {
    case BackendType.firebase:
      await Firebase.initializeApp();
    case BackendType.supabase:
      if (config.supabaseUrl.isEmpty || config.supabaseAnonKey.isEmpty) {
        throw StateError(
          'Supabase backend requires SUPABASE_URL and SUPABASE_ANON_KEY.',
        );
      }
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseAnonKey,
      );
    case BackendType.mock:
      break;
  }
}
