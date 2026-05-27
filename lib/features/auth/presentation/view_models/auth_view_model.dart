import 'dart:async';

import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

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

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _user != null;

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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
