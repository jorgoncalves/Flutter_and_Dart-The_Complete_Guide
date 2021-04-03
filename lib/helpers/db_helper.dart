import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  DBHelper();

  static Future<Database> database() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    final sqliteDB = db.insert(table, data,
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
