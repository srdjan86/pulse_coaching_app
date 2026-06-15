import 'package:pulse_coaching_app/core/validation/email_validator.dart'
    as validation;
import 'package:pulse_coaching_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/foundation.dart';

enum OnboardingValidationError { invalidEmail }

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({
    required OnboardingRepository repository,
    Duration submitDelay = const Duration(milliseconds: 300),
  }) : _repository = repository,
       _submitDelay = submitDelay;

  final OnboardingRepository _repository;
  final Duration _submitDelay;

  String _email = '';
  OnboardingValidationError? _validationError;
  bool _isLoading = false;
  bool _hasCompletedOnboarding = false;

  String get email => _email;
  OnboardingValidationError? get validationError => _validationError;
  bool get isLoading => _isLoading;

  /// True after [load] when the user has already completed onboarding.
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  /// Pre-loads the persisted completion state. Call once at bootstrap.
  Future<void> load() async {
    _hasCompletedOnboarding = await _repository.isCompleted();
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    if (_validationError != null) {
      _validationError = null;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    final trimmed = _email.trim();
    if (!_isValidEmail(trimmed)) {
      _validationError = OnboardingValidationError.invalidEmail;
      notifyListeners();
      return false;
    }

    _validationError = null;
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(_submitDelay);

    await _repository.setCompleted();
    _hasCompletedOnboarding = true;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  static bool isValidEmail(String value) => validation.isValidEmail(value);

  bool _isValidEmail(String value) => isValidEmail(value);
}
