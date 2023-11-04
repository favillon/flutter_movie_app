import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies_app/providers/providers.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/movie_slider.dart';
import 'package:movies_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        actions: [
          IconButton(
            onPressed:() =>showSearch(context: context, delegate: MovieSearchDelete()),
           icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies : moviesProvider.onDispalyMovie),
            MovieSlider(
              movies : moviesProvider.populaMovies,
              title : 'Super Populares', 
              onNextPage: () => moviesProvider.getPopularMovies(),
            )
          ],
        ),
      )
    );
  }
}