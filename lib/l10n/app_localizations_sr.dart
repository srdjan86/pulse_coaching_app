// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get homeTitle => 'Početna';

  @override
  String get homeGreeting => 'Dobro jutro';

  @override
  String get homeFocusLabel => 'Fokus dana';

  @override
  String get homeFocusQuote => 'Mali dosledni koraci grade trajne promene.';

  @override
  String get homeExploreSection => 'Istraži';

  @override
  String get homeContinueSection => 'Nastavi';

  @override
  String get homeContinueLoadError => 'Nije moguće učitati nedavne sesije.';

  @override
  String get homeDevSection => 'Developer';

  @override
  String coachingVideosSessionCount(int count) {
    return '$count sesija';
  }

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

  @override
  String get onboardingTitle => 'Dobrodošli u Pulse';

  @override
  String get onboardingSubtitle =>
      'Coaching i dobrobit, prilagođeni vama. Unesite email da biste počeli.';

  @override
  String get onboardingEmailLabel => 'Email';

  @override
  String get onboardingEmailHint => 'vi@primer.rs';

  @override
  String get onboardingCta => 'Započni';

  @override
  String get onboardingEmailInvalid => 'Unesite ispravnu email adresu';

  @override
  String get onboardingSignInPrompt => 'Već imate nalog?';

  @override
  String get onboardingSignInLink => 'Prijavite se';

  @override
  String get onboardingLoadingCta => 'Pokretanje…';

  @override
  String get loginTitle => 'Prijavite se na Pulse';

  @override
  String get loginSubtitle => 'Dobrodošli nazad.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Lozinka';

  @override
  String get loginPasswordHint => 'Vaša lozinka';

  @override
  String get loginEmailRequired => 'Email je obavezan';

  @override
  String get loginPasswordRequired => 'Lozinka je obavezna';

  @override
  String get loginErrorMessage =>
      'Email ili lozinka nisu ispravni. Pokušajte ponovo.';

  @override
  String get loginForgotPassword => 'Zaboravili ste lozinku?';

  @override
  String get loginGetStartedPrompt => 'Novi ste na Pulse-u?';

  @override
  String get loginGetStartedLink => 'Započni';

  @override
  String get coachingVideoCategoryAll => 'Sve';

  @override
  String get coachingVideoAboutSection => 'O ovoj sesiji';

  @override
  String get coachingVideoStartSession => 'Započni sesiju';

  @override
  String get coachingVideoPauseSession => 'Pauziraj sesiju';

  @override
  String get themeSectionDescription =>
      'Izaberite kako Pulse izgleda na vašem uređaju';

  @override
  String get themeOptionLabel => 'Tema';

  @override
  String get coachingVideosTitle => 'Coaching biblioteka';

  @override
  String get coachingVideosDescription =>
      'Pregledajte vođene treninge i lekcije oporavka';

  @override
  String get savedLessonsTitle => 'Sačuvane lekcije';

  @override
  String get savedLessonsDescription => 'Omiljene lekcije spremne za kasnije';

  @override
  String get savedLessonsEmpty => 'Još nema sačuvanih lekcija.';

  @override
  String get savedLessonsLoadError => 'Nije moguće učitati sačuvane lekcije';

  @override
  String get coachingVideoDetailTitle => 'Lekcija';

  @override
  String get coachingVideosEmpty => 'Još nema dostupnih lekcija.';

  @override
  String coachingVideoDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String coachingVideoDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get coachingVideoPlayerMockHint => 'Pregled video reprodukcije';

  @override
  String get coachingVideoPlayerUnavailable =>
      'Video reprodukcija nije dostupna';

  @override
  String get coachingVideoNotFound => 'Lekcija nije pronađena';

  @override
  String get coachingVideoLoadError => 'Nije moguće učitati lekcije';

  @override
  String get coachingVideoSaveLesson => 'Sačuvaj lekciju';

  @override
  String get coachingVideoUnsaveLesson => 'Ukloni iz sačuvanih';

  @override
  String get coachingVideoCategoryMindfulness => 'Svesnost';

  @override
  String get coachingVideoCategoryStrength => 'Snaga';

  @override
  String get coachingVideoCategoryMobility => 'Mobilnost';

  @override
  String get coachingVideoCategoryRecovery => 'Oporavak';

  @override
  String get settingsTitle => 'Podešavanja';

  @override
  String get themeSectionTitle => 'Izgled';

  @override
  String get themeModeSystem => 'Sistem';

  @override
  String get themeModeLight => 'Svetlo';

  @override
  String get themeModeDark => 'Tamno';
}
