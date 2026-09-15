import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class LocalStorageService {
  static const String _usersKey = 'users';

  String _favoritesKey(String email) {
    return 'favorites_$email';
  }

  String _watchedKey(String email) {
    return 'watched_$email';
  }

  Future<Map<String, String>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) {
      return {};
    }

    final Map<String, dynamic> decoded = jsonDecode(usersJson);

    return decoded.map(
      (email, password) => MapEntry(email, password.toString()),
    );
  }

  Future<bool> createUser(String email, String password) async {
    final users = await loadUsers();

    if (users.containsKey(email)) {
      return false;
    }

    users[email] = password;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_usersKey, jsonEncode(users));

    return true;
  }

  Future<bool> validateUser(String email, String password) async {
    final users = await loadUsers();

    return users[email] == password;
  }

  Future<void> saveFavorites(String email, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = movies
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();

    await prefs.setStringList(_favoritesKey(email), moviesJson);
  }

  Future<List<Movie>> loadFavorites(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = prefs.getStringList(_favoritesKey(email));

    if (moviesJson == null) {
      return [];
    }

    return moviesJson
        .map((movieJson) => Movie.fromJson(jsonDecode(movieJson)))
        .toList();
  }

  Future<void> saveWatched(String email, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = movies
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();

    await prefs.setStringList(_watchedKey(email), moviesJson);
  }

  Future<List<Movie>> loadWatched(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final moviesJson = prefs.getStringList(_watchedKey(email));

    if (moviesJson == null) {
      return [];
    }

    return moviesJson
        .map((movieJson) => Movie.fromJson(jsonDecode(movieJson)))
        .toList();
  }
}
