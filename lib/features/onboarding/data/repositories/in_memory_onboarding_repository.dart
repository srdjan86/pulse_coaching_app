import 'package:pulse_coaching_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class InMemoryOnboardingRepository implements OnboardingRepository {
  InMemoryOnboardingRepository({bool completed = false})
    : _completed = completed;

  bool _completed;

  @override
  Future<bool> isCompleted() async => _completed;

  @override
  Future<void> setCompleted() async => _completed = true;
}
