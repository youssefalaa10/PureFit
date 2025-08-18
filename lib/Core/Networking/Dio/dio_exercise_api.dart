import 'package:PureFit/Core/Shared/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioExerciseApi {
  DioExerciseApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<Map<String, dynamic>>?> getExercises(String categoryId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.apiExercise}$categoryId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final List data = response.data;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          print('Error fetching exercises: Status Code ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching exercises: $e');
      }
    }
    return null;
  }
}
