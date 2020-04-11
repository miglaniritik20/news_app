import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../modules/news.dart';

class DbProvider {
  static Database _database;
  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'news_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE NEWS('
          'id INTEGER PRIMARY KEY,'
          'title TEXT ,'
          'description TEXT,'
          'url TEXT,'
          'imglink TEXT,'
          'published TEXT'
          ')');
    });
  }

  // Insert news on database
  createNews(News n) async {
    // await deleteAllNews();
    final db = await database;
    final res = await db.insert('NEWS', n.toJson(),conflictAlgorithm: ConflictAlgorithm.replace,);
    print('inserted ${n.id}');
    return res;
  }

  // Delete all news
  Future<int> deleteAllNews() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM NEWS');

    return res;
  }

  Future<List<News>> getAllNews() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM NEWS");

    List<News> list =
        res.isNotEmpty ? res.map((c) => News.fromJson(c)).toList() : [];

    return list;
  }
}
