import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coaching_app/features/auth/data/mappers/supabase_auth_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapSupabaseAuthCode', () {
    test('maps invalid login credentials', () {
      expect(
        mapSupabaseAuthCode(const AuthException('Invalid login credentials')),
        'invalid_login_credentials',
      );
    });

    test('maps email not confirmed', () {
      expect(
        mapSupabaseAuthCode(const AuthException('Email not confirmed')),
        'email_not_confirmed',
      );
    });

    test('maps user already registered', () {
      expect(
        mapSupabaseAuthCode(const AuthException('User already registered')),
        'user_already_registered',
      );
    });

    test('maps weak password', () {
      expect(
        mapSupabaseAuthCode(
          const AuthException('Password should be at least 6 characters'),
        ),
        'weak_password',
      );
    });

    test('maps email rate limit exceeded', () {
      expect(
        mapSupabaseAuthCode(const AuthException('email rate limit exceeded')),
        'email_rate_limit_exceeded',
      );
    });

    test('maps expired email confirmation link', () {
      expect(
        mapSupabaseAuthCode(
          const AuthException(
            'Email link is invalid or has expired',
            statusCode: 'otp_expired',
            code: 'access_denied',
          ),
        ),
        'email_link_expired',
      );
    });

    test('falls back to auth_error', () {
      expect(
        mapSupabaseAuthCode(const AuthException('Something unexpected')),
        'auth_error',
      );
    });
  });
}
