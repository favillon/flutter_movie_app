import 'dart:convert';

import 'package:movies_app/models/models.dart';

class PopularMovieResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    PopularMovieResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory PopularMovieResponse.fromRawJson(String str) => PopularMovieResponse.fromJson(json.decode(str));

    factory PopularMovieResponse.fromJson(Map<String, dynamic> json) => PopularMovieResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}
