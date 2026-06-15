import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  /// Application title shown in the app bar
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreeting;

  /// No description provided for @homeFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus'**
  String get homeFocusLabel;

  /// No description provided for @homeFocusQuote.
  ///
  /// In en, this message translates to:
  /// **'Small consistent steps build lasting change.'**
  String get homeFocusQuote;

  /// No description provided for @homeExploreSection.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get homeExploreSection;

  /// No description provided for @homeContinueSection.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get homeContinueSection;

  /// No description provided for @homeContinueLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load recent sessions.'**
  String get homeContinueLoadError;

  /// No description provided for @homeDevSection.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get homeDevSection;

  /// No description provided for @coachingVideosSessionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String coachingVideosSessionCount(int count);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-ready Flutter delivery template'**
  String get homeSubtitle;

  /// No description provided for @counterTitle.
  ///
  /// In en, this message translates to:
  /// **'Counter (BLoC)'**
  String get counterTitle;

  /// No description provided for @counterDescription.
  ///
  /// In en, this message translates to:
  /// **'Feature-first architecture with flutter_bloc'**
  String get counterDescription;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Auth (MVVM)'**
  String get authTitle;

  /// No description provided for @authDescription.
  ///
  /// In en, this message translates to:
  /// **'Backend-agnostic auth with mock, Firebase, or Supabase'**
  String get authDescription;

  /// No description provided for @counterLabel.
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get counterLabel;

  /// No description provided for @incrementTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementTooltip;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @backendLabel.
  ///
  /// In en, this message translates to:
  /// **'Backend: {backend}'**
  String backendLabel(String backend);

  /// No description provided for @flavorLabel.
  ///
  /// In en, this message translates to:
  /// **'Flavor: {flavor}'**
  String flavorLabel(String flavor);

  /// No description provided for @demoEmail.
  ///
  /// In en, this message translates to:
  /// **'demo@example.com'**
  String get demoEmail;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Onboarding screen headline
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pulse'**
  String get onboardingTitle;

  /// Onboarding screen supporting text
  ///
  /// In en, this message translates to:
  /// **'Coaching and wellness, tailored for you. Enter your email to get started.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get onboardingEmailLabel;

  /// No description provided for @onboardingEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get onboardingEmailHint;

  /// No description provided for @onboardingCta.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingCta;

  /// No description provided for @onboardingEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get onboardingEmailInvalid;

  /// No description provided for @onboardingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get onboardingSignInPrompt;

  /// No description provided for @onboardingSignInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get onboardingSignInLink;

  /// No description provided for @onboardingLoadingCta.
  ///
  /// In en, this message translates to:
  /// **'Getting started…'**
  String get onboardingLoadingCta;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Pulse'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get loginPasswordHint;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get signUpPasswordHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordTooShort;

  /// No description provided for @loginErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect. Please try again.'**
  String get loginErrorMessage;

  /// No description provided for @loginGenericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get loginGenericErrorMessage;

  /// No description provided for @loginNetworkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection and try again.'**
  String get loginNetworkErrorMessage;

  /// No description provided for @loginMockCredentialsHint.
  ///
  /// In en, this message translates to:
  /// **'Mock backend demo: demo@example.com / password'**
  String get loginMockCredentialsHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginGetStartedPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to Pulse?'**
  String get loginGetStartedPrompt;

  /// No description provided for @loginGetStartedLink.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get loginGetStartedLink;

  /// No description provided for @loginNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccountPrompt;

  /// No description provided for @loginHasAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get loginHasAccountPrompt;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save lessons and sync across devices.'**
  String get signUpSubtitle;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpButton;

  /// No description provided for @signUpConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created. Confirm your email, then sign in.'**
  String get signUpConfirmationMessage;

  /// No description provided for @loginEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email before signing in.'**
  String get loginEmailNotConfirmed;

  /// No description provided for @loginUserAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Try signing in.'**
  String get loginUserAlreadyRegistered;

  /// No description provided for @loginWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password and try again.'**
  String get loginWeakPassword;

  /// No description provided for @accountSignedInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved lessons sync to your account. Tap to sign out.'**
  String get accountSignedInSubtitle;

  /// No description provided for @coachingVideoCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get coachingVideoCategoryAll;

  /// No description provided for @coachingVideoAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About this session'**
  String get coachingVideoAboutSection;

  /// No description provided for @coachingVideoStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get coachingVideoStartSession;

  /// No description provided for @coachingVideoPauseSession.
  ///
  /// In en, this message translates to:
  /// **'Pause session'**
  String get coachingVideoPauseSession;

  /// No description provided for @themeSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how Pulse looks on your device'**
  String get themeSectionDescription;

  /// No description provided for @themeOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeOptionLabel;

  /// No description provided for @coachingVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'Coaching library'**
  String get coachingVideosTitle;

  /// No description provided for @coachingVideosDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse guided workout and recovery lessons'**
  String get coachingVideosDescription;

  /// No description provided for @savedLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved lessons'**
  String get savedLessonsTitle;

  /// No description provided for @savedLessonsDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep favorite lessons ready for later'**
  String get savedLessonsDescription;

  /// No description provided for @savedLessonsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved lessons yet.'**
  String get savedLessonsEmpty;

  /// No description provided for @savedLessonsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load saved lessons'**
  String get savedLessonsLoadError;

  /// No description provided for @coachingVideoDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get coachingVideoDetailTitle;

  /// No description provided for @coachingVideosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lessons available yet.'**
  String get coachingVideosEmpty;

  /// No description provided for @coachingVideoDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String coachingVideoDurationMinutes(int minutes);

  /// No description provided for @coachingVideoDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String coachingVideoDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @coachingVideoPlayerMockHint.
  ///
  /// In en, this message translates to:
  /// **'Video playback preview'**
  String get coachingVideoPlayerMockHint;

  /// No description provided for @coachingVideoPlayerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video playback is unavailable'**
  String get coachingVideoPlayerUnavailable;

  /// No description provided for @coachingVideoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Lesson not found'**
  String get coachingVideoNotFound;

  /// No description provided for @coachingVideoLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load lessons'**
  String get coachingVideoLoadError;

  /// No description provided for @coachingVideoSaveLesson.
  ///
  /// In en, this message translates to:
  /// **'Save lesson'**
  String get coachingVideoSaveLesson;

  /// No description provided for @coachingVideoUnsaveLesson.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get coachingVideoUnsaveLesson;

  /// No description provided for @coachingVideoCategoryMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness'**
  String get coachingVideoCategoryMindfulness;

  /// No description provided for @coachingVideoCategoryStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get coachingVideoCategoryStrength;

  /// No description provided for @coachingVideoCategoryMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get coachingVideoCategoryMobility;

  /// No description provided for @coachingVideoCategoryRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get coachingVideoCategoryRecovery;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeSectionTitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
