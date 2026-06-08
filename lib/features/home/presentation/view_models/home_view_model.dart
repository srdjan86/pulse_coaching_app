import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._coachingVideoRepository);

  final CoachingVideoRepository _coachingVideoRepository;

  List<CoachingVideo> _continueVideos = const [];
  int _sessionCount = 0;
  bool _isLoaded = false;
  bool _hasError = false;

  List<CoachingVideo> get continueVideos => _continueVideos;
  int get sessionCount => _sessionCount;
  bool get isLoaded => _isLoaded;
  bool get hasError => _hasError;

  Future<void> load() async {
    try {
      final videos = await _coachingVideoRepository.getVideos();
      _sessionCount = videos.length;
      _continueVideos = videos.take(2).toList();
      _hasError = false;
    } catch (_) {
      _sessionCount = 0;
      _continueVideos = const [];
      _hasError = true;
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }
}
