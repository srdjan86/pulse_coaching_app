import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/mock_coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_library_view_model.dart';
import 'package:pulse_coaching_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:pulse_coaching_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:pulse_coaching_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:pulse_coaching_app/features/onboarding/data/repositories/shared_preferences_onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/features/settings/data/repositories/shared_preferences_theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/domain/repositories/theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(
  AppConfig config, {
  SharedPreferences? preferences,
  OnboardingRepository? onboardingRepository,
}) async {
  if (getIt.isRegistered<AppConfig>()) {
    return;
  }

  getIt.registerSingleton<AppConfig>(config);

  final prefs = preferences ?? await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<CounterRepository>(CounterRepositoryImpl.new);
  getIt.registerFactory(() => CounterBloc(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
    () => _createAuthRepository(config),
  );
  getIt.registerFactory(() => AuthViewModel(getIt()));

  getIt.registerLazySingleton<OnboardingRepository>(
    () =>
        onboardingRepository ?? SharedPreferencesOnboardingRepository(getIt()),
  );
  getIt.registerLazySingleton<OnboardingViewModel>(
    () => OnboardingViewModel(repository: getIt()),
  );

  getIt.registerLazySingleton<ThemePreferencesRepository>(
    () => SharedPreferencesThemePreferencesRepository(getIt()),
  );
  getIt.registerLazySingleton<ThemeSettingsViewModel>(
    () => ThemeSettingsViewModel(getIt()),
  );

  getIt.registerLazySingleton<CoachingVideoRepository>(
    MockCoachingVideoRepository.new,
  );
  getIt.registerFactory(() => HomeViewModel(getIt()));
  getIt.registerFactory(() => CoachingVideoLibraryViewModel(getIt()));
  getIt.registerFactory(() => CoachingVideoDetailViewModel(getIt()));
}

AuthRepository _createAuthRepository(AppConfig config) {
  return switch (config.backend) {
    BackendType.firebase => FirebaseAuthRepository(),
    BackendType.supabase => SupabaseAuthRepository(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
    ),
    BackendType.mock => MockAuthRepository(),
  };
}
