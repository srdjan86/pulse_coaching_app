class LessonDto {
  const LessonDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationSeconds,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final int durationSeconds;
  final String videoUrl;
  final String? thumbnailUrl;

  factory LessonDto.fromJson(Map<String, dynamic> json) {
    return LessonDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      durationSeconds: json['duration_seconds'] as int,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}
