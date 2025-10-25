import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class WorkoutCategoriesApiException implements Exception {
  WorkoutCategoriesApiException(this.message, {this.isConnectionError = false});
  final String message;
  final bool isConnectionError;

  @override
  String toString() => message;
}

class DioWorkoutCategoriesApi {
  DioWorkoutCategoriesApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<Map<String, dynamic>>?> getWorkoutCategories() async {
    try {
      final response = await _dio.get<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiWorkoutCategories}',
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
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error fetching workout categories: Status Code ${response.statusCode}',
              StackTrace.current);
        }
        throw WorkoutCategoriesApiException(
            'Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error fetching workout categories: $e', StackTrace.current);
      }

      // Check if it's a connection error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.error.toString().contains('SocketException') ||
          e.error.toString().contains('Failed host lookup')) {
        throw WorkoutCategoriesApiException(
            'No internet connection. Please check your network.',
            isConnectionError: true);
      }

      throw WorkoutCategoriesApiException(
          'Failed to load workout categories: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error(
            'Error fetching workout categories: $e', StackTrace.current);
      }
      throw WorkoutCategoriesApiException('An unexpected error occurred');
    }
  }
}
