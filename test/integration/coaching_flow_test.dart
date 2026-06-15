import 'package:pulse_coaching_app/app/app.dart';
import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/in_memory_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_dependencies.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureTestDependencies(
      const AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Pulse Dev',
        backend: BackendType.mock,
      ),
      onboardingRepository: InMemoryOnboardingRepository(completed: true),
      savedLessonsRepository: InMemorySavedLessonsRepository(),
    );
    await getIt<OnboardingViewModel>().load();
    await getIt<ThemeSettingsViewModel>().load();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('home to library to detail to save lesson flow', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DeliveryApp());
    await tester.pumpAndSettle();

    expect(find.text('Pulse'), findsOneWidget);

    await tester.ensureVisible(find.text('Coaching library'));
    await tester.tap(find.text('Coaching library'));
    await tester.pumpAndSettle();

    expect(find.text('Morning Mobility Reset'), findsOneWidget);

    await tester.ensureVisible(find.text('Morning Mobility Reset'));
    await tester.tap(find.text('Morning Mobility Reset'));
    await tester.pumpAndSettle();

    expect(find.text('Save lesson'), findsOneWidget);

    await tester.ensureVisible(find.text('Save lesson'));
    await tester.tap(find.text('Save lesson'));
    await tester.pumpAndSettle();

    expect(find.text('Remove from saved'), findsOneWidget);
  });
}
