import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class DioChatApi {
  DioChatApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<String> postChat(String message) async {
    try {
      final response = await _dio.post<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.gemini}',
        data: {'message': message},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          // Additional timeout for AI chat specifically
          receiveTimeout:
              const Duration(seconds: 90), // 90 seconds for AI response
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data ?? '';
      } else {
        if (kDebugMode) {
          AppLogger.error('AI Chat API error: Status ${response.statusCode}',
              StackTrace.current);
        }
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        AppLogger.error('AI Chat DioException: $e', StackTrace.current);
      }

      // Handle specific timeout errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
            'Request timeout. Please check your connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Connection error. Please check your internet connection.');
      } else {
        throw Exception('Failed to get AI response: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('AI Chat error: $e', StackTrace.current);
      }
      throw Exception('Unexpected error: $e');
    }
  }
}
