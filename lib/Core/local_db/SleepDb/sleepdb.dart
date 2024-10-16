import 'package:fitpro/Features/Sleep/Data/Model/sleepmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SleepDb {
  static final SleepDb _instance = SleepDb._internal();
  factory SleepDb() => _instance;
  static Database? _database;

  SleepDb._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sleep_sessions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sleep_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bedtime TEXT NOT NULL,
        wake_time TEXT NOT NULL,
        duration INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertSleepSession(SleepSession session) async {
    final db = await database;
    return await db.insert('sleep_sessions', session.toMap());
  }

  Future<List<SleepSession>> getSleepSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sleep_sessions');

    return List.generate(maps.length, (i) {
      return SleepSession.fromMap(maps[i]);
    });
  }

  Future<int> updateSleepSession(SleepSession session) async {
    final db = await database;
    return await db.update(
      'sleep_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> deleteSleepSession(int id) async {
    final db = await database;
    return await db.delete(
      'sleep_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
