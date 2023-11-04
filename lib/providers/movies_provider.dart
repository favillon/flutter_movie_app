import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/models/search_movie_response.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey  = '9b4f073b84dd01860cf5e721a463c6de';
  final String _baseUrl = 'api.themoviedb.org';
  final String _lang    = 'es-CO';

  List<Movie> onDispalyMovie = [];
  List<Movie> populaMovies = [];
  int _pagePopularMovie = 0;

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    //print('MoviesProvider Init');
    getMovies();
    getPopularMovies();

    //_suggestionStreamController.close();
  }

  Future<String> _getJsonData (String endpoint, {
      int page = 1, 
      String? includeAdult, 
      String? includeVideo,
      String? query,
      String? sortBy 
  }) async {
    Map<String, dynamic> jsonParameters = {};
    jsonParameters['api_key' ] = _apiKey;
    jsonParameters['language'] = _lang;
    jsonParameters['page' ] = '$page';
    if (includeAdult != null) {
      jsonParameters['include_adult'] = includeAdult == 'true' ? 'true' :  'false';
    }
    if (includeVideo != null) {
      jsonParameters['include_video'] = includeVideo == 'true' ? 'true' :  'false';
    }
    if (sortBy != null) {
      jsonParameters['sort_by'] = sortBy;
    }
    if (query != null) {
      jsonParameters['query'] = query;
    }

    final url = Uri.https(_baseUrl, endpoint, jsonParameters);
    final response = await http.get(url);
    return response.body;
  }

  getMovies() async{
    final jsonData = await _getJsonData('3/discover/movie',
      includeAdult: 'true',  
      includeVideo: 'false',
      sortBy : 'popularity.desc'
    );
    final discoverMovieResponse = DiscoverMovieResponse.fromRawJson(jsonData);
    onDispalyMovie = discoverMovieResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _pagePopularMovie++;
    final jsonData = await _getJsonData('3/movie/popular',
      page: _pagePopularMovie,
      includeAdult: 'true',  
      includeVideo: 'false',
      sortBy : 'vote_average.desc'
    );
    final popularMovieResponse = PopularMovieResponse.fromRawJson(jsonData);
    populaMovies = [...populaMovies, ...popularMovieResponse.results ];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final jsonData = await _getJsonData('3/movie/$movieId/credits',
      page: _pagePopularMovie,
      includeAdult: 'true',  
      includeVideo: 'false',
      sortBy : 'vote_average.desc'
    );
    final castMovieResponse = CastMovieResponse.fromRawJson(jsonData);
    moviesCast[movieId] = castMovieResponse.cast ;
    return castMovieResponse.cast;
  }


  Future<List<Movie>> getSearchMovies(String query) async {    
    final jsonData = await _getJsonData('/3/search/movie',
      page: _pagePopularMovie,
      includeAdult: 'true',
      query : query,
    );
    final searchMovieResponse = SearchMovieResponse.fromRawJson(jsonData);
    return searchMovieResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await getSearchMovies(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic( const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}