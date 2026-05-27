// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'AI Flutter Šablon';

  @override
  String get homeTitle => 'Početna';

  @override
  String get homeSubtitle => 'Flutter šablon spreman za AI radni tok';

  @override
  String get counterTitle => 'Brojač (BLoC)';

  @override
  String get counterDescription => 'Arhitektura po funkcijama sa flutter_bloc';

  @override
  String get authTitle => 'Autentifikacija (MVVM)';

  @override
  String get authDescription =>
      'Backend-agnostična autentifikacija sa mock, Firebase ili Supabase';

  @override
  String get counterLabel => 'Pritisnuli ste dugme ovoliko puta:';

  @override
  String get incrementTooltip => 'Povećaj';

  @override
  String get signIn => 'Prijavi se';

  @override
  String get signOut => 'Odjavi se';

  @override
  String signedInAs(String email) {
    return 'Prijavljeni ste kao $email';
  }

  @override
  String get notSignedIn => 'Niste prijavljeni';

  @override
  String backendLabel(String backend) {
    return 'Backend: $backend';
  }

  @override
  String flavorLabel(String flavor) {
    return 'Okruženje: $flavor';
  }

  @override
  String get demoEmail => 'demo@primer.rs';

  @override
  String get loading => 'Učitavanje...';
}
