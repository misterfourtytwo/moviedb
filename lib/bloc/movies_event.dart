part of 'movies_bloc.dart';

@immutable
abstract class MoviesEvent {}

class AppStarted extends MoviesEvent {}

class ToggleOffline extends MoviesEvent {}

class LoadMovies extends MoviesEvent {}

class LoadCache extends MoviesEvent {}

class SaveCache extends MoviesEvent {
  final List<Movie> movies;

  SaveCache(
    this.movies,
  );
}
