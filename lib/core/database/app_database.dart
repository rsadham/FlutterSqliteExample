import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String databaseName = 'user_database.db';
  static const String tableName = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userName TEXT NOT NULL,
            userLocation TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await database;

    return await db.insert(tableName, data);
  }

  // READ
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;

    return await db.query(tableName, orderBy: 'id DESC');
  }

  // UPDATE
  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE
  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
