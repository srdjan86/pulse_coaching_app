import 'dart:async';

import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';
import 'package:pulse_coaching_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';
import 'package:flutter/material.dart';

class CoachingVideoDetailViewModel extends ChangeNotifier {
  CoachingVideoDetailViewModel(
    this._repository,
    this._savedLessonsRepository,
    AuthRepository authRepository,
  ) {
    _authSubscription = authRepository.watchUser().listen((_) {
      unawaited(_refreshSavedState());
    });
  }

  final CoachingVideoRepository _repository;
  final SavedLessonsRepository _savedLessonsRepository;
  late final StreamSubscription<AppUser?> _authSubscription;

  CoachingVideo? _video;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isLoaded = false;
  bool _isSaved = false;

  CoachingVideo? get video => _video;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isLoaded => _isLoaded;
  bool get isSaved => _isSaved;

  Future<void> load(String id) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _video = await _repository.getVideoById(id);
      _isSaved = _video != null && await _savedLessonsRepository.isSaved(id);
      _isLoaded = true;
    } catch (_) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshSavedState() async {
    final video = _video;
    if (video == null || !_isLoaded) {
      return;
    }

    final isSaved = await _savedLessonsRepository.isSaved(video.id);
    if (isSaved == _isSaved) {
      return;
    }

    _isSaved = isSaved;
    notifyListeners();
  }

  Future<void> toggleSaved() async {
    final video = _video;
    if (video == null) return;

    if (_isSaved) {
      await _savedLessonsRepository.unsave(video.id);
      _isSaved = false;
    } else {
      await _savedLessonsRepository.save(video.id);
      _isSaved = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
