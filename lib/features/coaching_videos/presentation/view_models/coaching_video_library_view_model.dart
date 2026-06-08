import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:flutter/material.dart';

class CoachingVideoLibraryViewModel extends ChangeNotifier {
  CoachingVideoLibraryViewModel(this._repository);

  final CoachingVideoRepository _repository;

  List<CoachingVideo> _videos = const [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _isLoaded = false;
  CoachingVideoCategory? _selectedCategory;

  List<CoachingVideo> get videos => _videos;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isLoaded => _isLoaded;
  CoachingVideoCategory? get selectedCategory => _selectedCategory;

  List<CoachingVideo> get filteredVideos {
    final category = _selectedCategory;
    if (category == null) {
      return _videos;
    }
    return _videos.where((video) => video.category == category).toList();
  }

  void selectCategory(CoachingVideoCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _videos = await _repository.getVideos();
      _isLoaded = true;
    } catch (_) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
