import '../../../../Core/Networking/Dio/dio_weekly_execises_api.dart';

class WeeklyExerciseRepo {
  final DioWeeklyExerciseApi dioWeeklyExerciseApi;

  WeeklyExerciseRepo({required this.dioWeeklyExerciseApi});

  Future<Map<String, dynamic>?> fetchCalendar(String profileId) async {
    return await dioWeeklyExerciseApi.getCalendar(profileId);
  }

  Future<bool> updateWeeklyCalendar(String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    return await dioWeeklyExerciseApi.updateCalendar(profileId, weekNumber, dayUpdates);
  }

  Future<bool> resetWeeklyCalendar(String profileId) async {
    return await dioWeeklyExerciseApi.resetCalendar(profileId);
  }
}
