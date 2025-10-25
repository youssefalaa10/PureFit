part of 'exercise_cubit.dart';

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  ExerciseLoaded(this.exercises, {this.isFromCache = false});
  final List<ExerciseModel> exercises;
  final bool isFromCache;
}

class ExerciseConnectionError extends ExerciseState {
  ExerciseConnectionError(this.message, {this.cachedExercises});
  final String message;
  final List<ExerciseModel>? cachedExercises;
}

class ExerciseError extends ExerciseState {
  ExerciseError(this.message);
  final String message;
}
