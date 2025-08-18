import '../../Data/Model/weekly_execises_model.dart';

abstract class WeeklyExerciseState {}

class WeeklyExerciseInitial extends WeeklyExerciseState {}

class WeeklyExerciseLoading extends WeeklyExerciseState {}

class WeeklyExerciseLoaded extends WeeklyExerciseState {
  WeeklyExerciseLoaded(this.calendar);
  final WeeklyExerciseModel calendar;
}

class WeeklyExerciseUpdating extends WeeklyExerciseState {}

class WeeklyExerciseUpdated extends WeeklyExerciseState {}

class WeeklyExerciseError extends WeeklyExerciseState {
  WeeklyExerciseError(this.message);
  final String message;
}
