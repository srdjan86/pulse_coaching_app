import 'dart:async';

import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

enum LoginFieldValidationError { required }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository) {
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
  String _email = '';
  String _password = '';
  bool _isPasswordObscured = true;
  LoginFieldValidationError? _emailValidationError;
  LoginFieldValidationError? _passwordValidationError;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
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
  }

  void updatePassword(String value) {
    _password = value;
    if (_passwordValidationError != null) {
      _passwordValidationError = null;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  Future<bool> submitSignIn() async {
    if (!_validateSignIn()) return false;

    await signIn(email: _email.trim(), password: _password);
    return isSignedIn;
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      _user = await _repository.signIn(email: email, password: password);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
      _user = null;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _validateSignIn() {
    final emailError = _email.trim().isEmpty
        ? LoginFieldValidationError.required
        : null;
    final passwordError = _password.isEmpty
        ? LoginFieldValidationError.required
        : null;

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
