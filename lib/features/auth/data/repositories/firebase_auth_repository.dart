import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  AppUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  @override
  Stream<AppUser?> watchUser() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = _mapUser(credential.user);
    if (user == null) {
      throw StateError('Firebase sign-in succeeded without a user.');
    }
    return user;
  }

  @override
  Future<AppUser?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _mapUser(credential.user);
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  AuthFailure? consumeRecentAuthFailure() => null;

  @override
  Future<AppUser?> waitForEmailConfirmationSession({
    required bool Function() isSignedIn,
    required AppUser? Function() readCurrentUser,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (isSignedIn()) {
      return readCurrentUser();
    }

    await Future<void>.delayed(timeout);
    throw const AuthFailure('email_link_expired');
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AppUser(id: user.uid, email: user.email ?? 'unknown@firebase.local');
  }
}
