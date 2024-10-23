import 'package:dio/dio.dart';

class DioWeeklyExerciseApi {
  final Dio _dio;

  DioWeeklyExerciseApi({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>?> getCalendar(String profileId) async {
    try {
      print('Fetching calendar for profileId:$profileId');
      final response = await _dio
          .get('https://fit-pro-app.glitch.me/api/calendar/66fab8339f1a05ead89c9065');
      print('Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Error getting calendar: $e');
      return null;
    }
  }

  Future<bool> updateCalendar(
      String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    try {
      final response = await _dio.post(
        'https://fit-pro-app.glitch.me/api/calendar/66fab8339f1a05ead89c9065',
        data: {
          "weekNumber": weekNumber,
          "dayUpdates": dayUpdates,
        },
      );
      print('Response data Update: ${response.data}');
      return true;
    } catch (e) {
      print('Error updating calendar: $e');
      return false;
    }
  }

  Future<bool> resetCalendar(String profileId) async {
    try {
     await _dio
          .put('https://fit-pro-app.glitch.me/api/calendar/66fab8339f1a05ead89c9065');

      return true;
    } catch (e) {
      print('Error resetting calendar: $e');
      return false;
    }
  }
}
