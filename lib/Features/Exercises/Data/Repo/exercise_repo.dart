import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_exercise_api.dart';
import '../Model/exercise_model.dart';

class ExerciseRepo {
  final DioExerciseApi dioExerciseApi;

  ExerciseRepo({required this.dioExerciseApi});

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
        print("Error in ExerciseRepo: $e");
      }
    }
    return null;
  }
}
