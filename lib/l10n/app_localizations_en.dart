// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Flutter Template';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeSubtitle => 'AI-ready Flutter delivery template';

  @override
  String get counterTitle => 'Counter (BLoC)';

  @override
  String get counterDescription =>
      'Feature-first architecture with flutter_bloc';

  @override
  String get authTitle => 'Auth (MVVM)';

  @override
  String get authDescription =>
      'Backend-agnostic auth with mock, Firebase, or Supabase';

  @override
  String get counterLabel => 'You have pushed the button this many times:';

  @override
  String get incrementTooltip => 'Increment';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String backendLabel(String backend) {
    return 'Backend: $backend';
  }

  @override
  String flavorLabel(String flavor) {
    return 'Flavor: $flavor';
  }

  @override
  String get demoEmail => 'demo@example.com';

  @override
  String get loading => 'Loading...';
}
