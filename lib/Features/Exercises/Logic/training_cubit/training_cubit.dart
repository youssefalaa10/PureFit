import 'dart:async';

import 'package:PureFit/Core/Services/voice_service.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:bloc/bloc.dart';

part 'training_state.dart';

class TrainingCubit extends Cubit<TrainingCubitState> {
  // Store the current stage

  TrainingCubit(List<ExerciseModel> exercises) : super(TrainingInitial()) {
    passExercises = exercises;
    _voiceService = VoiceService();
    _workoutStartTime = DateTime.now();
    _initializeVoice();
  }

  List<ExerciseModel>? passExercises;
  Timer? _timer;
  int currentExercise = 0;
  final int getReadyDuration = 5;
  final int exerciseDuration = 30;
  int restDuration = 20; // Can be modified dynamically
  bool isPaused = false; // Pause flag
  int? remainingTime; // Remaining time to continue from when paused
  EnumTrainingStage? currentStage;

  // Voice and tracking services
  late VoiceService _voiceService;
  DateTime? _workoutStartTime;
  String? _workoutName;
  final List<ExerciseRecord> _currentSessionExercises = [];

  // Initialize voice service
  Future<void> _initializeVoice() async {
    await _voiceService.initialize();
  }

  // Set workout name for tracking
  void setWorkoutName(String name) {
    _workoutName = name;
  }

  // Start the stages
  void startExerciseRoutine() {
    if (passExercises != null && passExercises!.isNotEmpty) {
      _startGetReadyStage();
    } else {
      emit(TrainingError('No exercises available'));
    }
  }

  // Start Get Ready Stage and First Stage
  void _startGetReadyStage() {
    if (currentExercise >= (passExercises?.length ?? 0)) {
      _completeWorkout();
      return;
    }
    currentStage = EnumTrainingStage.getReady;

    // Voice announcement for next exercise
    if (passExercises != null && currentExercise < passExercises!.length) {
      final exerciseName = passExercises![currentExercise].name;
      _voiceService.speakGetReady(exerciseName);
    }

    _startTimer(getReadyDuration, _startExerciseStage);
  }

  // Start Exercise Stage and This is Second Stage
  void _startExerciseStage() {
    currentStage = EnumTrainingStage.start;

    // Voice announcement for starting exercise
    if (passExercises != null && currentExercise < passExercises!.length) {
      final exerciseName = passExercises![currentExercise].name;
      _voiceService.speakStartExercise(exerciseName);
    }

    _startTimer(exerciseDuration, () {
      // Record exercise completion
      _recordExerciseCompletion();

      if (currentExercise == (passExercises?.length ?? 0) - 1) {
        // If this is the last exercise, mark training as completed
        _completeWorkout();
      } else {
        // Otherwise, start the rest stage
        _startRestStage();
      }
    });
  }

  // Start Rest Stage (skipped for the last exercise)
  void _startRestStage() {
    currentStage = EnumTrainingStage.rest;

    // Voice announcement for rest time
    _voiceService.speakRestTime(restDuration);

    _startTimer(restDuration, _nextExercise);
  }

  // Move to the next exercise
  void _nextExercise() {
    currentExercise++;
    if (currentExercise < (passExercises?.length ?? 0)) {
      _startGetReadyStage(); // Start the next exercise
    } else {
      _timer?.cancel();
      _completeWorkout(); // Just in case, ensure we emit completion here too
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

  // Record exercise completion
  void _recordExerciseCompletion() {
    if (passExercises != null && currentExercise < passExercises!.length) {
      final exercise = passExercises![currentExercise];
      final record = ExerciseRecord(
        exerciseName: exercise.name,
        duration: exerciseDuration,
        sets: 1,
        reps: 1, // Default reps, can be enhanced later
        weight: 0.0, // Default weight, can be enhanced later
        notes: '',
      );
      _currentSessionExercises.add(record);
    }
  }

  // Complete workout and save session
  void _completeWorkout() async {
    if (_workoutStartTime != null && _currentSessionExercises.isNotEmpty) {
      final workoutSession = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workoutName: _workoutName ?? 'Workout',
        startTime: _workoutStartTime!,
        endTime: DateTime.now(),
        totalDuration: DateTime.now().difference(_workoutStartTime!).inSeconds,
        exercises: _currentSessionExercises,
        caloriesBurned: _calculateCaloriesBurned(),
        difficulty: 'Medium', // Can be enhanced later
      );

      await WorkoutTrackingService.saveWorkoutSession(workoutSession);

      // Voice announcement for workout completion
      _voiceService.speakWorkoutComplete();
    }

    emit(TrainingCompleted());
  }

  // Calculate calories burned (simplified calculation)
  int _calculateCaloriesBurned() {
    // Simple calculation: 10 calories per minute of exercise
    final totalMinutes = _currentSessionExercises.fold(
            0, (sum, exercise) => sum + exercise.duration) /
        60;
    return (totalMinutes * 10).round();
  }

  // Get current progress
  int get currentProgress => currentExercise;
  int get totalExercises => passExercises?.length ?? 0;
  double get progressPercentage =>
      totalExercises > 0 ? (currentExercise / totalExercises) : 0.0;

  // Cancel the timer when the cubit is closed
  @override
  Future<void> close() {
    _timer?.cancel();
    _voiceService.dispose();
    return super.close();
  }
}
