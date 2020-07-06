import 'package:moviedb/models/movie.dart';

class SqliteWrapper {
  Future<bool> startOffline() async {
    return false;
  }

  Future<List<Movie>> loadMovies() async {}
  Future<void> saveMovies(List<Movie> movies) async {}
}
