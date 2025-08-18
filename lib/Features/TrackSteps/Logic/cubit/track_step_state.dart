part of 'track_step_cubit.dart';

sealed class TrackStepState {}

// Insert Track steps
final class TrackStepInitial extends TrackStepState {}

final class InsertTrackStepLoading extends TrackStepState {}

final class InsertTrackStepSucess extends TrackStepState {}

final class InsertTrackStepError extends TrackStepState {
  InsertTrackStepError({required this.message});
  final String message;
}

// Get track steps
final class GetTrackStepSucess extends TrackStepState {
  GetTrackStepSucess({required this.trackSteps});
  final List<TrackStepsModel> trackSteps;
}

final class GetTrackStepError extends TrackStepState {
  GetTrackStepError({required this.message});
  final String message;
}

final class GetTrackStepLoading extends TrackStepState {}

// Get Track Step by Date

final class GetTrackStepLoadingByDate extends TrackStepState {
  GetTrackStepLoadingByDate();
}

final class GetTrackStepSucessByDate extends TrackStepState {
  GetTrackStepSucessByDate({required this.trackSteps});
  final TrackStepsModel? trackSteps;
}

final class GetTrackStepErrorByDate extends TrackStepState {
  GetTrackStepErrorByDate({required this.message});
  final String message;
}

//Get Last Record
final class GetLastRecordLoading extends TrackStepState {}

final class GetLastRecordSucess extends TrackStepState {
  GetLastRecordSucess({required this.lastRecordedSteps});
  final String lastRecordedSteps;
}

final class GetLastRecordError extends TrackStepState {
  GetLastRecordError({required this.message});
  final String message;
}

//Inser Last Record
final class InsertLastRecordLoading extends TrackStepState {}

final class InsertLastRecordSuccess extends TrackStepState {}

final class InsertLastRecordError extends TrackStepState {
  InsertLastRecordError({required this.message});
  final String message;
}
