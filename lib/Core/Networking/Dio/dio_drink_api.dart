import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';

class DioDrinksApi {
  final Dio _dio;

  DioDrinksApi({required Dio dio}) : _dio = dio;

  Future<List<Map<String, dynamic>>?> getDrinks() async {
    try {
      final response = await _dio.get(
        "${ApiConstants.baseUrl}${ApiConstants.apiDrinks}",
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
          print("Error fetching drinks: Status Code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching drinks: $e");
      }
    }
    return null;
  }
}
