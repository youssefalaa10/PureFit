part of 'exercise_cubit.dart';

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  ExerciseLoaded(this.exercises);
  final List<ExerciseModel> exercises;
}

class ExerciseError extends ExerciseState {
  ExerciseError(this.message);
  final String message;
}
