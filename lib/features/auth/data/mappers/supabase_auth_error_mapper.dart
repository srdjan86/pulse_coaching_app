import 'package:supabase_flutter/supabase_flutter.dart';

String mapSupabaseAuthCode(AuthException error) {
  final message = error.message.toLowerCase();

  if (message.contains('invalid login credentials')) {
    return 'invalid_login_credentials';
  }
  if (message.contains('email not confirmed')) {
    return 'email_not_confirmed';
  }
  if (message.contains('user already registered')) {
    return 'user_already_registered';
  }
  if (message.contains('password')) {
    return 'weak_password';
  }

  return 'auth_error';
}
