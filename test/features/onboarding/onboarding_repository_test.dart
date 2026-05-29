import 'package:pulse_coaching_app/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/data/repositories/shared_preferences_onboarding_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InMemoryOnboardingRepository', () {
    test('defaults to not completed', () async {
      final repo = InMemoryOnboardingRepository();
      expect(await repo.isCompleted(), isFalse);
    });

    test('setCompleted marks as completed', () async {
      final repo = InMemoryOnboardingRepository();
      await repo.setCompleted();
      expect(await repo.isCompleted(), isTrue);
    });
  });

  group('SharedPreferencesOnboardingRepository', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('defaults to not completed', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = SharedPreferencesOnboardingRepository(prefs);
      expect(await repo.isCompleted(), isFalse);
    });

    test('persists completion across instances', () async {
      final prefs = await SharedPreferences.getInstance();
      await SharedPreferencesOnboardingRepository(prefs).setCompleted();
      expect(
        await SharedPreferencesOnboardingRepository(prefs).isCompleted(),
        isTrue,
      );
    });
  });
}
