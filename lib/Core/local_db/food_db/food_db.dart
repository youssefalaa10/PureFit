import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FoodDb {
  static final FoodDb _instance = FoodDb._internal();
  factory FoodDb() => _instance;
  FoodDb._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            name TEXT,
            image TEXT,
            calories TEXT,
            quantity TEXT
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(String id, String name, String image,
      String calories, String quantity) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': id,
        'name': name,
        'image': image,
        'calories': calories,
        'quantity': quantity
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  // Method to remove a food item from favorites
  Future<void> removeFavorite(String name) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }
}
