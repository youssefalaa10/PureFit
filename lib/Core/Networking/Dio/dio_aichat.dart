import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';

class DioChatApi {
  final Dio _dio;

  DioChatApi({required Dio dio}) : _dio = dio;

  Future<String> postChat(String message) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.baseUrl}${ApiConstants.gemini}",
        data: {"message": message},
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
        print("Error fetching drinks: $e");
      }
    }
    return '';
  }
}
