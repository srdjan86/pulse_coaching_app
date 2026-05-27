import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpTestApp(
  WidgetTester tester, {
  required Widget home,
  AppConfig config = const AppConfig(
    flavor: AppFlavor.dev,
    appName: 'Pulse Dev',
    backend: BackendType.mock,
  ),
}) async {
  await getIt.reset();
  await configureDependencies(config);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}
