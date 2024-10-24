import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Model/weekly_execises_model.dart';
import '../../Data/Repo/weekly_execises_repo.dart';
import 'weekly_exercises_state.dart';

class WeeklyExerciseCubit extends Cubit<WeeklyExerciseState> {
  final WeeklyExerciseRepo _repo;
  WeeklyExerciseModel? calendar;

  WeeklyExerciseCubit(this._repo) : super(WeeklyExerciseInitial());

  Future<void> loadCalendar(String profileId) async {
    try {
      if (!isClosed) {
        emit(WeeklyExerciseLoading());
      }
      final result = await _repo.fetchCalendar(profileId);

      calendar = WeeklyExerciseModel.fromJson(result!);
      if (!isClosed) {
        emit(WeeklyExerciseLoaded(calendar!));
      }
    } catch (e) {
      if (!isClosed) {
        emit(WeeklyExerciseError("Failed to load calendar"));
      }
    }
  }

  Future<void> updateCalendar(
      String profileId, int weekNumber, Map<String, bool> dayUpdates) async {
    try {
      emit(WeeklyExerciseUpdating());
      await _repo.updateWeeklyCalendar(profileId, weekNumber, dayUpdates);

      emit(WeeklyExerciseUpdated());
      await loadCalendar(profileId);
    } catch (e) {
      emit(WeeklyExerciseError("Failed to update calendar"));
    }
  }
}
