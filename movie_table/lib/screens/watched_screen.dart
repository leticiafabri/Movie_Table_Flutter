import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watched_provider.dart';
import '../services/movie_service.dart';
import 'movie_detail_screen.dart';

class WatchedScreen extends StatelessWidget {
  const WatchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = MovieService();

    return Scaffold(
      body: Consumer<WatchedProvider>(
        builder: (context, watchedProvider, child) {
          final watched = watchedProvider.watched;

          if (watched.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não possui filmes assistidos.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.62,
            ),
            itemCount: watched.length,
            itemBuilder: (context, index) {
              final movie = watched[index];

              final imageUrl =
                  movieService.getImageUrl(movie.posterPath);

              return Semantics(
                button: true,
                label:
                    'Abrir detalhes do filme ${movie.title}',
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      'Pôster do filme ${movie.title}',
                                  errorBuilder:
                                      (context, error, stackTrace) {
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}