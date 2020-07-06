import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:moviedb/config/secrets.dart';
import 'package:moviedb/models/movie.dart';

class TmdbApi {
  static const baseUrl = 'https://api.themoviedb.org/3/';

  String apiKey;
  String posterBaseUrl;
  List<String> posterSizes;
  bool configurationLoaded;
  int lastLoadedPage;
  int totalPages;

  TmdbApi() {
    apiKey = Secrets.apiKey;
    configurationLoaded = false;
    lastLoadedPage = 0;
    totalPages = 1;
  }

  loadConfiguration() async {
    final response = await http.get(baseUrl + 'configuration?api_key=$apiKey');
    Map<String, dynamic> data = jsonDecode(response.body);
    posterBaseUrl = data['images']['base_url'];
    posterSizes = List<String>.from(data['images']['poster_sizes']);
    configurationLoaded = true;
  }

  String posterUrl(String posterPath, {bool small = true}) {
    // if (!loadedConfiguration) throw Exception('Unitialised');
    return posterBaseUrl +
        (small ? posterSizes.first : posterSizes.last) +
        posterPath;
  }

  void resetLastTopPage() => lastLoadedPage = 0;

  Future<List<Movie>> loadNextTopPage() async =>
      await loadTopPage(lastLoadedPage + 1);

  Future<List<Movie>> loadTopPage([int page = 1]) async {
    final response =
        await http.get(baseUrl + 'movie/top_rated?api_key=$apiKey&page=$page');
    // if (response.statusCode != 200) throw Exception('Network error');

    var top = jsonDecode(response.body);
    totalPages = top['total_pages'];
    lastLoadedPage = max(lastLoadedPage, page);
    var results = List.from(top['results']);
    return results
        .map((e) => Movie.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}
