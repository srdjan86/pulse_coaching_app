/// Deep link used for Supabase email confirmation and other auth callbacks.
///
/// Must match Android/iOS URL scheme config and Supabase Auth redirect allowlist.
class SupabaseAuthConfig {
  SupabaseAuthConfig._();

  static const defaultRedirectUrl = 'pulsecoaching://auth/callback';

  /// In-app route after Supabase finishes handling [defaultRedirectUrl].
  static const postAuthCallbackLocation = '/login';

  /// Query flag set when the user arrives from an email confirmation deep link.
  static const emailConfirmationQueryParam = 'fromEmailConfirmation';

  static String get postAuthCallbackLoginLocation =>
      '$postAuthCallbackLocation?$emailConfirmationQueryParam=1';

  static bool isEmailConfirmationDeepLink(Uri uri) {
    return uri.queryParameters[emailConfirmationQueryParam] == '1';
  }

  static final Uri _defaultRedirectUri = Uri.parse(defaultRedirectUrl);

  /// Whether [uri] is the Supabase auth callback deep link (not an app screen).
  static bool isAuthCallbackUri(Uri uri) {
    if (uri.scheme == _defaultRedirectUri.scheme &&
        uri.host == _defaultRedirectUri.host &&
        uri.path == _defaultRedirectUri.path) {
      return true;
    }

    return uri.path ==
        '/${_defaultRedirectUri.host}${_defaultRedirectUri.path}';
  }
}
