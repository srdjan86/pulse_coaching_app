import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  Stream<AppUser?> watchUser();

  Future<AppUser> signIn({required String email, required String password});

  /// Returns a user when a session is created immediately.
  /// Returns null when email confirmation is required before sign-in.
  Future<AppUser?> signUp({required String email, required String password});

  Future<void> signOut();
}
