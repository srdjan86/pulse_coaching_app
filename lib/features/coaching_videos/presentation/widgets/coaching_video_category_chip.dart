import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:flutter/material.dart';

typedef CoachingVideoCategoryStyle = ({Color background, Color foreground});

CoachingVideoCategoryStyle coachingVideoCategoryStyle(
  CoachingVideoCategory category,
) {
  return switch (category) {
    CoachingVideoCategory.mindfulness => (
      background: const Color(0x2E7AACAC),
      foreground: const Color(0xFF0D7377),
    ),
    CoachingVideoCategory.strength => (
      background: const Color(0x240D7377),
      foreground: const Color(0xFF0D7377),
    ),
    CoachingVideoCategory.mobility => (
      background: const Color(0x2414BDBC),
      foreground: const Color(0xFF0A5A5E),
    ),
    CoachingVideoCategory.recovery => (
      background: const Color(0x244A6B6B),
      foreground: const Color(0xFF4A6B6B),
    ),
  };
}

class PulseCategoryChip extends StatelessWidget {
  const PulseCategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Material(
      color: selected ? colors.primary : colors.surfaceContainer,
      borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: selected ? colors.onPrimary : colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class PulseCategoryBadge extends StatelessWidget {
  const PulseCategoryBadge({
    required this.label,
    required this.category,
    super.key,
  });

  final String label;
  final CoachingVideoCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = coachingVideoCategoryStyle(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: style.foreground),
      ),
    );
  }
}
