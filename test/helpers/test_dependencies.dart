import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> configureTestDependencies(
  AppConfig config, {
  InMemoryOnboardingRepository? onboardingRepository,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  await configureDependencies(
    config,
    preferences: preferences,
    onboardingRepository:
        onboardingRepository ?? InMemoryOnboardingRepository(),
  );
}
