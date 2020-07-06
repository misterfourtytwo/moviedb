part of 'movies_bloc.dart';

@immutable
abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class CacheLoading extends MoviesState {}

class CacheLoaded extends MoviesState {
  final List<Movie> movies;

  CacheLoaded(this.movies);
}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  MoviesLoaded(
    this.movies,
  );
}

class MoviesUpdating extends MoviesState {
  final List<Movie> movies;

  MoviesUpdating(this.movies);
}

class MoviesError extends MoviesState {
  final String message;

  MoviesError(this.message);
}
