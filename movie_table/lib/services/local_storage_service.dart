import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorites';

  Future<void> saveFavorites(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = movies
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();

    await prefs.setStringList(_favoritesKey, moviesJson);
  }

  Future<List<Movie>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = prefs.getStringList(_favoritesKey);

    if (moviesJson == null) {
      return [];
    }

    return moviesJson
        .map(
          (movieJson) => Movie.fromJson(
            jsonDecode(movieJson),
          ),
        )
        .toList();
  }
}