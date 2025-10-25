import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Model/weekly_execises_model.dart';
import '../../Data/Repo/weekly_execises_repo.dart';
import 'weekly_exercises_state.dart';

class WeeklyExerciseCubit extends Cubit<WeeklyExerciseState> {
  WeeklyExerciseCubit(this._repo) : super(WeeklyExerciseInitial());
  final WeeklyExerciseRepo _repo;
  WeeklyExerciseModel? calendar;

  Future<void> loadCalendar(String profileId) async {
    try {
      if (!isClosed) {
        emit(WeeklyExerciseLoading());
      }
      final result = await _repo.fetchCalendar(profileId);

      if (result == null) {
        if (!isClosed) {
          emit(WeeklyExerciseError('No calendar data available'));
        }
        return;
      }

      calendar = WeeklyExerciseModel.fromJson(result);

      // Check if this is a new/default calendar (all days are false)
      final bool isNewCalendar = _isDefaultCalendar(calendar!);

      if (!isClosed) {
        emit(WeeklyExerciseLoaded(calendar!, isNewCalendar: isNewCalendar));
      }
    } catch (e) {
      if (!isClosed) {
        // Check if it's a connection error
        if (e is DioException && e.type == DioExceptionType.connectionError) {
          emit(WeeklyExerciseConnectionError(
              'Connection failed. Please check your internet connection.'));
        } else if (e is String && e.contains('Connection')) {
          emit(WeeklyExerciseConnectionError(e));
        } else if (e is String) {
          emit(WeeklyExerciseError(e));
        } else {
          emit(WeeklyExerciseError('Failed to load calendar: $e'));
        }
      }
    }
  }

  bool _isDefaultCalendar(WeeklyExerciseModel calendar) {
    // Check if all days in all weeks are false (uncompleted)
    for (var week in calendar.weeks.values) {
      for (var dayCompleted in week.days.values) {
        if (dayCompleted) {
          return false; // Found a completed day, so it's not a default calendar
        }
      }
    }
    return true; // All days are false, it's a default/new calendar
  }

  Future<void> updateCalendar(
      String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    try {
      emit(WeeklyExerciseUpdating());
      await _repo.updateWeeklyCalendar(profileId, weekNumber, dayUpdates);

      emit(WeeklyExerciseUpdated());
      await loadCalendar(profileId);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionError) {
        emit(WeeklyExerciseConnectionError(
            'Connection failed. Please check your internet connection.'));
      } else {
        emit(WeeklyExerciseError('Failed to update calendar: $e'));
      }
    }
  }

  // Mark today as completed
  Future<void> markTodayAsCompleted(String profileId) async {
    try {
      final now = DateTime.now();
      final currentWeek = _getWeekNumber(now);
      final currentDay = _getDayName(now);

      await updateCalendar(profileId, currentWeek, {currentDay: true});
    } catch (e) {
      // Error handling is done in updateCalendar
    }
  }

  // Get completion status for a specific day
  bool isDayCompleted(String dayName, int weekNumber) {
    if (calendar == null) return false;

    final week = calendar!.weeks[weekNumber.toString()];
    if (week == null) return false;

    return week.days[dayName] ?? false;
  }

  // Get today's completion status
  bool isTodayCompleted() {
    final now = DateTime.now();
    final currentWeek = _getWeekNumber(now);
    final currentDay = _getDayName(now);

    return isDayCompleted(currentDay, currentWeek);
  }

  // Get completion statistics
  Map<String, dynamic> getCompletionStats() {
    if (calendar == null) {
      return {
        'totalDays': 0,
        'completedDays': 0,
        'completionRate': 0.0,
        'currentStreak': 0,
        'longestStreak': 0,
      };
    }

    int totalDays = 0;
    int completedDays = 0;
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    // Calculate stats from all weeks
    for (var week in calendar!.weeks.values) {
      for (var dayCompleted in week.days.values) {
        totalDays++;
        if (dayCompleted) {
          completedDays++;
          tempStreak++;
          currentStreak = tempStreak;
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
        } else {
          tempStreak = 0;
        }
      }
    }

    final completionRate = totalDays > 0 ? (completedDays / totalDays) : 0.0;

    return {
      'totalDays': totalDays,
      'completedDays': completedDays,
      'completionRate': completionRate,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  // Helper method to get week number
  int _getWeekNumber(DateTime date) {
    // Prefer computing relative to the calendar's start date (4-week window)
    if (calendar != null) {
      final start = DateTime(calendar!.startDate.year,
          calendar!.startDate.month, calendar!.startDate.day);
      final current = DateTime(date.year, date.month, date.day);
      final days = current.difference(start).inDays;
      final week = (days / 7).floor() + 1;
      if (week < 1) return 1;
      if (week > 4) return 4;
      return week;
    }
    // Fallback: treat current week as week 1 when calendar isn't loaded yet
    return 1;
  }

  // Helper method to get day name
  String _getDayName(DateTime date) {
    // Backend expects keys like day1..day7
    return 'day${date.weekday}';
  }

  // Get upcoming workouts for the week
  List<String> getUpcomingWorkouts() {
    if (calendar == null) return [];

    final now = DateTime.now();
    final currentWeek = _getWeekNumber(now);
    final currentDay = _getDayName(now);

    final week = calendar!.weeks[currentWeek.toString()];
    if (week == null) return [];

    final upcomingDays = <String>[];
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    final currentDayIndex = days.indexOf(currentDay);

    for (int i = currentDayIndex; i < days.length; i++) {
      final day = days[i];
      if (!(week.days[day] ?? false)) {
        upcomingDays.add(day);
      }
    }

    return upcomingDays;
  }
}
