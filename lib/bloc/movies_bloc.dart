import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/services/sqlite_wrapper.dart';
import 'package:moviedb/services/tmdb_api.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final TmdbApi moviesApi;
  final sqliteWrapper;

  MoviesBloc()
      : moviesApi = TmdbApi(),
        sqliteWrapper = SqliteWrapper(),
        super(MoviesInitial());

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    print('begin of mapEventToState');
    if (event is AppStarted) {
      print('app started');
      if
          //
          (false)
        //  (await sqliteWrapper.startOffline)
        add(LoadCache());
      else
        add(LoadMovies());

      print('end app started');
    }

    if (event is LoadMovies) {
      print('load movies');

      if (!(state is MoviesLoaded))
        yield MoviesLoading();
      else
        yield MoviesUpdating((state as MoviesLoaded).movies);

      try {
        if (!moviesApi.configurationLoaded) await moviesApi.loadConfiguration();
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
      print('end load movies');
    }

    if (event is LoadCache) {
      print('load cache');
      if (state is MoviesLoaded)
        yield CacheLoaded((state as MoviesLoaded).movies);
      else
        try {
          yield CacheLoading();
          final movies = List<Movie>();
          // await sqliteWrapper.loadMovies();
          yield CacheLoaded(movies);
        } catch (e) {
          yield MoviesError(e.toString());
        }
      print('end load cache');
    }

    if (event is SaveCache) {
      print('save cache');
      try {
        // await sqliteWrapper.saveMovies(event.movies);
      } catch (e) {
        print('sqlite error');
      }
      print('end save cache');
    }

    if (event is ToggleOffline) {
      print('toggle offline');
      if (state is CacheLoaded || state is CacheLoading) {
        moviesApi.resetLastTopPage();
        add(LoadMovies());
      } else {
        add(LoadCache());
      }
      print('end toggle offline');
    }
    print('end of mapEventToState');
  }
}
