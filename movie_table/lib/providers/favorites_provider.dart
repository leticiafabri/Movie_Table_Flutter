import 'package:flutter/foundation.dart';

import 'auth_provider.dart';

import '../models/movie.dart';
import '../services/local_storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  final AuthProvider _authProvider;

  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider(this._authProvider) {
    _authProvider.addListener(_onAuthChanged);
    _loadFavorites();
  }

  void _onAuthChanged() {
    if (_authProvider.currentUser == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    _loadFavorites();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  Future<void> _loadFavorites() async {
    final email = _authProvider.currentUser;

    if (email == null) {
      return;
    }

    final savedFavorites = await _storageService.loadFavorites(email);

    _favorites
      ..clear()
      ..addAll(savedFavorites);

    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.add(movie);
    }

    notifyListeners();

    final email = _authProvider.currentUser;
    if (email != null) {
      await _storageService.saveFavorites(email, _favorites);
    }
  }
}
