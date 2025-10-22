part of 'workout_programs_cubit.dart';

abstract class WorkoutProgramsState {}

class WorkoutProgramsInitial extends WorkoutProgramsState {}

class WorkoutProgramsLoading extends WorkoutProgramsState {}

class WorkoutProgramsSuccess extends WorkoutProgramsState {
  WorkoutProgramsSuccess(this.workoutPrograms);
  final List<WorkoutCategoriesModel> workoutPrograms;
}

class WorkoutProgramsError extends WorkoutProgramsState {
  WorkoutProgramsError(this.message);
  final String message;
}

class WorkoutProgramsConnectionError extends WorkoutProgramsState {
  WorkoutProgramsConnectionError(this.message);
  final String message;
}
