import 'dart:async';
import 'package:fitpro/Features/Water/Data/Model/water_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WatererDb {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb(); // Initialize the database
    return _db!;
  }

  initDb() async {
    var path = await getDatabasesPath();
    final getDb = join(path, "Water.db");
    return await openDatabase(getDb, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Water(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        intake INTEGER DEFAULT 0,
        date TEXT
      )
    ''');
  }

  // Insert or update water intake for the same day
  Future<void> insertOrUpdateIntake(int newIntake) async {
    final database = await db;
    String currentDate =
        DateTime.now().toString().split(' ')[0]; // Format: 'YYYY-MM-DD'

    // Check if there's an existing entry for the current date
    var existingRecord = await database.query(
      'Water',
      where: 'date = ?',
      whereArgs: [currentDate],
    );

    if (existingRecord.isNotEmpty) {
      // If record exists, update the intake
      int existingIntake = existingRecord.first['intake'] as int;
      int updatedIntake = existingIntake + newIntake;
      await database.update(
        'Water',
        {'intake': updatedIntake},
        where: 'date = ?',
        whereArgs: [currentDate],
      );
    } else {
      // If no record exists, insert a new one
      await database.insert(
        'Water',
        {'intake': newIntake, 'date': currentDate},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Get all water intake records
  Future<List<WaterIntake>> getAllIntakes() async {
    final database = await db;
    final List<Map<String, dynamic>> records = await database.query('Water');

    // Convert the list of maps to a list of WaterIntake objects
    return records.map((record) => WaterIntake.fromMap(record)).toList();
  }

  // Delete a record by ID
  Future<void> deleteIntake(int id) async {
    final database = await db;
    await database.delete(
      'Water',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a specific record
  Future<void> updateIntake(int id, int newIntake) async {
    final database = await db;
    await database.update(
      'Water',
      {'intake': newIntake},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get the total water intake for today
  Future<int> getTodayIntake() async {
    final database = await db;
    String currentDate =
        DateTime.now().toString().split(' ')[0]; // Format: 'YYYY-MM-DD'

    var result = await database.query(
      'Water',
      columns: ['SUM(intake) as totalIntake'],
      where: 'date = ?',
      whereArgs: [currentDate],
    );

    return result.isNotEmpty && result.first['totalIntake'] != null
        ? result.first['totalIntake'] as int
        : 0; // Return 0 if no intake records for today
  }
}
