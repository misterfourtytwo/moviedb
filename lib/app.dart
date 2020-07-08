import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/bloc/movies_bloc.dart';
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/views/movie_info.dart';
import 'package:moviedb/views/top_movies.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesBloc(),
      child: MaterialApp(
        title: 'Movie db top',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.red[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'top_movies',
        routes: {
          'top_movies': (context) => TopMovies(),
          'movie_info': (context) {
            // unpack movie
            Movie movie = (ModalRoute.of(context).settings.arguments as Movie);
            return MovieInfoView(movie);
          }
        },
      ),
    );
  }
}
