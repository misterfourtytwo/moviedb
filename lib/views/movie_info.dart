import 'package:flutter/material.dart';
import 'package:moviedb/models/movie.dart';

class MovieInfoView extends StatelessWidget {
  final Movie movie;
  const MovieInfoView(this.movie, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: Image.network(
                'https://image.tmdb.org/t/p/original${movie.posterPath}'),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  Text('Title: ' + movie.title),
                  Text('Released: ' +
                      (movie.releaseDate?.year?.toString() ?? 'No info')),
                  //   ],
                  // ),
                  Text('Rating: ' + movie.voteAverage.toString()),

                  Text(
                    'Description: ' + movie.overview,
                    maxLines: 10,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
