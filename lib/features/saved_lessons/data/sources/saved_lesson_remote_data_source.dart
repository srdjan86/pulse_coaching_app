abstract class SavedLessonRemoteDataSource {
  Future<Set<String>> fetchSavedLessonIds(String userId);

  Future<void> save(String userId, String lessonId);

  Future<void> unsave(String userId, String lessonId);
}
