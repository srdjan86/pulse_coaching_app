import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('formats minute durations', () {
    expect(
      formatCoachingVideoDuration(const Duration(minutes: 12), l10n),
      '12 min',
    );
  });

  test('formats hour and minute durations', () {
    expect(
      formatCoachingVideoDuration(const Duration(minutes: 75), l10n),
      '1 h 15 min',
    );
  });

  test('maps category labels', () {
    expect(
      coachingVideoCategoryLabel(CoachingVideoCategory.mobility, l10n),
      'Mobility',
    );
  });
}
