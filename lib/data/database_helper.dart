// lib/data/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_match.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'matches.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE matches(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            home_team TEXT,
            away_team TEXT,
            date_time TEXT,
            stadium TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertMatch(UserMatch match) async {
    final db = await database;
    return await db.insert('matches', match.toMap());
  }

  Future<List<UserMatch>> getMatches() async {
    final db = await database;
    final result = await db.query('matches');
    return result.map((map) => UserMatch.fromMap(map)).toList();
  }

  Future<int> updateMatch(UserMatch match) async {
    final db = await database;
    return await db.update(
      'matches',
      match.toMap(),
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  Future<int> deleteMatch(int id) async {
    final db = await database;
    return await db.delete(
      'matches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
