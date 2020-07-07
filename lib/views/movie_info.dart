import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/bloc/movies_bloc.dart';
import 'package:moviedb/models/movie.dart';

class MovieInfoView extends StatelessWidget {
  final Movie movie;
  const MovieInfoView(this.movie, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final api = BlocProvider.of<MoviesBloc>(context).moviesApi;
    return Scaffold(
        appBar: AppBar(
          title: Text('Information'),
        ),
        body: LayoutBuilder(builder: (context, size) {
          bool horizontal = size.biggest.width > size.biggest.height ||
              size.biggest.width > 600;
          final imageAlignment =
              horizontal ? Alignment.topLeft : Alignment.topCenter;
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: horizontal ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// todo show error instead of image when offline
                Container(
                  alignment: imageAlignment,
                  constraints: BoxConstraints.loose(Size(
                      horizontal ? size.biggest.width * .4 : size.biggest.width,
                      horizontal
                          ? size.biggest.height
                          : size.biggest.height * .8)),
                  child: CachedNetworkImage(
                    alignment: imageAlignment,
                    placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                    imageUrl: BlocProvider.of<MoviesBloc>(context)
                        .posterUrl(movie.posterPath, small: false),
                    errorWidget: (context, _, __) =>
                        Center(child: Icon(Icons.broken_image, size: 42)),
                  ),
                  //       Image.network(
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        Text('Title: ' + movie.title),
                        Text('Released: ' +
                            (movie.releaseDate?.year?.toString() ?? 'No info')),
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
        }));
  }
}
