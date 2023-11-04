import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/screens/screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false,)
      ],
      child: const MoviesApp(),
    );
  }
}


class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => const HomeScreen(),
        'details' : ( _ ) => const DetailsScreen(),
      },
      theme: ThemeData.dark(),
    );
  }
}