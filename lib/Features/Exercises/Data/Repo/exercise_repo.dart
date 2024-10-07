import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_exercise_api.dart';
import '../Model/exercise_model.dart';

class ExerciseRepo {
  final DioExerciseApi dioExerciseApi;

  ExerciseRepo({required this.dioExerciseApi});

  Future<List<Exercise>?> getExercises(String bodyPart) async {
    try {
      final exercisesJson = await dioExerciseApi.getExercises(bodyPart);
      if (exercisesJson != null) {
        return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in ExerciseRepo: $e");
      }
    }
    return null;
  }
}
