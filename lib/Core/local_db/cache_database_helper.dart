import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/app_logger.dart';

class CacheDatabaseHelper {
  static const String _databaseName = 'app_cache.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String exercisesTable = 'cached_exercises';
  static const String workoutCategoriesTable = 'cached_workout_categories';

  // Exercise table columns
  static const String _exerciseId = 'id';
  static const String _exerciseCategoryId = 'category_id';
  static const String _exerciseData = 'exercise_data';
  static const String _exerciseTimestamp = 'timestamp';

  // Workout categories table columns
  static const String _categoryId = 'id';
  static const String _categoryData = 'category_data';
  static const String _categoryTimestamp = 'timestamp';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error initializing cache database: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    try {
      // Create exercises table
      await db.execute('''
        CREATE TABLE $exercisesTable (
          $_exerciseId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_exerciseCategoryId TEXT NOT NULL,
          $_exerciseData TEXT NOT NULL,
          $_exerciseTimestamp INTEGER NOT NULL,
          UNIQUE($_exerciseCategoryId)
        )
      ''');

      // Create workout categories table
      await db.execute('''
        CREATE TABLE $workoutCategoriesTable (
          $_categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_categoryData TEXT NOT NULL,
          $_categoryTimestamp INTEGER NOT NULL
        )
      ''');

      // Create indexes for better performance
      await db.execute('''
        CREATE INDEX idx_exercises_category_id ON $exercisesTable($_exerciseCategoryId)
      ''');

      await db.execute('''
        CREATE INDEX idx_exercises_timestamp ON $exercisesTable($_exerciseTimestamp)
      ''');

      await db.execute('''
        CREATE INDEX idx_categories_timestamp ON $workoutCategoriesTable($_categoryTimestamp)
      ''');
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error creating cache database tables: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here if needed
    if (kDebugMode) {
      AppLogger.log(
          'Database upgraded from version $oldVersion to $newVersion');
    }
  }

  // Exercise cache methods
  static Future<void> cacheExercises(
      String categoryId, List<Map<String, dynamic>> exercises) async {
    try {
      final db = await database;
      final exercisesJson = jsonEncode(exercises);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.insert(
        exercisesTable,
        {
          _exerciseCategoryId: categoryId,
          _exerciseData: exercisesJson,
          _exerciseTimestamp: timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error caching exercises: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>?> getCachedExercises(
      String categoryId) async {
    try {
      final db = await database;
      final result = await db.query(
        exercisesTable,
        where: '$_exerciseCategoryId = ?',
        whereArgs: [categoryId],
        limit: 1,
      );

      if (result.isEmpty) return null;

      final exerciseData = result.first[_exerciseData] as String;
      final List<dynamic> exercisesList = jsonDecode(exerciseData);
      return exercisesList.cast<Map<String, dynamic>>();
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error getting cached exercises: $e', StackTrace.current);
      }
      return null;
    }
  }

  static Future<void> clearExerciseCache(String categoryId) async {
    try {
      final db = await database;
      await db.delete(
        exercisesTable,
        where: '$_exerciseCategoryId = ?',
        whereArgs: [categoryId],
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing exercise cache: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<void> clearAllExerciseCaches() async {
    try {
      final db = await database;
      await db.delete(exercisesTable);
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing all exercise caches: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  // Workout categories cache methods
  static Future<void> cacheWorkoutCategories(
      List<Map<String, dynamic>> categories) async {
    try {
      final db = await database;
      final categoriesJson = jsonEncode(categories);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Clear existing categories first
      await db.delete(workoutCategoriesTable);

      // Insert new categories
      await db.insert(
        workoutCategoriesTable,
        {
          _categoryData: categoriesJson,
          _categoryTimestamp: timestamp,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error caching workout categories: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>?>
      getCachedWorkoutCategories() async {
    try {
      final db = await database;
      final result = await db.query(
        workoutCategoriesTable,
        limit: 1,
      );

      if (result.isEmpty) return null;

      final categoryData = result.first[_categoryData] as String;
      final List<dynamic> categoriesList = jsonDecode(categoryData);
      return categoriesList.cast<Map<String, dynamic>>();
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error getting cached workout categories: $e', StackTrace.current);
      }
      return null;
    }
  }

  static Future<void> clearWorkoutCategoriesCache() async {
    try {
      final db = await database;
      await db.delete(workoutCategoriesTable);
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing workout categories cache: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  // Cache validation methods
  static Future<bool> isCacheValid(String tableName, int maxAgeDays) async {
    try {
      final db = await database;
      final timestampColumn =
          tableName == exercisesTable ? _exerciseTimestamp : _categoryTimestamp;

      final result = await db.query(
        tableName,
        columns: [timestampColumn],
        orderBy: '$timestampColumn DESC',
        limit: 1,
      );

      if (result.isEmpty) return false;

      final timestamp = result.first[timestampColumn] as int;
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheDate).inDays;

      return difference <= maxAgeDays;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error checking cache validity: $e', StackTrace.current);
      }
      return false;
    }
  }

  static Future<int?> getCacheAge(String tableName) async {
    try {
      final db = await database;
      final timestampColumn =
          tableName == exercisesTable ? _exerciseTimestamp : _categoryTimestamp;

      final result = await db.query(
        tableName,
        columns: [timestampColumn],
        orderBy: '$timestampColumn DESC',
        limit: 1,
      );

      if (result.isEmpty) return null;

      final timestamp = result.first[timestampColumn] as int;
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      return now.difference(cacheDate).inDays;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error getting cache age: $e', StackTrace.current);
      }
      return null;
    }
  }

  // Cleanup methods
  static Future<void> clearExpiredCaches(int maxAgeDays) async {
    try {
      final db = await database;
      final cutoffTime = DateTime.now()
          .subtract(Duration(days: maxAgeDays))
          .millisecondsSinceEpoch;

      // Clear expired exercises
      await db.delete(
        exercisesTable,
        where: '$_exerciseTimestamp < ?',
        whereArgs: [cutoffTime],
      );

      // Clear expired workout categories
      await db.delete(
        workoutCategoriesTable,
        where: '$_categoryTimestamp < ?',
        whereArgs: [cutoffTime],
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing expired caches: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<void> clearAllCaches() async {
    try {
      final db = await database;
      await db.delete(exercisesTable);
      await db.delete(workoutCategoriesTable);
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error clearing all caches: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
