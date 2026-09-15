import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../services/local_storage_service.dart';
import 'auth_provider.dart';

class WatchedProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  final AuthProvider _authProvider;

  final List<Movie> _watched = [];

  List<Movie> get watched => List.unmodifiable(_watched);

  WatchedProvider(this._authProvider) {
    _authProvider.addListener(_onAuthChanged);
    _loadWatched();
  }

  void _onAuthChanged() {
    if (_authProvider.currentUser == null) {
      _watched.clear();
      notifyListeners();
      return;
    }

    _loadWatched();
  }

  bool isWatched(int movieId) {
    return _watched.any((movie) => movie.id == movieId);
  }

  Future<void> _loadWatched() async {
    final email = _authProvider.currentUser;

    if (email == null) {
      return;
    }

    final savedWatched = await _storageService.loadWatched(email);

    _watched
      ..clear()
      ..addAll(savedWatched);

    notifyListeners();
  }

  Future<void> toggleWatched(Movie movie) async {
    if (isWatched(movie.id)) {
      _watched.removeWhere((item) => item.id == movie.id);
    } else {
      _watched.add(movie);
    }

    notifyListeners();

    final email = _authProvider.currentUser;

    if (email != null) {
      await _storageService.saveWatched(email, _watched);
    }
  }
}
