import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_exercise_api.dart';
import '../Model/exercise_model.dart';

class ExerciseRepo {
  ExerciseRepo({required this.dioExerciseApi});
  final DioExerciseApi dioExerciseApi;

  Future<List<ExerciseModel>?> getExercises(String categoryId) async {
    try {
      final exercisesJson = await dioExerciseApi.getExercises(categoryId);
      if (exercisesJson != null) {
        return exercisesJson
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error in ExerciseRepo: $e', StackTrace.current);
      }
    }
    return null;
  }
}
