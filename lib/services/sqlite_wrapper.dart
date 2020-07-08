import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:moviedb/config/configuration.dart';
import 'package:moviedb/models/movie.dart';

class SqliteWrapper {
  Database moviesDb;

  init() async {
    moviesDb = await open(join(await getDatabasesPath(), Config.databaseName));
  }

  Future<Database> open(String path) async {
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table ${Config.tableMovies} ( 
  ${Config.moviesColumnId} integer primary key, 
  ${Config.moviesColumnTitle} text not null,
  ${Config.moviesColumnOriginalTitle} text not null,
  ${Config.moviesColumnOverview} text not null,
  ${Config.moviesColumnAdult} text not null,
  ${Config.moviesColumnPosterPath} text not null,
  ${Config.moviesColumnReleaseDate} text not null,  
  ${Config.moviesColumnPopularity} real not null,
  ${Config.moviesColumnVoteAverage} real not null,
  ${Config.moviesColumnVoteCount} integer not null
  )  
''');
      await db.execute('''
  create table ${Config.tableConfig} (
  ${Config.columnParameter} text primary key,
  ${Config.columnValue} text
  );
  ''');
    });
  }

  Future<String> loadImageConfig() async {
    List<Map> maps = await moviesDb.query(
      Config.tableConfig,
      where: '${Config.columnParameter} = ?',
      whereArgs: ['image_config'],
    );
    if (maps.length > 0) {
      return maps.first[Config.columnValue];
    }
    return null;
  }

  saveImageConfig(String value) async {
    await moviesDb.insert(
      Config.tableConfig,
      {
        Config.columnParameter: 'image_config',
        Config.columnValue: value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> startOfflineFlag() async {
    List<Map> maps = await moviesDb.query(
      Config.tableConfig,
      where: '${Config.columnParameter} = ?',
      whereArgs: ['start_offline'],
    );
    if (maps.length > 0) {
      return maps.first[Config.columnValue] == 'true';
    }

    return false;
  }

  setOfflineFlag(bool value) async {
    await moviesDb.insert(
      Config.tableConfig,
      {
        Config.columnParameter: 'start_offline',
        Config.columnValue: value.toString()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void insertMovie(Movie movie) async {
    await moviesDb.insert(Config.tableMovies, movie.toMap());
  }

  Future<Movie> loadMovie(int id) async {
    List<Map> maps = await moviesDb.query(Config.tableMovies,
        where: '${Config.moviesColumnId} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Movie.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Movie>> loadMovies() async {
    List<Map<String, dynamic>> records =
        await moviesDb.query(Config.tableMovies);
    final result = records.map((e) => Movie.fromMap(e)).toList();
    // sort by rating, desc
    result.sort((a, b) => -1 * a.voteAverage.compareTo(b.voteAverage) == 0
        ? a.title.compareTo(b.title)
        : a.voteAverage.compareTo(b.voteAverage));
    return result;
  }

  Future<void> saveMovies(List<Movie> movies) async {
    // movies.forEach((e) async => insertMovie(e));
    if (movies != null) {
      // moviesDb.rawDelete('DELETE FROM ${Config.tableMovies}');
      var batch = moviesDb.batch();
      movies.forEach((movie) => batch.insert(
            Config.tableMovies,
            movie.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ));
      await batch.commit(noResult: true);
    }
  }
}
