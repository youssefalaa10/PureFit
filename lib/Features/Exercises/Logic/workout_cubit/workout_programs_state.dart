part of 'workout_programs_cubit.dart';

abstract class WorkoutProgramsState {}

class WorkoutProgramsInitial extends WorkoutProgramsState {}

class WorkoutProgramsLoading extends WorkoutProgramsState {}

class WorkoutProgramsSuccess extends WorkoutProgramsState {
  final List<WorkoutCategoriesModel> workoutPrograms;

  WorkoutProgramsSuccess(this.workoutPrograms);
}

class WorkoutProgramsError extends WorkoutProgramsState {
  final String message;

  WorkoutProgramsError(this.message);
}
