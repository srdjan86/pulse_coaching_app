abstract class SavedLessonsRepository {
  Future<Set<String>> getSavedLessonIds();

  Future<bool> isSaved(String lessonId);

  Future<void> save(String lessonId);

  Future<void> unsave(String lessonId);

  /// Copies guest/local saves to the remote store after sign-in.
  Future<void> promoteLocalSavesOnSignIn();
}
