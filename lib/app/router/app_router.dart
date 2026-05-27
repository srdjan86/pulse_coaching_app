import 'package:pulse_coaching_app/features/auth/presentation/pages/auth_demo_page.dart';
import 'package:pulse_coaching_app/features/counter/presentation/pages/counter_page.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/onboarding',
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
      GoRoute(path: '/auth', builder: (context, state) => const AuthDemoPage()),
    ],
  );
}
