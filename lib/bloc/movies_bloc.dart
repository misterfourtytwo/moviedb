import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:moviedb/models/movie.dart';
import 'package:moviedb/services/sqlite_wrapper.dart';
import 'package:moviedb/services/tmdb_api.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final TmdbApi moviesApi;
  final SqliteWrapper sqliteWrapper;

  String posterBaseUrl;
  List<String> posterSizes;
  bool configurationLoaded;

  MoviesBloc()
      : moviesApi = TmdbApi(),
        sqliteWrapper = SqliteWrapper(),
        configurationLoaded = false,
        super(MoviesInitial());

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if (event is AppStarted) {
      await sqliteWrapper.init();
      if (await sqliteWrapper.loadOfflineFlag())
        add(LoadCache());
      else
        add(LoadMovies());
    }

    if (event is LoadMovies) {
      if (!(state is MoviesLoaded))
        yield MoviesLoading();
      else
        yield MoviesUpdating((state as MoviesLoaded).movies);

      try {
        if (!configurationLoaded) {
          final response = await moviesApi.loadImageConfig();
          Map<String, dynamic> data = json.decode(response);
          await sqliteWrapper.saveImageConfig(response);
          posterBaseUrl = data['images']['base_url'];
          posterSizes = List<String>.from(data['images']['poster_sizes']);
          configurationLoaded = true;
        }

        final moviesLoaded = await moviesApi.loadNextTopPage();

        if (state is MoviesLoading)
          yield MoviesLoaded(moviesLoaded);
        else if (state is MoviesUpdating) {
          List<Movie> movies = (state as MoviesUpdating).movies;
          movies.addAll(moviesLoaded);
          yield MoviesLoaded(movies);
        } else
          return;
        add(SaveCache(moviesLoaded));
      } catch (e) {
        yield MoviesError(e.toString());
      }
    }

    if (event is LoadCache) {
      if (!configurationLoaded) {
        final response = await sqliteWrapper.loadImageConfig();
        if (response != null) {
          Map<String, dynamic> data = json.decode(response);
          posterBaseUrl = data['images']['base_url'];
          posterSizes = List<String>.from(data['images']['poster_sizes']);
        }
      }
      if (state is MoviesLoaded)
        yield CacheLoaded((state as MoviesLoaded).movies);
      else
        try {
          yield CacheLoading();
          var movies = await sqliteWrapper.loadMovies();
          yield CacheLoaded(movies);
        } catch (e) {
          yield MoviesError(e.toString());
        }
    }

    if (event is SaveCache) {
      try {
        await sqliteWrapper.saveMovies(event.movies);
      } catch (e) {
        print('sqlite error');
      }
    }

    if (event is ToggleOffline) {
      if (state is CacheLoaded || state is CacheLoading) {
        moviesApi.resetLastTopPage();
        sqliteWrapper.setOfflineFlag(false);
        add(LoadMovies());
      } else {
        sqliteWrapper.setOfflineFlag(true);
        add(LoadCache());
      }
    }
  }

  String posterUrl(String posterPath, {bool small = true}) {
    // simply return wrong url and show broken image when we have no image
    // configuration saved
    if (posterSizes?.last == null) return 'aaaaaaaaaaaaaaaaaaaaa';
    return posterBaseUrl +
        (small ? posterSizes.first : posterSizes.last) +
        posterPath;
  }
}
