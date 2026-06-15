import 'dart:async';

import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/core/validation/email_validator.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

enum LoginFieldValidationError { required, invalidEmail, passwordTooShort }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository) {
    _user = _repository.currentUser;
    _subscription = _repository.watchUser().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _infoMessage;
  bool _needsEmailConfirmation = false;
  String _email = '';
  String _password = '';
  bool _isPasswordObscured = true;
  LoginFieldValidationError? _emailValidationError;
  LoginFieldValidationError? _passwordValidationError;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get infoMessage => _infoMessage;
  bool get needsEmailConfirmation => _needsEmailConfirmation;
  bool get isSignedIn => _user != null;
  bool get isPasswordObscured => _isPasswordObscured;
  LoginFieldValidationError? get emailValidationError => _emailValidationError;
  LoginFieldValidationError? get passwordValidationError =>
      _passwordValidationError;

  void updateEmail(String value) {
    _email = value;
    if (_emailValidationError != null) {
      _emailValidationError = null;
      notifyListeners();
    }
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void updatePassword(String value) {
    _password = value;
    if (_passwordValidationError != null) {
      _passwordValidationError = null;
      notifyListeners();
    }
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void resetAuthFormFeedback() {
    _emailValidationError = null;
    _passwordValidationError = null;
    _errorMessage = null;
    _infoMessage = null;
    _needsEmailConfirmation = false;
    notifyListeners();
  }

  Future<bool> submitSignIn() async {
    if (!_validateSignIn()) {
      return false;
    }

    await signIn(email: _email.trim(), password: _password);
    return _didAuthSucceed();
  }

  Future<bool> submitSignUp() async {
    if (!_validateSignUp()) {
      return false;
    }

    await signUp(email: _email.trim(), password: _password);
    return _didAuthSucceed();
  }

  Future<void> signIn({required String email, required String password}) async {
    _clearMessages();
    _setLoading(true);
    try {
      _user = await _repository.signIn(email: email, password: password);
    } on AuthFailure catch (error) {
      _errorMessage = error.code;
      _user = _repository.currentUser;
    } catch (error) {
      _errorMessage = 'auth_error';
      _user = _repository.currentUser;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    _clearMessages();
    _setLoading(true);
    try {
      final user = await _repository.signUp(email: email, password: password);
      if (user == null) {
        _needsEmailConfirmation = true;
        _infoMessage = 'sign_up_confirmation_required';
        _user = null;
        return;
      }
      _user = user;
    } on AuthFailure catch (error) {
      _errorMessage = error.code;
      _user = _repository.currentUser;
    } catch (error) {
      _errorMessage = 'auth_error';
      _user = _repository.currentUser;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
      _user = null;
      _clearMessages();
    } on AuthFailure catch (error) {
      _errorMessage = error.code;
    } catch (error) {
      _errorMessage = 'auth_error';
    } finally {
      _setLoading(false);
    }
  }

  bool _didAuthSucceed() => isSignedIn && _errorMessage == null;

  void _clearMessages() {
    _errorMessage = null;
    _infoMessage = null;
    _needsEmailConfirmation = false;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _validateSignIn() {
    return _applyFieldValidation(requireMinPasswordLength: false);
  }

  bool _validateSignUp() {
    return _applyFieldValidation(requireMinPasswordLength: true);
  }

  bool _applyFieldValidation({required bool requireMinPasswordLength}) {
    final trimmedEmail = _email.trim();
    final LoginFieldValidationError? emailError;
    if (trimmedEmail.isEmpty) {
      emailError = LoginFieldValidationError.required;
    } else if (!isValidEmail(trimmedEmail)) {
      emailError = LoginFieldValidationError.invalidEmail;
    } else {
      emailError = null;
    }

    final LoginFieldValidationError? passwordError;
    if (_password.isEmpty) {
      passwordError = LoginFieldValidationError.required;
    } else if (requireMinPasswordLength && _password.length < 6) {
      passwordError = LoginFieldValidationError.passwordTooShort;
    } else {
      passwordError = null;
    }

    final didChange =
        emailError != _emailValidationError ||
        passwordError != _passwordValidationError;
    _emailValidationError = emailError;
    _passwordValidationError = passwordError;

    if (didChange) {
      notifyListeners();
    }

    return emailError == null && passwordError == null;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
