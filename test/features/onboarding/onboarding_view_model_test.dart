import 'package:pulse_coaching_app/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingViewModel', () {
    late InMemoryOnboardingRepository repository;
    late OnboardingViewModel viewModel;

    setUp(() {
      repository = InMemoryOnboardingRepository();
      viewModel = OnboardingViewModel(
        repository: repository,
        submitDelay: Duration.zero,
      );
    });

    test('isValidEmail accepts common addresses', () {
      expect(OnboardingViewModel.isValidEmail('user@example.com'), isTrue);
      expect(OnboardingViewModel.isValidEmail('a@b.co'), isTrue);
    });

    test('isValidEmail rejects invalid addresses', () {
      expect(OnboardingViewModel.isValidEmail(''), isFalse);
      expect(OnboardingViewModel.isValidEmail('not-an-email'), isFalse);
      expect(OnboardingViewModel.isValidEmail('missing@domain'), isFalse);
    });

    test('initial hasCompletedOnboarding is false', () {
      expect(viewModel.hasCompletedOnboarding, isFalse);
    });

    test('load restores persisted completion state', () async {
      await repository.setCompleted();

      await viewModel.load();

      expect(viewModel.hasCompletedOnboarding, isTrue);
    });

    test('submit with invalid email sets validation error', () async {
      viewModel.updateEmail('bad');

      final success = await viewModel.submit();

      expect(success, isFalse);
      expect(viewModel.validationError, OnboardingValidationError.invalidEmail);
      expect(viewModel.isLoading, isFalse);
    });

    test('submit with valid email marks onboarding completed', () async {
      viewModel.updateEmail('user@example.com');

      final success = await viewModel.submit();

      expect(success, isTrue);
      expect(viewModel.hasCompletedOnboarding, isTrue);
      expect(viewModel.validationError, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(await repository.isCompleted(), isTrue);
    });

    test('updateEmail clears validation error', () async {
      viewModel.updateEmail('bad');
      await viewModel.submit();
      expect(viewModel.validationError, isNotNull);

      viewModel.updateEmail('user@example.com');

      expect(viewModel.validationError, isNull);
    });
  });
}
