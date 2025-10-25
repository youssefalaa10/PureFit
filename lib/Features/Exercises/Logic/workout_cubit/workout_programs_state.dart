part of 'workout_programs_cubit.dart';

abstract class WorkoutProgramsState {}

class WorkoutProgramsInitial extends WorkoutProgramsState {}

class WorkoutProgramsLoading extends WorkoutProgramsState {}

class WorkoutProgramsSuccess extends WorkoutProgramsState {
  WorkoutProgramsSuccess(this.workoutPrograms, {this.isFromCache = false});
  final List<WorkoutCategoriesModel> workoutPrograms;
  final bool isFromCache;
}

class WorkoutProgramsError extends WorkoutProgramsState {
  WorkoutProgramsError(this.message);
  final String message;
}

class WorkoutProgramsConnectionError extends WorkoutProgramsState {
  WorkoutProgramsConnectionError(this.message, {this.cachedPrograms});
  final String message;
  final List<WorkoutCategoriesModel>? cachedPrograms;
}
