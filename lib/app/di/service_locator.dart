import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/mock_coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/supabase_coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/sources/supabase_lesson_remote_data_source.dart';
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
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/backend_aware_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/shared_preferences_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/supabase_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/sources/supabase_saved_lesson_remote_data_source.dart';
import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/view_models/saved_lessons_view_model.dart';
import 'package:pulse_coaching_app/features/settings/data/repositories/shared_preferences_theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/domain/repositories/theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(
  AppConfig config, {
  SharedPreferences? preferences,
  OnboardingRepository? onboardingRepository,
  SavedLessonsRepository? savedLessonsRepository,
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
  getIt.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(getIt()),
    dispose: (viewModel) => viewModel.dispose(),
  );

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
    () => _createCoachingVideoRepository(config),
  );
  getIt.registerLazySingleton<SavedLessonsRepository>(
    () =>
        savedLessonsRepository ?? _createSavedLessonsRepository(config, prefs),
  );
  getIt.registerFactory(() => HomeViewModel(getIt()));
  getIt.registerFactory(() => CoachingVideoLibraryViewModel(getIt()));
  getIt.registerFactory(
    () => CoachingVideoDetailViewModel(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => SavedLessonsViewModel(
      coachingVideoRepository: getIt(),
      savedLessonsRepository: getIt(),
      authRepository: getIt(),
    ),
  );
}

AuthRepository _createAuthRepository(AppConfig config) {
  return switch (config.backend) {
    BackendType.firebase => FirebaseAuthRepository(),
    BackendType.supabase => SupabaseAuthRepository(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
      authRedirectUrl: config.supabaseAuthRedirectUrl,
    ),
    BackendType.mock => MockAuthRepository(),
  };
}

CoachingVideoRepository _createCoachingVideoRepository(AppConfig config) {
  return switch (config.backend) {
    BackendType.supabase => SupabaseCoachingVideoRepository(
      SupabaseLessonRemoteDataSource(),
    ),
    BackendType.firebase => MockCoachingVideoRepository(),
    BackendType.mock => MockCoachingVideoRepository(),
  };
}

SavedLessonsRepository _createSavedLessonsRepository(
  AppConfig config,
  SharedPreferences preferences,
) {
  final local = SharedPreferencesSavedLessonsRepository(preferences);

  return switch (config.backend) {
    BackendType.supabase => BackendAwareSavedLessonsRepository(
      backend: config.backend,
      local: local,
      remote: SupabaseSavedLessonsRepository(
        SupabaseSavedLessonRemoteDataSource(),
        userIdProvider: () => Supabase.instance.client.auth.currentUser?.id,
      ),
      currentUserId: () => Supabase.instance.client.auth.currentUser?.id,
    ),
    BackendType.firebase => local,
    BackendType.mock => local,
  };
}
