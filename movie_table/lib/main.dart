import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'screens/catalog_screen.dart';
import 'screens/login_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/favorites_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: const MovieTableApp(),
    ),
  );
}

class MovieTableApp extends StatelessWidget {
  const MovieTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Table',

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}