import '../../Data/Model/weekly_execises_model.dart';

abstract class WeeklyExerciseState {}

class WeeklyExerciseInitial extends WeeklyExerciseState {}

class WeeklyExerciseLoading extends WeeklyExerciseState {}

class WeeklyExerciseLoaded extends WeeklyExerciseState {
  final WeeklyExerciseModel calendar;
  WeeklyExerciseLoaded(this.calendar);
}

class WeeklyExerciseUpdating extends WeeklyExerciseState {}

class WeeklyExerciseUpdated extends WeeklyExerciseState {}

class WeeklyExerciseError extends WeeklyExerciseState {
  final String message;
  WeeklyExerciseError(this.message);
}
