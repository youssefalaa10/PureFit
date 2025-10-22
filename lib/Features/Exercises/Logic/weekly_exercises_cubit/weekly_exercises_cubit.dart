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
      emit(WeeklyExerciseError('Failed to update calendar'));
    }
  }
}
