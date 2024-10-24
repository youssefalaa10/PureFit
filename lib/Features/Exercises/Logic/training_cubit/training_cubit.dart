import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
part 'training_state.dart';

class TrainingCubit extends Cubit<TrainingCubitState> {
  List<ExerciseModel>? passExercises;
  Timer? _timer;
  int currentExercise = 0;
  final int getReadyDuration = 3;
  final int exerciseDuration = 1;
  int restDuration = 100; // Can be modified dynamically
  bool isPaused = false; // Pause flag
  int? remainingTime; // Remaining time to continue from when paused
  EnumTrainingStage? currentStage; // Store the current stage

  TrainingCubit(List<ExerciseModel> exercises) : super(TrainingInitial()) {
    passExercises = exercises;
  }

  // Start the stages
  void startExerciseRoutine() {
    if (passExercises != null && passExercises!.isNotEmpty) {
      _startGetReadyStage();
    } else {
      emit(TrainingError("No exercises available"));
    }
  }

  // Start Get Ready Stage and First Stage
  void _startGetReadyStage() {
    if (currentExercise >= (passExercises?.length ?? 0)) {
      emit(TrainingCompleted());
    }
    currentStage = EnumTrainingStage.getReady;
    _startTimer(getReadyDuration, _startExerciseStage);
  }

  // Start Exercise Stage and This is Second Stage
  void _startExerciseStage() {
    currentStage = EnumTrainingStage.start;
    // _startTimer(exerciseDuration, _startRestStage);
    _startTimer(exerciseDuration, () {
      if (currentExercise == (passExercises?.length ?? 0) - 1) {
        // If this is the last exercise, mark training as completed
        emit(TrainingCompleted());
      } else {
        // Otherwise, start the rest stage
        _startRestStage();
      }
    });
  }

  // Start Rest Stage (skipped for the last exercise)
  void _startRestStage() {
    currentStage = EnumTrainingStage.rest;
    _startTimer(restDuration, _nextExercise);
  }

  // Move to the next exercise
  void _nextExercise() {
    currentExercise++;
    if (currentExercise < (passExercises?.length ?? 0)) {
      _startGetReadyStage(); // Start the next exercise
    } else {
      _timer?.cancel();
      emit(
          TrainingCompleted()); // Just in case, ensure we emit completion here too
    }
  }

  // Start Timer with specified duration
  void _startTimer(int duration, Function onComplete) {
    _timer?.cancel();
    remainingTime = duration;
    emit(TrainingStage(currentStage!, currentExercise, remainingTime!));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPaused) {
        return;
      }
      remainingTime = remainingTime! - 1;
      emit(TrainingStage(currentStage!, currentExercise, remainingTime!));

      if (remainingTime == 0) {
        timer.cancel();
        onComplete();
      }
    });
  }

  // Pause the routine
  void pauseRoutine() {
    isPaused = true;
  }

  // Resume the routine
  void resumeRoutine() {
    isPaused = false;
    // Use the remaining time for the timer
    _startTimer(remainingTime!, () {
      if (currentStage == EnumTrainingStage.getReady) {
        _startExerciseStage();
      } else if (currentStage == EnumTrainingStage.start) {
        _startRestStage();
      } else if (currentStage == EnumTrainingStage.rest) {
        _nextExercise();
      }
    });
  }

  // Skip Get Ready Stage
  void skipGetReady() {
    if (currentStage == EnumTrainingStage.getReady) {
      _timer?.cancel();
      _startExerciseStage();
    }
  }

  // Skip Rest Stage
  void skipRest() {
    if (currentStage == EnumTrainingStage.rest) {
      _timer?.cancel();
      _nextExercise();
    }
  }

  // Add extra time to rest
  void addRestTime(int extraSeconds) {
    restDuration += extraSeconds;
    if (currentStage == EnumTrainingStage.rest) {
      // Restart rest timer with new duration if currently in rest stage
      _timer?.cancel();
      _startRestStage();
    }
  }

  // Cancel the timer when the cubit is closed
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
