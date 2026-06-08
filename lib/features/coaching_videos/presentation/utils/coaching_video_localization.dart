import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';

String formatCoachingVideoDuration(Duration duration, AppLocalizations l10n) {
  final minutes = duration.inMinutes;
  if (minutes < 60) {
    return l10n.coachingVideoDurationMinutes(minutes);
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return l10n.coachingVideoDurationHoursMinutes(hours, remainingMinutes);
}

String coachingVideoCategoryLabel(
  CoachingVideoCategory category,
  AppLocalizations l10n,
) {
  return switch (category) {
    CoachingVideoCategory.mindfulness => l10n.coachingVideoCategoryMindfulness,
    CoachingVideoCategory.strength => l10n.coachingVideoCategoryStrength,
    CoachingVideoCategory.mobility => l10n.coachingVideoCategoryMobility,
    CoachingVideoCategory.recovery => l10n.coachingVideoCategoryRecovery,
  };
}
