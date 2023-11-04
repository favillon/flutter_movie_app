import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';

class MoviePoster extends StatelessWidget {

  final Movie movie;
  const MoviePoster({
    super.key, 
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'post-${movie.id}';
    
    return Container(
      width: 140,
      height: 190,
      margin: const EdgeInsetsDirectional.all(10),
      child: Column(
        children: [
          
          GestureDetector(
            onTap:() => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterPath),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 120,
            margin: const EdgeInsets.all(2),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)
            ),
          )
        ],
      ),
    );
  }
}