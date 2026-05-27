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
  Stream<AppUser?> watchUser() {
    return _auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) {
        return null;
      }

      return AppUser(
        id: user.id,
        email: user.email ?? 'unknown@supabase.local',
      );
    });
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw StateError('Supabase sign-in succeeded without a user.');
    }

    return AppUser(id: user.id, email: user.email ?? email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
