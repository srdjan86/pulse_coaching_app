import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/features/auth/presentation/pages/auth_demo_page.dart';
import 'package:pulse_coaching_app/features/auth/presentation/pages/login_page.dart';
import 'package:pulse_coaching_app/features/counter/presentation/pages/counter_page.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final completed = getIt<OnboardingViewModel>().hasCompletedOnboarding;
      final goingToOnboarding = state.matchedLocation == '/onboarding';

      if (!completed && !goingToOnboarding) {
        return '/onboarding';
      }
      if (completed && goingToOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/counter',
        builder: (context, state) => const CounterPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthDemoPage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
