import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _movieService = MovieService();

  Movie? _movie;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final movie = await _movieService.getMovieDetails(
        widget.movie.id,
      );

      setState(() {
        _movie = movie;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Não foi possível carregar os detalhes do filme.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Detalhes'),
  actions: [
    Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final movie = _movie ?? widget.movie;
        final isFavorite = favoritesProvider.isFavorite(movie.id);

        return IconButton(
          tooltip: isFavorite
              ? 'Remover dos favoritos'
              : 'Adicionar aos favoritos',
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
          ),
          onPressed: () {
            favoritesProvider.toggleFavorite(movie);
          },
        );
      },
    ),
  ],
),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDetails,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final movie = _movie!;

    final imageUrl = _movieService.getImageUrl(
      movie.posterPath,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 450,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const SizedBox(
                      height: 450,
                      child: Center(
                        child: Icon(
                          Icons.movie,
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            const SizedBox(
              height: 300,
              child: Center(
                child: Icon(
                  Icons.movie,
                  size: 80,
                ),
              ),
            ),

          const SizedBox(height: 24),

          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(Icons.star),
              const SizedBox(width: 6),
              Text(
                movie.voteAverage.toStringAsFixed(1),
              ),
              const SizedBox(width: 16),
              Text(
                '${movie.voteCount} votos',
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (movie.releaseDate != null &&
              movie.releaseDate!.isNotEmpty)
            Text(
              'Lançamento: ${movie.releaseDate}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

          const SizedBox(height: 24),

          const Text(
            'Sinopse',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            movie.overview?.isNotEmpty == true
                ? movie.overview!
                : 'Sinopse não disponível.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}