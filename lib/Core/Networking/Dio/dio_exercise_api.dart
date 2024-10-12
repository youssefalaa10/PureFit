import 'package:dio/dio.dart';
import 'package:fitpro/Core/Shared/api_constans.dart';
import 'package:flutter/foundation.dart';

class DioExerciseApi {
  final Dio _dio;

  DioExerciseApi({required Dio dio}) : _dio = dio;

  Future<List<Map<String, dynamic>>?> getExercises(String categoryId) async {
    try {
      final response = await _dio.get(
        "${ApiConstans.baseUrl}${ApiConstans.apiExercise}$categoryId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        List data = response.data;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          print("Error fetching exercises: Status Code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching exercises: $e");
      }
    }
    return null;
  }
}
