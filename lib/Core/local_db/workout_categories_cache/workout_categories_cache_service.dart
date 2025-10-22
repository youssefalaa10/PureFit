import 'package:flutter/foundation.dart';

import '../../../Features/Exercises/Data/Model/workout_categories_model.dart';
import '../../helpers/app_logger.dart';
import '../cache_database_helper.dart';

class WorkoutCategoriesCacheService {
  static const int _cacheDurationDays = 7; // Cache valid for 7 days

  // Save workout categories to cache
  static Future<void> cacheWorkoutCategories(
      List<WorkoutCategoriesModel> categories) async {
    try {
      // Convert to JSON format for storage
      final categoriesJson = categories.map((c) => c.toJson()).toList();

      // Cache using SQLite
      await CacheDatabaseHelper.cacheWorkoutCategories(categoriesJson);
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error caching workout categories: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  // Get cached workout categories
  static Future<List<WorkoutCategoriesModel>?>
      getCachedWorkoutCategories() async {
    try {
      // Check if cache is still valid
      final isValid = await CacheDatabaseHelper.isCacheValid(
        CacheDatabaseHelper.workoutCategoriesTable,
        _cacheDurationDays,
      );

      if (!isValid) {
        await clearCache();
        return null;
      }

      // Get cached data from SQLite
      final categoriesJson =
          await CacheDatabaseHelper.getCachedWorkoutCategories();

      if (categoriesJson == null) return null;

      // Convert back to WorkoutCategoriesModel objects
      return categoriesJson
          .map((json) => WorkoutCategoriesModel.fromJson(json))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error reading cached workout categories: $e', StackTrace.current);
      }
      return null;
    }
  }

  // Clear cache
  static Future<void> clearCache() async {
    try {
      await CacheDatabaseHelper.clearWorkoutCategoriesCache();
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing workout categories cache: $e', StackTrace.current);
      }
      rethrow;
    }
  }

  // Check if cache exists and is valid
  static Future<bool> hasCachedData() async {
    try {
      final cached = await getCachedWorkoutCategories();
      return cached != null && cached.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error checking cached data: $e', StackTrace.current);
      }
      return false;
    }
  }

  // Get cache age in days
  static Future<int?> getCacheAge() async {
    try {
      return await CacheDatabaseHelper.getCacheAge(
        CacheDatabaseHelper.workoutCategoriesTable,
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error getting cache age: $e', StackTrace.current);
      }
      return null;
    }
  }

  // Clear expired caches
  static Future<void> clearExpiredCaches() async {
    try {
      await CacheDatabaseHelper.clearExpiredCaches(_cacheDurationDays);
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error clearing expired caches: $e', StackTrace.current);
      }
      rethrow;
    }
  }
}
