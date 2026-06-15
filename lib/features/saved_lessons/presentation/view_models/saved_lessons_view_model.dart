import 'dart:async';

import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';
import 'package:flutter/material.dart';

class SavedLessonsViewModel extends ChangeNotifier {
  SavedLessonsViewModel({
    required CoachingVideoRepository coachingVideoRepository,
    required SavedLessonsRepository savedLessonsRepository,
    required AuthRepository authRepository,
  }) : _coachingVideoRepository = coachingVideoRepository,
       _savedLessonsRepository = savedLessonsRepository {
    _authSubscription = authRepository.watchUser().listen((_) {
      if (_isLoaded) {
        unawaited(load());
      }
    });
  }

  final CoachingVideoRepository _coachingVideoRepository;
  final SavedLessonsRepository _savedLessonsRepository;
  late final StreamSubscription<AppUser?> _authSubscription;

  List<CoachingVideo> _savedVideos = const [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _isLoaded = false;

  List<CoachingVideo> get savedVideos => _savedVideos;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final savedIds = await _savedLessonsRepository.getSavedLessonIds();
      final videos = await _coachingVideoRepository.getVideos();
      _savedVideos = videos
          .where((video) => savedIds.contains(video.id))
          .toList();
      _isLoaded = true;
    } catch (_) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
