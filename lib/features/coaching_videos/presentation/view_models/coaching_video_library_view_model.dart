import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:flutter/material.dart';

class CoachingVideoLibraryViewModel extends ChangeNotifier {
  CoachingVideoLibraryViewModel(this._repository);

  final CoachingVideoRepository _repository;

  List<CoachingVideo> _videos = const [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoaded = false;

  List<CoachingVideo> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _videos = await _repository.getVideos();
      _isLoaded = true;
    } catch (_) {
      _errorMessage = 'Could not load lessons';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
