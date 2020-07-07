class Config {
  static const databaseName = './tmdb_db.db';

  static const tableConfig = 'config';
  static const columnParameter = 'param';
  static const columnValue = 'value';

  static const tableMovies = 'movies';
  static const moviesColumnId = 'id';
  static const moviesColumnTitle = 'title';
  static const moviesColumnOriginalTitle = 'original_title';
  static const moviesColumnOverview = 'overview';
  static const moviesColumnAdult = 'adult';
  static const moviesColumnPosterPath = 'poster_path';
  static const moviesColumnReleaseDate = 'release_date';
  static const moviesColumnPopularity = 'popularity';
  static const moviesColumnVoteAverage = 'vote_average';
  static const moviesColumnVoteCount = 'vote_count';
}
