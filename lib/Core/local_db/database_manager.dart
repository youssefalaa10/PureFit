import 'dart:developer' as developer;
import 'package:sqflite/sqflite.dart';

/// Safe database manager that implements lazy initialization
/// This prevents all databases from being initialized at startup
class DatabaseManager {
  static final Map<String, Database> _databases = {};
  static final Map<String, bool> _initializationStatus = {};

  /// Get database instance with lazy initialization
  static Future<Database> getDatabase(
      String name, Future<Database> Function() initializer) async {
    if (_databases.containsKey(name)) {
      return _databases[name]!;
    }

    developer.Timeline.startSync('db_init_$name');
    try {
      final database = await initializer();
      _databases[name] = database;
      _initializationStatus[name] = true;
      developer.Timeline.finishSync();
      return database;
    } catch (e) {
      developer.Timeline.finishSync();
      rethrow;
    }
  }

  /// Check if database is already initialized
  static bool isInitialized(String name) {
    return _initializationStatus[name] ?? false;
  }

  /// Close all databases (for cleanup)
  static Future<void> closeAll() async {
    for (final database in _databases.values) {
      await database.close();
    }
    _databases.clear();
    _initializationStatus.clear();
  }

  /// Close specific database
  static Future<void> close(String name) async {
    if (_databases.containsKey(name)) {
      await _databases[name]!.close();
      _databases.remove(name);
      _initializationStatus.remove(name);
    }
  }
}
