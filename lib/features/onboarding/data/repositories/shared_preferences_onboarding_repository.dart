import 'package:pulse_coaching_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesOnboardingRepository implements OnboardingRepository {
  SharedPreferencesOnboardingRepository(this._preferences);

  static const _key = 'onboarding_completed';

  final SharedPreferences _preferences;

  @override
  Future<bool> isCompleted() async => _preferences.getBool(_key) ?? false;

  @override
  Future<void> setCompleted() async => _preferences.setBool(_key, true);
}
