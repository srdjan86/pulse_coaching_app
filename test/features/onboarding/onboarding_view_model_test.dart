import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingViewModel', () {
    late OnboardingViewModel viewModel;

    setUp(() {
      viewModel = OnboardingViewModel(submitDelay: Duration.zero);
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

    test('submit with invalid email sets validation error', () async {
      viewModel.updateEmail('bad');

      final success = await viewModel.submit();

      expect(success, isFalse);
      expect(viewModel.validationError, OnboardingValidationError.invalidEmail);
      expect(viewModel.isLoading, isFalse);
    });

    test('submit with valid email completes successfully', () async {
      viewModel.updateEmail('user@example.com');

      final success = await viewModel.submit();

      expect(success, isTrue);
      expect(viewModel.validationError, isNull);
      expect(viewModel.isLoading, isFalse);
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
