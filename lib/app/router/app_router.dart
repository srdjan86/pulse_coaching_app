import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/supabase_auth_config.dart';
import 'package:pulse_coaching_app/features/auth/presentation/pages/auth_demo_page.dart';
import 'package:pulse_coaching_app/features/auth/presentation/pages/login_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_detail_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_library_page.dart';
import 'package:pulse_coaching_app/features/counter/presentation/pages/counter_page.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/pages/saved_lessons_page.dart';
import 'package:pulse_coaching_app/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (SupabaseAuthConfig.isAuthCallbackUri(state.uri)) {
        return SupabaseAuthConfig.postAuthCallbackLoginLocation;
      }

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
      GoRoute(
        path: '/saved-lessons',
        builder: (context, state) => const SavedLessonsPage(),
      ),
      GoRoute(
        path: '/coaching-videos',
        builder: (context, state) => const CoachingVideoLibraryPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final videoId = state.pathParameters['id']!;
              return CoachingVideoDetailPage(videoId: videoId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthDemoPage(),
        routes: [
          GoRoute(
            path: 'callback',
            redirect: (_, _) =>
                SupabaseAuthConfig.postAuthCallbackLoginLocation,
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
