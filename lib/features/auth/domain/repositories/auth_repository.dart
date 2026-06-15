import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  Stream<AppUser?> watchUser();

  Future<AppUser> signIn({required String email, required String password});

  /// Returns a user when a session is created immediately.
  /// Returns null when email confirmation is required before sign-in.
  Future<AppUser?> signUp({required String email, required String password});

  Future<void> signOut();

  /// Returns and clears a recent auth stream failure (e.g. invalid email link).
  AuthFailure? consumeRecentAuthFailure() => null;

  /// Waits for Supabase to finish handling an email confirmation deep link.
  ///
  /// Returns the signed-in user when a session is established.
  /// Throws [AuthFailure] when the link is invalid or processing times out.
  Future<AppUser?> waitForEmailConfirmationSession({
    required bool Function() isSignedIn,
    required AppUser? Function() readCurrentUser,
    Duration timeout = const Duration(seconds: 5),
  });
}
