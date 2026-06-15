import '../../helpers/fake_auth_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/in_memory_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/pages/saved_lessons_page.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/view_models/saved_lessons_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('saved lessons page shows empty state', (tester) async {
    await _pumpSavedLessons(tester, savedLessonIds: const {});

    expect(find.text('Saved lessons'), findsOneWidget);
    expect(find.text('No saved lessons yet.'), findsOneWidget);
  });

  testWidgets('saved lessons page shows saved lessons', (tester) async {
    await _pumpSavedLessons(tester, savedLessonIds: const {'morning-mobility'});

    expect(find.text('Morning Mobility Reset'), findsOneWidget);
    expect(find.text('Strength Foundations'), findsNothing);
  });
}

Future<void> _pumpSavedLessons(
  WidgetTester tester, {
  required Set<String> savedLessonIds,
}) async {
  final viewModel = SavedLessonsViewModel(
    coachingVideoRepository: _FakeCoachingVideoRepository(videos: _videos),
    savedLessonsRepository: InMemorySavedLessonsRepository(
      initialSavedLessonIds: savedLessonIds,
    ),
    authRepository: FakeAuthRepository(),
  );

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SavedLessonsPage(viewModel: viewModel),
    ),
  );
  await tester.pumpAndSettle();
}

final _videos = [
  CoachingVideo(
    id: 'morning-mobility',
    title: 'Morning Mobility Reset',
    description: 'Start the day with gentle movement.',
    category: CoachingVideoCategory.mobility,
    duration: const Duration(minutes: 8),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
  ),
  CoachingVideo(
    id: 'strength-foundations',
    title: 'Strength Foundations',
    description: 'Controlled full-body strength.',
    category: CoachingVideoCategory.strength,
    duration: const Duration(minutes: 14),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
  ),
];

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
