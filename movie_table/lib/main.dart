import 'package:flutter/material.dart';

import 'screens/catalog_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MovieTableApp());
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
      },
    );
  }
}