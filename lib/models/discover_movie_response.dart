import 'dart:convert';

import 'package:movies_app/models/models.dart' show Movie;

class DiscoverMovieResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    DiscoverMovieResponse({
      required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults,
    });

    factory DiscoverMovieResponse.fromRawJson(String str) => DiscoverMovieResponse.fromJson(json.decode(str));

    factory DiscoverMovieResponse.fromJson(Map<String, dynamic> json) => DiscoverMovieResponse(
      page: json["page"],
      results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
}
