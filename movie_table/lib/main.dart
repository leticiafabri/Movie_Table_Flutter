import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/watched_provider.dart';
import 'providers/auth_provider.dart';

import 'providers/favorites_provider.dart';
import 'screens/login_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/watched_screen.dart';
import 'screens/home_screen.dart';
import 'screens/session_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(
        context.read<AuthProvider>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => WatchedProvider(
        context.read<AuthProvider>(),
      ),
    ),
  ],
  child: const MovieTableApp(),
),
  );
}

class NoStretchScrollBehavior extends MaterialScrollBehavior {
  const NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class MovieTableApp extends StatelessWidget {
  const MovieTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Table',
          theme: ThemeData(
          
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7A1F2B),
      ),
      textTheme: GoogleFonts.montserratTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF7A1F2B),
        foregroundColor: Colors.white,
      ),
    ),
      scrollBehavior: const NoStretchScrollBehavior(),
      initialRoute: '/session',

      routes: {
        '/session': (context) => const SessionScreen(),
        '/login': (context) => const LoginScreen(),
        '/catalog': (context) => const HomeScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/watched': (context) => const WatchedScreen(),
      },
    );
  }
}