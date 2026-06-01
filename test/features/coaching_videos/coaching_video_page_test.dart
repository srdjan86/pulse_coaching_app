import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_detail_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_library_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_library_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('library page renders video cards', (tester) async {
    await _pumpLibrary(tester);

    expect(find.text('Coaching library'), findsOneWidget);
    expect(find.text(_video.title), findsOneWidget);
    expect(find.text('Mobility'), findsOneWidget);
    expect(find.text('8 min'), findsOneWidget);
  });

  testWidgets('library tap navigates to detail page', (tester) async {
    await _pumpLibrary(tester, withRouter: true);

    await tester.tap(find.text(_video.title));
    await tester.pumpAndSettle();

    expect(find.text('Lesson'), findsOneWidget);
    expect(find.text('Video playback preview'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text(_video.description), findsOneWidget);
  });

  testWidgets('detail page shows not found state', (tester) async {
    final repository = _FakeCoachingVideoRepository(videos: const []);
    final viewModel = CoachingVideoDetailViewModel(repository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CoachingVideoDetailPage(
          videoId: 'missing',
          viewModel: viewModel,
          enablePlayback: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lesson not found'), findsOneWidget);
  });
}

Future<void> _pumpLibrary(
  WidgetTester tester, {
  bool withRouter = false,
}) async {
  final repository = _FakeCoachingVideoRepository(videos: [_video]);
  final libraryPage = CoachingVideoLibraryPage(
    viewModel: CoachingVideoLibraryViewModel(repository),
  );

  if (withRouter) {
    final router = GoRouter(
      initialLocation: '/coaching-videos',
      routes: [
        GoRoute(
          path: '/coaching-videos',
          builder: (context, state) => libraryPage,
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => CoachingVideoDetailPage(
                videoId: state.pathParameters['id']!,
                viewModel: CoachingVideoDetailViewModel(repository),
                enablePlayback: false,
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  } else {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: libraryPage,
      ),
    );
  }

  await tester.pumpAndSettle();
}

final _video = CoachingVideo(
  id: 'morning-mobility',
  title: 'Morning Mobility Reset',
  description: 'Start the day with gentle movement.',
  category: CoachingVideoCategory.mobility,
  duration: const Duration(minutes: 8),
  videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
);

class _FakeCoachingVideoRepository implements CoachingVideoRepository {
  _FakeCoachingVideoRepository({required this.videos});

  final List<CoachingVideo> videos;

  @override
  Future<List<CoachingVideo>> getVideos() async => videos;

  @override
  Future<CoachingVideo?> getVideoById(String id) async {
    for (final video in videos) {
      if (video.id == id) {
        return video;
      }
    }
    return null;
  }
}
