import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constans.dart';

class DioWorkoutCategoriesApi {
  final Dio _dio;

  DioWorkoutCategoriesApi({required Dio dio}) : _dio = dio;

  Future<List<Map<String, dynamic>>?> getWorkoutCategories() async {
    try {
      final response = await _dio.get(
        "${ApiConstans.baseUrl}${ApiConstans.apiWorkoutCategories}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        List data = response.data;
        print(data.toString());
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          print(
              "Error fetching workout categories: Status Code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching workout categories: $e");
      }
    }
    return null;
  }
}
