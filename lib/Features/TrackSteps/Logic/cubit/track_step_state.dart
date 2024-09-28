part of 'track_step_cubit.dart';

sealed class TrackStepState {}

// Insert Track steps
final class TrackStepInitial extends TrackStepState {}

final class InsertTrackStepLoading extends TrackStepState {}

final class InsertTrackStepSucess extends TrackStepState {}

final class InsertTrackStepError extends TrackStepState {
  final String message;

  InsertTrackStepError({required this.message});
}

// Get track steps
final class GetTrackStepSucess extends TrackStepState {
  final List<TrackStepsModel> trackSteps;

  GetTrackStepSucess({required this.trackSteps});
}

final class GetTrackStepError extends TrackStepState {
  final String message;

  GetTrackStepError({required this.message});
}

final class GetTrackStepLoading extends TrackStepState {}

// Get Track Step by Date

final class GetTrackStepLoadingByDate extends TrackStepState {
  GetTrackStepLoadingByDate();
}

final class GetTrackStepSucessByDate extends TrackStepState {
  final TrackStepsModel? trackSteps;

  GetTrackStepSucessByDate({required this.trackSteps});
}

final class GetTrackStepErrorByDate extends TrackStepState {
  final String message;

  GetTrackStepErrorByDate({required this.message});
}

//Get Last Record
final class GetLastRecordLoading extends TrackStepState {}

final class GetLastRecordSucess extends TrackStepState {
  final String lastRecordedSteps;

  GetLastRecordSucess({required this.lastRecordedSteps});
}

final class GetLastRecordError extends TrackStepState {
  final String message;

  GetLastRecordError({required this.message});
}

//Inser Last Record
final class InsertLastRecordLoading extends TrackStepState {}

final class InsertLastRecordSuccess extends TrackStepState {}

final class InsertLastRecordError extends TrackStepState {
  final String message;

  InsertLastRecordError({required this.message});
}
