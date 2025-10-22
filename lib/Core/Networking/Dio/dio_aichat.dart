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
        ),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      } else {}
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error fetching drinks: $e', StackTrace.current);
      }
    }
    return '';
  }
}
