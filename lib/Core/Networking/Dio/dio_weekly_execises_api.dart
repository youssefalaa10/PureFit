import 'package:dio/dio.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class DioWeeklyExerciseApi {
  DioWeeklyExerciseApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<Map<String, dynamic>?> getCalendar(String profileId) async {
    try {
      final response = await _dio.get<dynamic>(
          '${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}');

      return response.data;
    } catch (e) {
      throw 'Error getting calendar';
    }
  }

  Future<bool> updateCalendar(
      String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    try {
      final response = await _dio.post<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}',
        data: {
          'weekNumber': weekNumber,
          'dayUpdates': dayUpdates,
        },
      );
      AppLogger.info('Response data Update: ${response.data}');
      return true;
    } catch (e) {
      throw 'updating calendar: $e';
    }
  }

  Future<bool> resetCalendar(String profileId) async {
    try {
      await _dio.put<dynamic>(
          '${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}');

      return true;
    } catch (e) {
      AppLogger.error('Error resetting calendar: $e', StackTrace.current);
      return false;
    }
  }
}
