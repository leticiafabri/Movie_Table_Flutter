import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final MovieService _movieService = MovieService();

  final TextEditingController _searchController =
    TextEditingController();

  final List<Movie> _movies = [];

  int _currentPage = 1;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final movies = await _movieService.getMovies(
        page: _currentPage,
      );

      setState(() {
        _movies.addAll(movies);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar os filmes.';
      });
    }
  }

  Future<void> _loadNextPage() async {
    _currentPage++;
    await _loadMovies();
  }
  Future<void> _searchMovies() async {
  final query = _searchController.text.trim();

  if (query.isEmpty) {
    return;
  }

  setState(() {
  _isLoading = true;
  _isSearching = true;
  _errorMessage = null;
  });

  try {
    final movies = await _movieService.searchMovies(query);

    setState(() {
      _movies
        ..clear()
        ..addAll(movies);
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Não foi possível realizar a busca.';
    });
  }
}

Future<void> _clearSearch() async {
  _searchController.clear();

  setState(() {
    _isSearching = false;
    _currentPage = 1;
    _movies.clear();
  });

  await _loadMovies();
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: const Text('Filmes'),
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

    if (_errorMessage != null && _movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMovies,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

return Column(
  children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar filme',
                hintText: 'Digite o nome de um filme',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
ElevatedButton(
  onPressed: _isLoading
      ? null
      : (_isSearching ? _clearSearch : _searchMovies),
  child: Text(
    _isSearching ? 'Limpar' : 'Buscar',
  ),
),
        ],
      ),
    ),

Expanded(
  child: _movies.isEmpty
      ? const Center(
          child: Text(
            'Nenhum filme encontrado.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        )
      : GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.62,
          ),
          itemCount: _movies.length,
          itemBuilder: (context, index) {
            final movie = _movies[index];

            return _buildMovieCard(movie);
          },
        ),
),

        if (!_isSearching)
  Padding(
    padding: const EdgeInsets.all(12),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _loadNextPage,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text('Carregar Mais'),
      ),
    ),
  ),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    final imageUrl = _movieService.getImageUrl(
      movie.posterPath,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieDetailScreen(
        movie: movie,
      ),
    ),
  );
},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.movie,
                            size: 50,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.movie,
                        size: 50,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}