import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Vamos preencher isso depois usando o token
  static const String _token = String.fromEnvironment('TMDB_ACCESS_TOKEN');

  Future<List<Movie>> getMovies({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/discover/movie?page=$page&sort_by=popularity.desc'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List results = data['results'];

      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    throw Exception(
      'Não foi possível carregar os filmes. '
      'Código: ${response.statusCode}',
    );
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/search/movie?query=${Uri.encodeQueryComponent(query)}',
      ),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List results = data['results'];

      return results.map((movie) => Movie.fromJson(movie)).toList();
    }

    throw Exception(
      'Não foi possível realizar a busca. '
      'Código: ${response.statusCode}',
    );
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Movie.fromJson(data);
    }

    throw Exception(
      'Não foi possível carregar os detalhes do filme. '
      'Código: ${response.statusCode}',
    );
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    return 'https://image.tmdb.org/t/p/w500$path';
  }
}
