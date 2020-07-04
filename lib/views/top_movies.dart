import 'package:flutter/material.dart';
import 'package:moviedb/services/tmdb_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:moviedb/models/movie.dart';

class TopMovies extends StatefulWidget {
  const TopMovies({Key key}) : super(key: key);

  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  List<Movie> movies;
  RefreshController _refreshController = RefreshController();

  void _onRefresh() async {
    print('on refresh ');

    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    movies.addAll(await api.loadNextTopPage());
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   print('on loading');
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  TmdbApi api;

  @override
  void initState() {
    super.initState();
    api = TmdbApi();
    movies = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Top movies',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.access_alarm),
            onPressed: api.loadConfiguration,
          ),
          IconButton(
            icon: Icon(Icons.alarm_off),
            onPressed: api.loadNextTopPage,
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        // onLoading: _onLoading,
        // header: SliverToBoxAdapter(
        //   child: Container(
        //     height: 100,
        //     color: Colors.pink,
        //     padding: EdgeInsets.all(8),
        //     child: Text('header'),
        //   ),
        // ),
        // footer: SliverToBoxAdapter(
        //   child: Container(
        //     height: 100,
        //     color: Colors.pink,
        //     padding: EdgeInsets.all(8),
        //     child: Text('footer'),
        //   ),
        // ),
        child: movies.length == 0
            ? Center(
                child: Text('list is empty'),
              )
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, i) => Column(
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
                ),
              ),
      ),
    );
  }
}
