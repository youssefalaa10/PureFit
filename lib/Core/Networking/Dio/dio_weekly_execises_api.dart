import 'package:dio/dio.dart';

import '../../Shared/api_constants.dart';

class DioWeeklyExerciseApi {
  final Dio _dio;

  DioWeeklyExerciseApi({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>?> getCalendar(String profileId) async {
    try {

      final response = await _dio
          .get("${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}");

      return response.data;
    } catch (e) {
      throw 'Error getting calendar';

    }
  }

  Future<bool> updateCalendar(
      String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}",
        data: {
          "weekNumber": weekNumber,
          "dayUpdates": dayUpdates,
        },
      );
      print('Response data Update: ${response.data}');
      return true;
    } catch (e) {
      throw  'updating calendar: $e';

    }
  }

  Future<bool> resetCalendar(String profileId) async {
    try {
     await _dio
          .put("${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}");

      return true;
    } catch (e) {
      print('Error resetting calendar: $e');
      return false;
    }
  }
}
