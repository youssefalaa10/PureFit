part of 'training_cubit.dart';

enum EnumTrainingStage { getReady, start, rest }

sealed class TrainingCubitState {}

class TrainingInitial extends TrainingCubitState {}

class TrainingLoading extends TrainingCubitState {}

class TrainingError extends TrainingCubitState {
  TrainingError(this.message);
  final String message;
}

// State representing the current stage and exercise index
class TrainingStage extends TrainingCubitState {
  TrainingStage(this.stage, this.currentExerciseIndex, this.remainingTime);
  final EnumTrainingStage stage;
  final int currentExerciseIndex;
  final int remainingTime;
}

// State when training is completed
class TrainingCompleted extends TrainingCubitState {}
