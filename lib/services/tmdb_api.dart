import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moviedb/config/secrets.dart';
import 'package:moviedb/models/movie.dart';

class TmdbApi {
  static const baseUrl = 'https://api.themoviedb.org/3/';

  String apiKey;
  int lastLoadedPage;
  int totalPages;

  TmdbApi() {
    apiKey = Secrets.apiKey;
    lastLoadedPage = 0;
    totalPages = 1;
  }

  Future<String> loadImageConfig() async {
    final response = await http.get(baseUrl + 'configuration?api_key=$apiKey');
    return response.body;
  }

  void resetLastTopPage() => lastLoadedPage = 0;

  Future<List<Movie>> loadNextTopPage() async =>
      await loadTopPage(lastLoadedPage + 1);

  Future<List<Movie>> loadTopPage([int page = 1]) async {
    final response =
        await http.get(baseUrl + 'movie/top_rated?api_key=$apiKey&page=$page');
    // final body = jsonDecode(response.body).cast<Map<String, dynamic>>();
    // totalPages = body['total_pages'];
    lastLoadedPage = max(lastLoadedPage, page);
    return compute(parseMoviesPage, response.body);
  }
}

List<Movie> parseMoviesPage(String responseBody) {
  var results = List.from(json.decode(responseBody)['results']);
  return results
      .map((e) => Movie.fromMap(Map<String, dynamic>.from(e)))
      .toList();
}
