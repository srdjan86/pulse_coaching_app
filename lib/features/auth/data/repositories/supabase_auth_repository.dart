import 'dart:async';

import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/data/mappers/supabase_auth_error_mapper.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required this.url,
    required this.anonKey,
    required this.authRedirectUrl,
    GoTrueClient? auth,
  }) : _auth = auth ?? Supabase.instance.client.auth {
    _ensureAuthErrorListener(_auth);
  }

  final String url;
  final String anonKey;
  final String authRedirectUrl;
  final GoTrueClient _auth;

  static final Set<GoTrueClient> _errorListenersInstalled = {};
  static AuthFailure? _bufferedAuthFailure;

  /// Captures auth stream errors that can occur before [AuthViewModel] subscribes.
  static void installEarlyErrorListener(GoTrueClient auth) {
    _ensureAuthErrorListener(auth);
  }

  static void _ensureAuthErrorListener(GoTrueClient auth) {
    if (_errorListenersInstalled.contains(auth)) {
      return;
    }
    _errorListenersInstalled.add(auth);

    auth.onAuthStateChange.listen(
      (_) {},
      onError: (error, _) {
        _bufferedAuthFailure = _mapStreamError(error);
      },
    );
  }

  @override
  AppUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Stream<AppUser?> watchUser() {
    return Stream.multi((controller) {
      final subscription = _auth.onAuthStateChange.listen(
        (event) => controller.add(_mapUser(event.session?.user)),
        onError: (error, stackTrace) {
          final failure = SupabaseAuthRepository._mapStreamError(error);
          _bufferedAuthFailure = failure;
          controller.addError(failure, stackTrace);
        },
      );
      controller.onCancel = () => subscription.cancel();
    });
  }

  @override
  AuthFailure? consumeRecentAuthFailure() {
    final failure = _bufferedAuthFailure;
    _bufferedAuthFailure = null;
    return failure;
  }

  @override
  Future<AppUser?> waitForEmailConfirmationSession({
    required bool Function() isSignedIn,
    required AppUser? Function() readCurrentUser,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final maxAttempts = timeout.inMilliseconds ~/ 100;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (isSignedIn()) {
        return readCurrentUser();
      }

      final failure = consumeRecentAuthFailure();
      if (failure != null) {
        throw failure;
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    throw const AuthFailure('email_link_expired');
  }

  static AuthFailure _mapStreamError(Object error) {
    if (error is AuthFailure) {
      return error;
    }
    if (error is AuthException) {
      return AuthFailure(mapSupabaseAuthCode(error), details: error.message);
    }
    return AuthFailure('auth_error', details: error.toString());
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthFailure('missing_user');
      }

      return AppUser(id: user.id, email: user.email ?? email);
    } on AuthFailure {
      rethrow;
    } on AuthException catch (error) {
      throw AuthFailure(mapSupabaseAuthCode(error), details: error.message);
    } catch (error) {
      throw AuthFailure('network_error', details: error.toString());
    }
  }

  @override
  Future<AppUser?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: authRedirectUrl,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthFailure('missing_user');
      }

      if (response.session == null) {
        return null;
      }

      return AppUser(id: user.id, email: user.email ?? email);
    } on AuthFailure {
      rethrow;
    } on AuthException catch (error) {
      throw AuthFailure(mapSupabaseAuthCode(error), details: error.message);
    } catch (error) {
      throw AuthFailure('network_error', details: error.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (error) {
      throw AuthFailure(mapSupabaseAuthCode(error), details: error.message);
    } catch (error) {
      throw AuthFailure('network_error', details: error.toString());
    }
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AppUser(id: user.id, email: user.email ?? 'unknown@supabase.local');
  }
}
