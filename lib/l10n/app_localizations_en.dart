// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeGreeting => 'Good morning';

  @override
  String get homeFocusLabel => 'Today\'s focus';

  @override
  String get homeFocusQuote => 'Small consistent steps build lasting change.';

  @override
  String get homeExploreSection => 'Explore';

  @override
  String get homeContinueSection => 'Continue';

  @override
  String get homeDevSection => 'Developer';

  @override
  String coachingVideosSessionCount(int count) {
    return '$count sessions';
  }

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

  @override
  String get onboardingTitle => 'Welcome to Pulse';

  @override
  String get onboardingSubtitle =>
      'Coaching and wellness, tailored for you. Enter your email to get started.';

  @override
  String get onboardingEmailLabel => 'Email';

  @override
  String get onboardingEmailHint => 'you@example.com';

  @override
  String get onboardingCta => 'Get started';

  @override
  String get onboardingEmailInvalid => 'Enter a valid email address';

  @override
  String get onboardingSignInPrompt => 'Already have an account?';

  @override
  String get onboardingSignInLink => 'Sign in';

  @override
  String get onboardingLoadingCta => 'Getting started…';

  @override
  String get loginTitle => 'Sign in to Pulse';

  @override
  String get loginSubtitle => 'Welcome back.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Your password';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginErrorMessage =>
      'Email or password is incorrect. Please try again.';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginGetStartedPrompt => 'New to Pulse?';

  @override
  String get loginGetStartedLink => 'Get started';

  @override
  String get coachingVideoCategoryAll => 'All';

  @override
  String get coachingVideoAboutSection => 'About this session';

  @override
  String get coachingVideoStartSession => 'Start session';

  @override
  String get coachingVideoPauseSession => 'Pause session';

  @override
  String get themeSectionDescription => 'Choose how Pulse looks on your device';

  @override
  String get themeOptionLabel => 'Theme';

  @override
  String get coachingVideosTitle => 'Coaching library';

  @override
  String get coachingVideosDescription =>
      'Browse guided workout and recovery lessons';

  @override
  String get coachingVideoDetailTitle => 'Lesson';

  @override
  String get coachingVideosEmpty => 'No lessons available yet.';

  @override
  String coachingVideoDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String coachingVideoDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get coachingVideoPlayerMockHint => 'Video playback preview';

  @override
  String get coachingVideoPlayerUnavailable => 'Video playback is unavailable';

  @override
  String get coachingVideoNotFound => 'Lesson not found';

  @override
  String get coachingVideoLoadError => 'Could not load lessons';

  @override
  String get coachingVideoCategoryMindfulness => 'Mindfulness';

  @override
  String get coachingVideoCategoryStrength => 'Strength';

  @override
  String get coachingVideoCategoryMobility => 'Mobility';

  @override
  String get coachingVideoCategoryRecovery => 'Recovery';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeSectionTitle => 'Appearance';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';
}
