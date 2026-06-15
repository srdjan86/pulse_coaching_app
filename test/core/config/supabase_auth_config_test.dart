import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coaching_app/core/config/supabase_auth_config.dart';

void main() {
  group('SupabaseAuthConfig.isAuthCallbackUri', () {
    test('matches pulsecoaching auth callback deep link', () {
      expect(
        SupabaseAuthConfig.isAuthCallbackUri(
          Uri.parse('pulsecoaching://auth/callback?code=abc'),
        ),
        isTrue,
      );
    });

    test('matches go_router style auth callback path', () {
      expect(
        SupabaseAuthConfig.isAuthCallbackUri(
          Uri.parse('/auth/callback?code=abc'),
        ),
        isTrue,
      );
    });

    test('does not match regular app routes', () {
      expect(
        SupabaseAuthConfig.isAuthCallbackUri(Uri.parse('/login')),
        isFalse,
      );
      expect(SupabaseAuthConfig.isAuthCallbackUri(Uri.parse('/auth')), isFalse);
    });
  });

  group('SupabaseAuthConfig.isEmailConfirmationDeepLink', () {
    test('detects email confirmation login deep link query', () {
      expect(
        SupabaseAuthConfig.isEmailConfirmationDeepLink(
          Uri.parse('/login?fromEmailConfirmation=1'),
        ),
        isTrue,
      );
      expect(
        SupabaseAuthConfig.isEmailConfirmationDeepLink(Uri.parse('/login')),
        isFalse,
      );
    });
  });
}
