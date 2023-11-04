import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/providers.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
  final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
  //print(movie.title);
    return  Scaffold(
      body:CustomScrollView(
        slivers: [
          _CustomAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),              
              _Overview(movie),
              _Overview(movie),
              _Overview(movie),
              _Overview(movie),
              _CastingCard(movie.id),
            ])
          )
        ],
      )
    );
  }
}
class _CustomAppBar extends StatelessWidget {  

  final Movie movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      backgroundColor: Colors.red,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading/loading.gif'),
          image: NetworkImage( movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterPath),
                height: 150
              ),
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 200),
            child: Column(
              children: [
                Text(movie.title, style: Theme.of(context).textTheme.headlineMedium, overflow: TextOverflow.ellipsis, maxLines: 2),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.headlineSmall, overflow: TextOverflow.ellipsis, maxLines: 2),
                Row(
                  children: [
                    const Icon(Icons.star_rate_rounded, size: 18, color: Colors.grey,),
                    const SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: const TextStyle(fontSize: 10),)
                  ],
                )
          
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 14),
        ),
    );
  }
}

class _CastingCard extends StatelessWidget {
  
  final int movieId;
  const _CastingCard(this.movieId);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {

        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const  CupertinoActivityIndicator()
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, int index) => _CastCard(cast[index]),
            ),
        );
      }
    );
    
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;
  const _CastCard(this.actor);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            actor.name ,
            maxLines: 2,
            textAlign:TextAlign.center,
            style: const TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}