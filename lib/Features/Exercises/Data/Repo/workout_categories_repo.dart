import 'package:PureFit/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_workout_categories_api.dart';
import '../../../../Core/helpers/app_logger.dart';

class WorkoutCategoriesRepo {
  WorkoutCategoriesRepo({required this.dioWorkoutCategoriesApi});
  final DioWorkoutCategoriesApi dioWorkoutCategoriesApi;

  Future<List<WorkoutCategoriesModel>?> getWorkoutCategories() async {
    try {
      final workoutCategoriesJson =
          await dioWorkoutCategoriesApi.getWorkoutCategories();
      if (workoutCategoriesJson != null) {
        return workoutCategoriesJson
            .map((json) => WorkoutCategoriesModel.fromJson(json))
            .toList();
      }
      return null;
    } on WorkoutCategoriesApiException {
      // Re-throw the exception to preserve connection error information
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error in WorkoutCategoriesRepo: $e', StackTrace.current);
      }
      rethrow;
    }
  }
}
