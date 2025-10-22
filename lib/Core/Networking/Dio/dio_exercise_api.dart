import 'package:PureFit/Core/Shared/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/app_logger.dart';

class ExerciseApiException implements Exception {
  ExerciseApiException(this.message, {this.isConnectionError = false});
  final String message;
  final bool isConnectionError;

  @override
  String toString() => message;
}

class DioExerciseApi {
  DioExerciseApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<Map<String, dynamic>>?> getExercises(String categoryId) async {
    try {
      final response = await _dio.get<dynamic>(
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
        final List<dynamic> data = response.data;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error fetching exercises: Status Code ${response.statusCode}',
              StackTrace.current);
        }
        throw ExerciseApiException('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error fetching exercises: $e', StackTrace.current);
      }

      // Check if it's a connection error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.error.toString().contains('SocketException') ||
          e.error.toString().contains('Failed host lookup')) {
        throw ExerciseApiException(
            'No internet connection. Please check your network.',
            isConnectionError: true);
      }

      throw ExerciseApiException('Failed to load exercises: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error fetching exercises: $e', StackTrace.current);
      }
      throw ExerciseApiException('An unexpected error occurred');
    }
  }
}
