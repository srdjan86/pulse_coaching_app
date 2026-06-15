import 'package:pulse_coaching_app/features/saved_lessons/data/sources/saved_lesson_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSavedLessonRemoteDataSource
    implements SavedLessonRemoteDataSource {
  SupabaseSavedLessonRemoteDataSource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'user_saved_lessons';

  @override
  Future<Set<String>> fetchSavedLessonIds(String userId) async {
    final response = await _client
        .from(_table)
        .select('lesson_id')
        .eq('user_id', userId);

    return (response as List<dynamic>)
        .map((row) => (row as Map<String, dynamic>)['lesson_id'] as String)
        .toSet();
  }

  @override
  Future<void> save(String userId, String lessonId) async {
    await _client.from(_table).upsert({
      'user_id': userId,
      'lesson_id': lessonId,
    });
  }

  @override
  Future<void> unsave(String userId, String lessonId) async {
    await _client
        .from(_table)
        .delete()
        .eq('user_id', userId)
        .eq('lesson_id', lessonId);
  }
}
