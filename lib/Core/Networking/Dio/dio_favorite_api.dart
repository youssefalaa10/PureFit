import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class DioFavoriteApi {
  DioFavoriteApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<bool> addFavorite(String dietItemId) async {
    try {
      final response = await _dio.post<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiFavorite(dietItemId)}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error adding favorite: Status Code ${response.statusCode}',
              StackTrace.current);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error adding favorite: $e', StackTrace.current);
      }
    }
    return false;
  }

  Future<bool> removeFavorite(String dietItemId) async {
    try {
      final response = await _dio.delete<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiFavorite(dietItemId)}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      } else {
        if (kDebugMode) {
          AppLogger.log(
              'Error removing favorite: Status Code ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.log('Error removing favorite: $e');
      }
    }
    return false;
  }
}
