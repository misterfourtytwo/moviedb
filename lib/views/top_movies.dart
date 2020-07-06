import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/bloc/movies_bloc.dart';
import 'package:moviedb/models/movie.dart';

class TopMovies extends StatefulWidget {
  const TopMovies({Key key}) : super(key: key);

  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  MoviesBloc moviesBloc;
  @override
  void initState() {
    super.initState();
    moviesBloc = BlocProvider.of<MoviesBloc>(context)..add(AppStarted());
  }

  // @override
  // void dispose() {
  // moviesBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(builder: (context, state) {
      final Widget offlineToggleButton =
          ToggleOfflineButton(moviesBloc: moviesBloc, state: state);
      Widget content;
      if (state is MoviesInitial ||
          state is MoviesLoading ||
          state is CacheLoading) {
        // loading
        content = Center(child: CircularProgressIndicator());
      } else if (state is MoviesError) {
        //error
        content = Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Error:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(state.message),
              RaisedButton(
                child: Text('Reload'),
                onPressed: () => moviesBloc.add(LoadMovies()),
              )
            ],
          ),
        );
      } else {
        // loaded or updating
        List<Movie> movies;
        if (state is MoviesLoaded) movies = state.movies;
        if (state is CacheLoaded) movies = state.movies;
        if (state is MoviesUpdating) movies = state.movies;

        if (movies.isEmpty)
          content = Center(child: Text('Cache is empty'));
        else {
          content = Container(
              child: ListView.builder(
            itemCount: movies.length + (state is CacheLoaded ? 0 : 1),
            itemBuilder: (context, i) => i < movies.length
                // list item
                ? Column(
                    children: [
                      ListTile(
                        dense: true,
                        onTap: () => Navigator.of(context)
                            .pushNamed('movie_info', arguments: movies[i]),
                        title: Text(movies[i].title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        trailing:
                            Text('Score: ' + movies[i].voteAverage.toString()),
                        leading:
                            Text(movies[i].releaseDate?.year.toString() ?? ''),
                      ),
                      Divider(),
                    ],
                  )
                : (state is MoviesUpdating)
                    ? Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Loading',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                    :
                    // download more button
                    RaisedButton(
                        color: Colors.red[100],
                        onPressed: () => moviesBloc.add(LoadMovies()),
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Load more',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
          ));
        }
      }
      print('build $state');
      return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Top movies',
              ),
              actions: [offlineToggleButton]),
          body: content);
    });
  }
}

class ToggleOfflineButton extends StatelessWidget {
  const ToggleOfflineButton({
    Key key,
    @required this.moviesBloc,
    @required this.state,
  }) : super(key: key);

  final MoviesBloc moviesBloc;
  final MoviesState state;

  @override
  Widget build(BuildContext context) => FlatButton(
        child: Text(
          state is CacheLoaded || state is CacheLoading
              ? 'Go online'
              : 'Go offline',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => moviesBloc.add(ToggleOffline()),
      );
}
