import '../../Data/Model/weekly_execises_model.dart';

abstract class WeeklyExerciseState {}

class WeeklyExerciseInitial extends WeeklyExerciseState {}

class WeeklyExerciseLoading extends WeeklyExerciseState {}

class WeeklyExerciseLoaded extends WeeklyExerciseState {
  WeeklyExerciseLoaded(this.calendar, {this.isNewCalendar = false});
  final WeeklyExerciseModel calendar;
  final bool isNewCalendar;
}

class WeeklyExerciseUpdating extends WeeklyExerciseState {}

class WeeklyExerciseUpdated extends WeeklyExerciseState {}

class WeeklyExerciseError extends WeeklyExerciseState {
  WeeklyExerciseError(this.message);
  final String message;
}

class WeeklyExerciseConnectionError extends WeeklyExerciseState {
  WeeklyExerciseConnectionError(this.message);
  final String message;
}
