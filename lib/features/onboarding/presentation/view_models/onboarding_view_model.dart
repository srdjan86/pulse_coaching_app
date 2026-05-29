import 'package:flutter/foundation.dart';

enum OnboardingValidationError { invalidEmail }

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({
    Duration submitDelay = const Duration(milliseconds: 300),
  }) : _submitDelay = submitDelay;

  final Duration _submitDelay;

  String _email = '';
  OnboardingValidationError? _validationError;
  bool _isLoading = false;

  String get email => _email;
  OnboardingValidationError? get validationError => _validationError;
  bool get isLoading => _isLoading;

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

    _isLoading = false;
    notifyListeners();
    return true;
  }

  static bool isValidEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(trimmed);
  }

  bool _isValidEmail(String value) => isValidEmail(value);
}
