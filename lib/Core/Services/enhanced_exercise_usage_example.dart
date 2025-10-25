// Example usage of enhanced exercise features
// This file shows how to use the voice services and workout tracking

import 'package:PureFit/Core/Services/voice_service.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';

class EnhancedExerciseUsageExample {
  // Example: Initialize voice service
  static Future<void> initializeVoice() async {
    final voiceService = VoiceService();
    await voiceService.initialize();

    // Enable/disable voice
    await voiceService.setEnabled(true);

    // Set language
    await voiceService.setLanguage('en');
  }

  // Example: Use voice during workout
  static Future<void> useVoiceDuringWorkout() async {
    final voiceService = VoiceService();

    // Announce next exercise
    await voiceService.speakExerciseName('Push-ups');

    // Announce get ready
    await voiceService.speakGetReady('Push-ups');

    // Announce start
    await voiceService.speakStartExercise('Push-ups');

    // Announce rest time
    await voiceService.speakRestTime(30);

    // Announce progress
    await voiceService.speakProgress(3, 10);

    // Announce time remaining
    await voiceService.speakTimeRemaining(15);

    // Announce workout complete
    await voiceService.speakWorkoutComplete();
  }

  // Example: Track workout session
  static Future<void> trackWorkoutSession() async {
    // Create exercise records
    final exercises = [
      ExerciseRecord(
        exerciseName: 'Push-ups',
        duration: 30,
        sets: 3,
        reps: 15,
        weight: 0.0,
        notes: 'Good form maintained',
      ),
      ExerciseRecord(
        exerciseName: 'Squats',
        duration: 30,
        sets: 3,
        reps: 20,
        weight: 0.0,
        notes: 'Deep squats',
      ),
    ];

    // Create workout session
    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutName: 'Morning Workout',
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      endTime: DateTime.now(),
      totalDuration: 1800, // 30 minutes
      exercises: exercises,
      caloriesBurned: 150,
      difficulty: 'Medium',
    );

    // Save workout session
    await WorkoutTrackingService.saveWorkoutSession(session);
  }

  // Example: Get workout statistics
  static Future<void> getWorkoutStats() async {
    // Get workout history
    final history = await WorkoutTrackingService.getWorkoutHistory();
    AppLogger.info('Total workouts: ${history.length}');

    // Get personal records
    final records = await WorkoutTrackingService.getPersonalRecords();
    AppLogger.info('Personal records: ${records.length}');

    // Get workout streak
    final streak = await WorkoutTrackingService.getWorkoutStreak();
    AppLogger.info('Workout streak: $streak days');

    // Get total calories burned
    final calories = await WorkoutTrackingService.getTotalCaloriesBurned();
    AppLogger.info('Total calories burned: $calories');

    // Get total workout time
    final time = await WorkoutTrackingService.getTotalWorkoutTime();
    AppLogger.info('Total workout time: $time minutes');

    // Get comprehensive stats
    final stats = await WorkoutTrackingService.getWorkoutStats();
    AppLogger.info('Stats: $stats');
  }

  // Example: Check for personal records
  static Future<void> checkPersonalRecords() async {
    final records = await WorkoutTrackingService.getPersonalRecords();

    for (final record in records) {
      AppLogger.info('${record.exerciseName}:');
      AppLogger.info('  Best weight: ${record.bestWeight} kg');
      AppLogger.info('  Best reps: ${record.bestReps}');
      AppLogger.info('  Best duration: ${record.bestDuration} seconds');
      AppLogger.info('  Achieved on: ${record.achievedDate}');
    }
  }

  // Example: Get recent workouts
  static Future<void> getRecentWorkouts() async {
    final recent = await WorkoutTrackingService.getRecentWorkouts();

    for (final workout in recent) {
      AppLogger.info('${workout.workoutName} - ${workout.caloriesBurned} cal');
    }
  }

  // Example: Voice settings
  static Future<void> manageVoiceSettings() async {
    final voiceService = VoiceService();

    // Check if voice is enabled
    AppLogger.info('Voice enabled: ${voiceService.isEnabled}');

    // Toggle voice
    await voiceService.setEnabled(!voiceService.isEnabled);

    // Change language
    await voiceService.setLanguage('ar'); // Arabic

    // Stop current speech
    await voiceService.stop();
  }
}
