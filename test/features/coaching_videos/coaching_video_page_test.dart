import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_detail_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/pages/coaching_video_library_page.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_library_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_card.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('library page renders video cards', (tester) async {
    await _pumpLibrary(tester);

    expect(find.text('Coaching library'), findsOneWidget);
    expect(find.text(_video.title), findsOneWidget);
    expect(find.byType(CoachingVideoCard), findsOneWidget);
    expect(find.text('8 min'), findsOneWidget);
  });

  testWidgets('detail page shows lesson content', (tester) async {
    final repository = _FakeCoachingVideoRepository(videos: [_video]);
    final viewModel = CoachingVideoDetailViewModel(repository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CoachingVideoDetailPage(
          videoId: 'morning-mobility',
          viewModel: viewModel,
          enablePlayback: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('ABOUT THIS SESSION'), findsOneWidget);
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

Future<void> _pumpLibrary(WidgetTester tester) async {
  final repository = _FakeCoachingVideoRepository(videos: [_video]);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CoachingVideoLibraryPage(
        viewModel: CoachingVideoLibraryViewModel(repository),
      ),
    ),
  );
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
