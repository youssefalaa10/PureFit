import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';

class DioFavoriteApi {
  final Dio _dio;

  DioFavoriteApi({required Dio dio}) : _dio = dio;

  Future<bool> addFavorite(String dietItemId) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.baseUrl}${ApiConstants.apiFavorite(dietItemId)}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        if (kDebugMode) {
          print("Error adding favorite: Status Code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding favorite: $e");
      }
    }
    return false;
  }

  Future<bool> removeFavorite(String dietItemId) async {
    try {
      final response = await _dio.delete(
        "${ApiConstants.baseUrl}${ApiConstants.apiFavorite(dietItemId)}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        if (kDebugMode) {
          print("Error removing favorite: Status Code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error removing favorite: $e");
      }
    }
    return false;
  }
}
