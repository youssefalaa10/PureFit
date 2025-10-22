import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class DioFoodsApi {
  DioFoodsApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<Map<String, dynamic>>?> getFoods() async {
    try {
      final response = await _dio.get<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiFoods}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final List<dynamic> data = response.data;
        // AppLogger.log(data.toString());
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error fetching workout categories: Status Code ${response.statusCode}',
              StackTrace.current);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error fetching workout categories: $e', StackTrace.current);
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getFavouriteFoods(String id) async {
    try {
      final response = await _dio.get<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiFavorite(id)}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final List<dynamic> data = response.data['favoriteFoods'];
        // AppLogger.log(data.toString());
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error fetching workout categories: Status Code ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error fetching workout categories: $e', StackTrace.current);
      }
    }
    return null;
  }
}
