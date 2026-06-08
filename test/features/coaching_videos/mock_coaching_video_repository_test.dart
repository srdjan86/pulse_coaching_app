import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/mock_coaching_video_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getVideos returns mock videos', () async {
    final repository = MockCoachingVideoRepository();

    final videos = await repository.getVideos();

    expect(videos, isNotEmpty);
    expect(videos.first.title, 'Morning Mobility Reset');
  });

  test('getVideoById returns matching video', () async {
    final repository = MockCoachingVideoRepository();

    final video = await repository.getVideoById('morning-mobility');

    expect(video, isNotNull);
    expect(video?.id, 'morning-mobility');
  });

  test('getVideoById returns null for unknown id', () async {
    final repository = MockCoachingVideoRepository();

    final video = await repository.getVideoById('unknown');

    expect(video, isNull);
  });
}
