part of 'training_cubit.dart';

enum EnumTrainingStage { getReady, start, rest }

sealed class TrainingCubitState {}

class TrainingInitial extends TrainingCubitState {}

class TrainingLoading extends TrainingCubitState {}

class TrainingError extends TrainingCubitState {
  final String message;
  TrainingError(this.message);
}

// State representing the current stage and exercise index
class TrainingStage extends TrainingCubitState {
  final EnumTrainingStage stage;
  final int currentExerciseIndex;
  final int remainingTime;

  TrainingStage(this.stage, this.currentExerciseIndex, this.remainingTime);
}

// State when training is completed
class TrainingCompleted extends TrainingCubitState {}
