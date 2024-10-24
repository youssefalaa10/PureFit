import 'package:PureFit/Features/Calories/DATA/Model/todayfood_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodayCaloriesDB {
  static final TodayCaloriesDB _instance = TodayCaloriesDB._init();
  factory TodayCaloriesDB() => _instance;

  static Database? _database;

  String paths = '';
  TodayCaloriesDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todayfood.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    paths = path;
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todayfood(
        localId INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        name TEXT,
        calories INTEGER,
        fats REAL,
        protein REAL,
        image TEXT,
        amount TEXT,
        isFavorite INTEGER 
      )
    ''');
  }

  Future<void> insertFoodtoday(TodayFoodModel todaymeals) async {
    final db = await _instance.database;

    // Check if the favorite already exists
    final existingFavorites = await db.query(
      'todayfood',
      where: 'id = ?',
      whereArgs: [todaymeals.id],
    );

    // If it exists, return; otherwise, insert the new favorite
    if (existingFavorites.isNotEmpty) {
      return; // Avoid inserting duplicate
    }

    await db.insert('todayfood', todaymeals.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TodayFoodModel>> getFoodstoday() async {
    final db = await _instance.database;
    final result = await db.query('todayfood');
    return result.map((json) => TodayFoodModel.fromMap(json)).toList();
  }

  Future<void> deleteFoodtoday(String id) async {
    final db = await _instance.database;
    await db.delete('todayfood', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTodayFood() async {
    final db = await _instance.database;
    await db.delete('todayfood'); // This will delete all rows from the table
  }
}
