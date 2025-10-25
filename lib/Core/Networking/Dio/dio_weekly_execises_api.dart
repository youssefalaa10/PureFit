import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';
import '../ErrorHandler/api_error_handler.dart';

class DioWeeklyExerciseApi {
  DioWeeklyExerciseApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<Map<String, dynamic>?> getCalendar(String profileId) async {
    try {
      final response = await _dio.get<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiCalender(profileId)}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            // Accept 404 as a valid response (calendar doesn't exist yet)
            return status != null && (status < 500 || status == 404);
          },
        ),
      );

      if (response.statusCode == 404) {
        // Calendar doesn't exist yet, return default empty calendar
        if (kDebugMode) {
          AppLogger.info(
              'Calendar not found for user $profileId, creating default calendar');
        }
        return _createDefaultCalendar();
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      } else {
        if (kDebugMode) {
          AppLogger.error(
              'Error fetching calendar: Status Code ${response.statusCode}',
              StackTrace.current);
        }
        return _createDefaultCalendar();
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error fetching calendar: $e', StackTrace.current);
      }

      // Check if it's a connection error
      if (e is DioException && e.type == DioExceptionType.connectionError) {
        final api = ApiErrorHandler.handle(e);
        throw api.message ?? 'Connection error';
      }

      // For other errors, return default calendar
      return _createDefaultCalendar();
    }
  }

  Map<String, dynamic> _createDefaultCalendar() {
    final now = DateTime.now();
    final startDate = now.subtract(
        Duration(days: now.weekday - 1)); // Start of current week (Monday)
    final endDate =
        startDate.add(const Duration(days: 27)); // 4 weeks from start

    return {
      'profileId': 'default',
      'weeks': {
        '1': {
          '_id': 'week1',
          'day1': false,
          'day2': false,
          'day3': false,
          'day4': false,
          'day5': false,
          'day6': false,
          'day7': false,
        },
        '2': {
          '_id': 'week2',
          'day1': false,
          'day2': false,
          'day3': false,
          'day4': false,
          'day5': false,
          'day6': false,
          'day7': false,
        },
        '3': {
          '_id': 'week3',
          'day1': false,
          'day2': false,
          'day3': false,
          'day4': false,
          'day5': false,
          'day6': false,
          'day7': false,
        },
        '4': {
          '_id': 'week4',
          'day1': false,
          'day2': false,
          'day3': false,
          'day4': false,
          'day5': false,
          'day6': false,
          'day7': false,
        },
      },
      'createdAt': now.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
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
