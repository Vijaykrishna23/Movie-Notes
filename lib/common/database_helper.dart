import 'dart:async';

import 'package:movie_notes/common/app_utilities.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:sqflite/sqflite.dart' as hack;

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._instance();
  static hack.Database? _dataBase;

  static final String _dbName = "movie_notes_db";

  static final String _tableName = "movies";

  static final String _columnId = "id";
  static final String _columnName = "name";
  static final String _columnDirectorName = "director_name";
  static final String _columnCoverImage = "cover_image";
  static final String _columnUserId = "user_id";

  DataBaseHelper._instance();

  Future<hack.Database> get dataBase async {
    return _dataBase ??= await initializeDatabase();
  }

  Future<hack.Database> initializeDatabase() async {
    final dataBaseRootPath = await hack.getDatabasesPath();
    String currentDataBasePath = dataBaseRootPath + _dbName;

    return await hack.openDatabase(currentDataBasePath,
        version: 1, onCreate: _createDataBase);
  }

  void _createDataBase(hack.Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnName TEXT,
        $_columnDirectorName TEXT,
        $_columnCoverImage TEXT,
        $_columnUserId TEXT
      )
      ''');
  }

  Future<List<Movie>> getAllMoviesForCurrentUser() async {
    final db = await this.dataBase;
    final movieMapList = await db.query(
        _tableName,
    where: '$_columnUserId = ?',
    whereArgs: [AppUtilities.getCurrentUserId()]);
    List<Movie> movieObjectList = [];

    movieMapList.forEach((movieMap) {
      movieObjectList.add(Movie.fromMap(movieMap));
    });


    return movieObjectList;
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await this.dataBase;
    return await db.insert(_tableName, movie.toMap());
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await this.dataBase;
    return await db.update(_tableName, movie.toMap(),
        where: '$_columnId=?', whereArgs: [movie.id]);
  }

  Future<int> deleteMovie(int? id) async {
    final db = await this.dataBase;
    return await db
        .delete(
        _tableName,
        where: '$_columnId=?',
        whereArgs: [id]
    );
  }
}
