import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:flutter/material.dart';

class CoachingVideoThumbnail extends StatelessWidget {
  const CoachingVideoThumbnail({
    required this.category,
    required this.title,
    this.thumbnailUrl,
    super.key,
  });

  final CoachingVideoCategory category;
  final String title;
  final Uri? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _categoryColor(category, theme.colorScheme);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnailUrl != null)
                Image.network(
                  thumbnailUrl.toString(),
                  fit: BoxFit.cover,
                  semanticLabel: title,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                ),
              ),
              Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(
    CoachingVideoCategory category,
    ColorScheme colorScheme,
  ) {
    return switch (category) {
      CoachingVideoCategory.mindfulness => colorScheme.primary,
      CoachingVideoCategory.strength => colorScheme.tertiary,
      CoachingVideoCategory.mobility => colorScheme.secondary,
      CoachingVideoCategory.recovery => colorScheme.error,
    };
  }
}
