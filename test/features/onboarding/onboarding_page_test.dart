import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import '../../helpers/test_dependencies.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> pumpOnboarding(
    WidgetTester tester, {
    OnboardingViewModel? viewModel,
    bool navigateOnSuccess = false,
  }) async {
    final onboarding = OnboardingPage(
      viewModel:
          viewModel ??
          OnboardingViewModel(
            repository: InMemoryOnboardingRepository(),
            submitDelay: Duration.zero,
          ),
    );

    if (navigateOnSuccess) {
      final router = GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(path: '/onboarding', builder: (_, _) => onboarding),
          GoRoute(path: '/', builder: (_, _) => const HomePage()),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
    } else {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: onboarding,
        ),
      );
    }
    await tester.pumpAndSettle();
  }

  testWidgets('shows title, subtitle, email field, and CTA', (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Welcome to Pulse'), findsOneWidget);
    expect(find.textContaining('Coaching and wellness'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_email')), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('invalid email shows validation message', (tester) async {
    await pumpOnboarding(tester);

    await tester.enterText(find.byKey(const Key('onboarding_email')), 'bad');
    await tester.tap(find.byKey(const Key('onboarding_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('valid submit shows loading then navigates home', (tester) async {
    await pumpOnboarding(tester, navigateOnSuccess: true);

    await tester.enterText(
      find.byKey(const Key('onboarding_email')),
      'user@example.com',
    );
    await tester.tap(find.byKey(const Key('onboarding_submit')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('AI-ready Flutter delivery template'), findsOneWidget);
    expect(find.text('Welcome to Pulse'), findsNothing);
  });
}
