import 'dart:async';

import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  static const demoEmail = 'demo@example.com';
  static const demoPassword = 'password';

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> watchUser() => _controller.stream;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _assertValidCredentials(email, password);

    _currentUser = AppUser(id: 'mock-user', email: email.trim());
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser?> signUp({
    required String email,
    required String password,
  }) async {
    return signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _currentUser = null;
    _controller.add(null);
  }

  void _assertValidCredentials(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail != demoEmail || password != demoPassword) {
      throw const AuthFailure('invalid_login_credentials');
    }
  }
}
