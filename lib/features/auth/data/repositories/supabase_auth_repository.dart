import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/data/mappers/supabase_auth_error_mapper.dart';
import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required this.url,
    required this.anonKey,
    GoTrueClient? auth,
  }) : _auth = auth ?? Supabase.instance.client.auth;

  final String url;
  final String anonKey;
  final GoTrueClient _auth;

  @override
  AppUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Stream<AppUser?> watchUser() {
    return _auth.onAuthStateChange.map(
      (event) => _mapUser(event.session?.user),
    );
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
      final response = await _auth.signUp(email: email, password: password);
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
