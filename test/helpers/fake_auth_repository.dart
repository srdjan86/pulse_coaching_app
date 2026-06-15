import 'dart:async';

import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';

/// Inert auth repository for view-model tests that only need [watchUser].
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? currentUser}) : _currentUser = currentUser;

  AppUser? _currentUser;
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> watchUser() => _controller.stream;

  void emitUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> signUp({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    emitUser(null);
  }

  @override
  AuthFailure? consumeRecentAuthFailure() => null;

  @override
  Future<AppUser?> waitForEmailConfirmationSession({
    required bool Function() isSignedIn,
    required AppUser? Function() readCurrentUser,
    Duration timeout = const Duration(seconds: 5),
  }) {
    throw UnimplementedError();
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
