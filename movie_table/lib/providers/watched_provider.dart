import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../services/local_storage_service.dart';

class WatchedProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  final List<Movie> _watched = [];

  List<Movie> get watched => List.unmodifiable(_watched);

  WatchedProvider() {
    _loadWatched();
  }

  bool isWatched(int movieId) {
    return _watched.any((movie) => movie.id == movieId);
  }

  Future<void> _loadWatched() async {
    final savedWatched = await _storageService.loadWatched();

    _watched
      ..clear()
      ..addAll(savedWatched);

    notifyListeners();
  }

  Future<void> toggleWatched(Movie movie) async {
    if (isWatched(movie.id)) {
      _watched.removeWhere(
        (item) => item.id == movie.id,
      );
    } else {
      _watched.add(movie);
    }

    notifyListeners();

    await _storageService.saveWatched(_watched);
  }
}