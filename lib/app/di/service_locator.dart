import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:pulse_coaching_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  if (getIt.isRegistered<AppConfig>()) {
    return;
  }

  getIt.registerSingleton<AppConfig>(config);

  getIt.registerLazySingleton<CounterRepository>(CounterRepositoryImpl.new);
  getIt.registerFactory(() => CounterBloc(getIt()));

  getIt.registerLazySingleton<AuthRepository>(
    () => _createAuthRepository(config),
  );
  getIt.registerFactory(() => AuthViewModel(getIt()));
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
