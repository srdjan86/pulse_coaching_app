import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import '../../helpers/test_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureTestDependencies(
      const AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Pulse Dev',
        backend: BackendType.mock,
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('home page shows feature cards', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Counter (BLoC)'), findsOneWidget);
    expect(find.text('Sign in to Pulse'), findsOneWidget);
    expect(find.text('Coaching library'), findsOneWidget);
    expect(find.text('Flavor: dev'), findsOneWidget);
  });
}
