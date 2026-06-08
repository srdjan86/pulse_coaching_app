import 'package:equatable/equatable.dart';

enum CoachingVideoCategory { mindfulness, strength, mobility, recovery }

class CoachingVideo extends Equatable {
  const CoachingVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String description;
  final CoachingVideoCategory category;
  final Duration duration;
  final Uri videoUrl;
  final Uri? thumbnailUrl;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    duration,
    videoUrl,
    thumbnailUrl,
  ];
}
