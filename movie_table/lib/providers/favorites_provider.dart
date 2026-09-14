import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../services/local_storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFavorites();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  Future<void> _loadFavorites() async {
    final savedFavorites = await _storageService.loadFavorites();

    _favorites
      ..clear()
      ..addAll(savedFavorites);

    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere(
        (item) => item.id == movie.id,
      );
    } else {
      _favorites.add(movie);
    }

    notifyListeners();

    await _storageService.saveFavorites(_favorites);
  }
}