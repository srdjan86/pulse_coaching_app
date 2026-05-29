import 'package:pulse_coaching_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class InMemoryOnboardingRepository implements OnboardingRepository {
  bool _completed = false;

  @override
  Future<bool> isCompleted() async => _completed;

  @override
  Future<void> setCompleted() async => _completed = true;
}
