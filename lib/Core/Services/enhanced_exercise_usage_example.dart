// Example usage of enhanced exercise features
// This file shows how to use the voice services and workout tracking

import 'package:PureFit/Core/Services/voice_service.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';

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
    print('Total workouts: ${history.length}');

    // Get personal records
    final records = await WorkoutTrackingService.getPersonalRecords();
    print('Personal records: ${records.length}');

    // Get workout streak
    final streak = await WorkoutTrackingService.getWorkoutStreak();
    print('Workout streak: $streak days');

    // Get total calories burned
    final calories = await WorkoutTrackingService.getTotalCaloriesBurned();
    print('Total calories burned: $calories');

    // Get total workout time
    final time = await WorkoutTrackingService.getTotalWorkoutTime();
    print('Total workout time: $time minutes');

    // Get comprehensive stats
    final stats = await WorkoutTrackingService.getWorkoutStats();
    print('Stats: $stats');
  }

  // Example: Check for personal records
  static Future<void> checkPersonalRecords() async {
    final records = await WorkoutTrackingService.getPersonalRecords();

    for (final record in records) {
      print('${record.exerciseName}:');
      print('  Best weight: ${record.bestWeight} kg');
      print('  Best reps: ${record.bestReps}');
      print('  Best duration: ${record.bestDuration} seconds');
      print('  Achieved on: ${record.achievedDate}');
    }
  }

  // Example: Get recent workouts
  static Future<void> getRecentWorkouts() async {
    final recent = await WorkoutTrackingService.getRecentWorkouts();

    for (final workout in recent) {
      print('${workout.workoutName} - ${workout.caloriesBurned} cal');
    }
  }

  // Example: Voice settings
  static Future<void> manageVoiceSettings() async {
    final voiceService = VoiceService();

    // Check if voice is enabled
    print('Voice enabled: ${voiceService.isEnabled}');

    // Toggle voice
    await voiceService.setEnabled(!voiceService.isEnabled);

    // Change language
    await voiceService.setLanguage('ar'); // Arabic

    // Stop current speech
    await voiceService.stop();
  }
}
