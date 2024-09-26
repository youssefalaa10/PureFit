import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../Features/TrackSteps/Data/Model/track_steps_model.dart';

class TrackStepsDB {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDb(); // Initialize the database
    return _db!;
  }

  Future<Database> initDb() async {
    var dBpath = await getDatabasesPath();
    String path = join(dBpath, 'Tracking.db');
    Database myDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDB;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Tracking(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        STEPS INTEGER DEFAULT 0,
        DATE TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE TOGGLEdate(
        KEY TEXT PRIMARY KEY,
        VALUE TEXT
      )
    ''');
  }

  // Method to read all tracking records
  Future<List<TrackStepsModel>> readHistoryTracks() async {
    Database? myDatabase = await db;
    final response = await myDatabase.query('Tracking');
    return response.map((e) => TrackStepsModel.fromMap(e)).toList();
  }

  // Method to read a tracking record by date
  Future<TrackStepsModel?> readTrackByDate(String date) async {
    Database? myDatabase = await db;
    final List<Map<String, dynamic>> result = await myDatabase.query(
      'Tracking',
      where: 'DATE = ?',
      whereArgs: [date],
    );
    return result.isNotEmpty
        ? result.map((e) => TrackStepsModel.fromMap(e)).toList().first
        : null;
  }

  // Method to insert or update a tracking record
  Future<void> upsertTrack(int steps, String date) async {
    Database? myDatabase = await db;

    final existingTrack = await readTrackByDate(date);

    if (existingTrack != null) {
      await myDatabase.update(
        'Tracking',
        {'STEPS': steps, 'DATE': date},
        where: 'ID = ?',
        whereArgs: [existingTrack.id],
      );
    } else {
      await myDatabase.insert(
        'Tracking',
        {'STEPS': steps, 'DATE': date},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Optional: Method to delete a tracking record by ID
  Future<void> deleteTrack(int id) async {
    Database? myDatabase = await db;
    await myDatabase.delete(
      'Tracking',
      where: 'ID = ?',
      whereArgs: [id],
    );
  }

  // New Methods to save and retrieve _lastRecordedDate

  Future<void> saveLastRecordedDate(String date) async {
    Database? myDatabase = await db;
    await myDatabase.insert(
      'TOGGLEdate',
      {'KEY': 'lastRecordedDate', 'VALUE': date},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLastRecordedDate() async {
    Database? myDatabase = await db;
    final List<Map<String, dynamic>> result = await myDatabase.query(
      'TOGGLEdate',
      where: 'KEY = ?',
      whereArgs: ['lastRecordedDate'],
    );
    return result.isNotEmpty ? result.first['VALUE'] as String : null;
  }
}
