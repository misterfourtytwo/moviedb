import 'dart:convert';

import 'package:moviedb/config/configuration.dart';

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final bool adult;
  final String posterPath;
  final DateTime releaseDate;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  Movie({
    this.id,
    this.title,
    this.originalTitle,
    this.overview,
    this.adult,
    this.posterPath,
    this.releaseDate,
    this.popularity,
    this.voteAverage,
    this.voteCount,
  });

  Movie copyWith({
    int id,
    String title,
    String originalTitle,
    String overview,
    bool adult,
    String posterPath,
    DateTime releaseDate,
    double popularity,
    double voteAverage,
    int voteCount,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      adult: adult ?? this.adult,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
      popularity: popularity ?? this.popularity,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Config.moviesColumnId: id,
      Config.moviesColumnTitle: title,
      Config.moviesColumnOriginalTitle: originalTitle,
      Config.moviesColumnOverview: overview,
      Config.moviesColumnAdult: adult.toString(),
      Config.moviesColumnPosterPath: posterPath,
      Config.moviesColumnReleaseDate: releaseDate?.toIso8601String(),
      Config.moviesColumnPopularity: popularity.toDouble(),
      Config.moviesColumnVoteAverage: voteAverage.toDouble(),
      Config.moviesColumnVoteCount: voteCount,
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Movie(
      id: map[Config.moviesColumnId],
      title: map[Config.moviesColumnTitle],
      originalTitle: map[Config.moviesColumnOriginalTitle],
      overview: map[Config.moviesColumnOverview],
      adult: map[Config.moviesColumnAdult]?.toString() == 'true' ? true : false,
      posterPath: map[Config.moviesColumnPosterPath],
      releaseDate: DateTime.parse(map[Config.moviesColumnReleaseDate]),
      popularity: map[Config.moviesColumnPopularity] + 0.0,
      voteAverage: map[Config.moviesColumnVoteAverage] + 0.0,
      voteCount: map[Config.moviesColumnVoteCount],
    );
  }

  String toJson() => json.encode(toMap());

  static Movie fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, original title: $originalTitle, '
        'overview: $overview, adult: $adult, poster path: $posterPath, '
        'release date: $releaseDate, popularity: $popularity, vote average: '
        '$voteAverage, vote count: $voteCount)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Movie &&
        o.id == id &&
        o.title == title &&
        o.originalTitle == originalTitle &&
        o.overview == overview &&
        o.adult == adult &&
        o.posterPath == posterPath &&
        o.releaseDate == releaseDate &&
        o.popularity == popularity &&
        o.voteAverage == voteAverage &&
        o.voteCount == voteCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        originalTitle.hashCode ^
        overview.hashCode ^
        adult.hashCode ^
        posterPath.hashCode ^
        releaseDate.hashCode ^
        popularity.hashCode ^
        voteAverage.hashCode ^
        voteCount.hashCode;
  }
}
