import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../Features/Diet/Data/Model/favorites_model.dart';

class DietFavoriteDb {
  static final DietFavoriteDb _instance = DietFavoriteDb._init();
  factory DietFavoriteDb() => _instance;

  static Database? _database;

  String paths = '';
  DietFavoriteDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorites.db');
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
      CREATE TABLE favorites(
        localId INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        name TEXT,
        calories INTEGER,
        fats REAL,
        protein REAL,
        image TEXT,
        isFavorite INTEGER 
      )
    ''');
  }

  Future<void> insertFavorite(FavoriteModel favorite) async {
    final db = await _instance.database;

    // Check if the favorite already exists
    final existingFavorites = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [favorite.id],
    );

    // If it exists, return; otherwise, insert the new favorite
    if (existingFavorites.isNotEmpty) {
      return; // Avoid inserting duplicate
    }

    await db.insert('favorites', favorite.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavoriteModel>> fetchFavorites() async {
    final db = await _instance.database;
    final result = await db.query('favorites');
    return result.map((json) => FavoriteModel.fromJson(json)).toList();
  }

  Future<void> deleteFavorite(String id) async {
    final db = await _instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  // Method to update the isFavorite status
  Future<void> updateFavoriteStatus(String id, bool isFavorite) async {
    final db = await _instance.database;

    await db.update(
      'favorites',
      {'isFavorite': isFavorite ? 1 : 0}, // Convert boolean to integer
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to delete all data from the favorites table
  Future<void> deleteAllData() async {
    final db = await _instance.database;

    // Delete all records from the favorites table
    await db.delete('favorites');

    print('All data deleted from favorites table.');
  }
}
