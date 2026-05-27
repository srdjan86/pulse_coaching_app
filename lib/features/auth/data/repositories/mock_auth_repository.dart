import 'dart:async';

import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  @override
  Stream<AppUser?> watchUser() => _controller.stream;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = AppUser(id: 'mock-user', email: email);
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _currentUser = null;
    _controller.add(null);
  }
}
