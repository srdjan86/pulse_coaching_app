import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:flutter/material.dart';

class CoachingVideoDetailViewModel extends ChangeNotifier {
  CoachingVideoDetailViewModel(this._repository);

  final CoachingVideoRepository _repository;

  CoachingVideo? _video;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoaded = false;

  CoachingVideo? get video => _video;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoaded => _isLoaded;

  Future<void> load(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _video = await _repository.getVideoById(id);
      _isLoaded = true;
    } catch (_) {
      _errorMessage = 'Could not load lesson';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
