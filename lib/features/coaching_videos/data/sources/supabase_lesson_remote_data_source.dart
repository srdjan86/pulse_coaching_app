import 'package:pulse_coaching_app/features/coaching_videos/data/dto/lesson_dto.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/sources/lesson_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseLessonRemoteDataSource implements LessonRemoteDataSource {
  SupabaseLessonRemoteDataSource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'lessons';

  @override
  Future<List<LessonDto>> fetchPublishedLessons() async {
    final response = await _client
        .from(_table)
        .select()
        .eq('published', true)
        .order('sort_order');

    return (response as List<dynamic>)
        .map((row) => LessonDto.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LessonDto?> fetchLessonById(String id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .eq('published', true)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return LessonDto.fromJson(response);
  }
}
