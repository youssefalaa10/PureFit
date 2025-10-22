import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSession {
  WorkoutSession({
    required this.id,
    required this.workoutName,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.exercises,
    required this.caloriesBurned,
    required this.difficulty,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'],
        workoutName: json['workoutName'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        totalDuration: json['totalDuration'],
        exercises: (json['exercises'] as List)
            .map((e) => ExerciseRecord.fromJson(e))
            .toList(),
        caloriesBurned: json['caloriesBurned'],
        difficulty: json['difficulty'],
      );
  final String id;
  final String workoutName;
  final DateTime startTime;
  final DateTime endTime;
  final int totalDuration; // in seconds
  final List<ExerciseRecord> exercises;
  final int caloriesBurned;
  final String difficulty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutName': workoutName,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'totalDuration': totalDuration,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'caloriesBurned': caloriesBurned,
        'difficulty': difficulty,
      };
}

class ExerciseRecord {
  ExerciseRecord({
    required this.exerciseName,
    required this.duration,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.notes,
  });

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) => ExerciseRecord(
        exerciseName: json['exerciseName'],
        duration: json['duration'],
        sets: json['sets'],
        reps: json['reps'],
        weight: json['weight']?.toDouble() ?? 0.0,
        notes: json['notes'] ?? '',
      );
  final String exerciseName;
  final int duration; // in seconds
  final int sets;
  final int reps;
  final double weight; // in kg
  final String notes;

  Map<String, dynamic> toJson() => {
        'exerciseName': exerciseName,
        'duration': duration,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'notes': notes,
      };
}

class PersonalRecord {
  PersonalRecord({
    required this.exerciseName,
    required this.bestWeight,
    required this.bestReps,
    required this.bestDuration,
    required this.achievedDate,
  });

  factory PersonalRecord.fromJson(Map<String, dynamic> json) => PersonalRecord(
        exerciseName: json['exerciseName'],
        bestWeight: json['bestWeight']?.toDouble() ?? 0.0,
        bestReps: json['bestReps'],
        bestDuration: json['bestDuration'],
        achievedDate: DateTime.parse(json['achievedDate']),
      );
  final String exerciseName;
  final double bestWeight;
  final int bestReps;
  final int bestDuration;
  final DateTime achievedDate;

  Map<String, dynamic> toJson() => {
        'exerciseName': exerciseName,
        'bestWeight': bestWeight,
        'bestReps': bestReps,
        'bestDuration': bestDuration,
        'achievedDate': achievedDate.toIso8601String(),
      };
}

class WorkoutTrackingService {
  static const String _workoutHistoryKey = 'workout_history';
  static const String _personalRecordsKey = 'personal_records';
  static const String _workoutStreakKey = 'workout_streak';
  static const String _lastWorkoutDateKey = 'last_workout_date';

  // Save workout session
  static Future<void> saveWorkoutSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWorkoutHistory();

    history.add(session);

    // Keep only last 100 sessions
    if (history.length > 100) {
      history.removeRange(0, history.length - 100);
    }

    final historyJson = history.map((s) => s.toJson()).toList();
    await prefs.setString(_workoutHistoryKey, jsonEncode(historyJson));

    // Update personal records
    await _updatePersonalRecords(session);

    // Update workout streak
    await _updateWorkoutStreak();
  }

  // Get workout history
  static Future<List<WorkoutSession>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_workoutHistoryKey);

    if (historyJson == null) return [];

    try {
      final List<dynamic> historyList = jsonDecode(historyJson);
      return historyList.map((json) => WorkoutSession.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing workout history: $e');
      return [];
    }
  }

  // Get personal records
  static Future<List<PersonalRecord>> getPersonalRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_personalRecordsKey);

    if (recordsJson == null) return [];

    try {
      final List<dynamic> recordsList = jsonDecode(recordsJson);
      return recordsList.map((json) => PersonalRecord.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing personal records: $e');
      return [];
    }
  }

  // Get workout streak
  static Future<int> getWorkoutStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_workoutStreakKey) ?? 0;
  }

  // Get total workouts completed
  static Future<int> getTotalWorkouts() async {
    final history = await getWorkoutHistory();
    return history.length;
  }

  // Get total calories burned
  static Future<int> getTotalCaloriesBurned() async {
    final history = await getWorkoutHistory();
    return history.fold<int>(0, (sum, session) => sum + session.caloriesBurned);
  }

  // Get total workout time (in minutes)
  static Future<int> getTotalWorkoutTime() async {
    final history = await getWorkoutHistory();
    return history.fold(0, (sum, session) => sum + session.totalDuration) ~/ 60;
  }

  // Get recent workouts (last 7 days)
  static Future<List<WorkoutSession>> getRecentWorkouts() async {
    final history = await getWorkoutHistory();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return history
        .where((session) => session.startTime.isAfter(weekAgo))
        .toList();
  }

  // Get workout statistics
  static Future<Map<String, dynamic>> getWorkoutStats() async {
    final history = await getWorkoutHistory();
    final streak = await getWorkoutStreak();

    if (history.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalCalories': 0,
        'totalTime': 0,
        'streak': streak,
        'averageWorkoutTime': 0,
        'favoriteExercise': '',
        'recentWorkouts': 0,
      };
    }

    final totalCalories =
        history.fold(0, (sum, session) => sum + session.caloriesBurned);
    final totalTime =
        history.fold(0, (sum, session) => sum + session.totalDuration);
    final averageTime = totalTime / history.length;

    // Find most frequent exercise
    final exerciseCount = <String, int>{};
    for (final session in history) {
      for (final exercise in session.exercises) {
        exerciseCount[exercise.exerciseName] =
            (exerciseCount[exercise.exerciseName] ?? 0) + 1;
      }
    }

    final favoriteExercise = exerciseCount.isNotEmpty
        ? exerciseCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    final recentWorkouts = await getRecentWorkouts();

    return {
      'totalWorkouts': history.length,
      'totalCalories': totalCalories,
      'totalTime': totalTime ~/ 60, // in minutes
      'streak': streak,
      'averageWorkoutTime': (averageTime / 60).round(), // in minutes
      'favoriteExercise': favoriteExercise,
      'recentWorkouts': recentWorkouts.length,
    };
  }

  // Update personal records
  static Future<void> _updatePersonalRecords(WorkoutSession session) async {
    final currentRecords = await getPersonalRecords();
    final newRecords = <PersonalRecord>[];

    for (final exercise in session.exercises) {
      final existingRecord = currentRecords.firstWhere(
        (record) => record.exerciseName == exercise.exerciseName,
        orElse: () => PersonalRecord(
          exerciseName: exercise.exerciseName,
          bestWeight: 0,
          bestReps: 0,
          bestDuration: 0,
          achievedDate: DateTime.now(),
        ),
      );

      bool updated = false;
      double bestWeight = existingRecord.bestWeight;
      int bestReps = existingRecord.bestReps;
      int bestDuration = existingRecord.bestDuration;
      DateTime achievedDate = existingRecord.achievedDate;

      if (exercise.weight > bestWeight) {
        bestWeight = exercise.weight;
        updated = true;
      }

      if (exercise.reps > bestReps) {
        bestReps = exercise.reps;
        updated = true;
      }

      if (exercise.duration > bestDuration) {
        bestDuration = exercise.duration;
        updated = true;
      }

      if (updated) {
        achievedDate = session.startTime;
      }

      newRecords.add(PersonalRecord(
        exerciseName: exercise.exerciseName,
        bestWeight: bestWeight,
        bestReps: bestReps,
        bestDuration: bestDuration,
        achievedDate: achievedDate,
      ));
    }

    // Save updated records
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = newRecords.map((r) => r.toJson()).toList();
    await prefs.setString(_personalRecordsKey, jsonEncode(recordsJson));
  }

  // Update workout streak
  static Future<void> _updateWorkoutStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastWorkoutDate = prefs.getString(_lastWorkoutDateKey);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastWorkoutDate == null) {
      // First workout
      await prefs.setInt(_workoutStreakKey, 1);
      await prefs.setString(_lastWorkoutDateKey, todayDate.toIso8601String());
    } else {
      final lastDate = DateTime.parse(lastWorkoutDate);
      final lastDateOnly =
          DateTime(lastDate.year, lastDate.month, lastDate.day);
      final difference = todayDate.difference(lastDateOnly).inDays;

      if (difference == 1) {
        // Consecutive day
        final currentStreak = prefs.getInt(_workoutStreakKey) ?? 0;
        await prefs.setInt(_workoutStreakKey, currentStreak + 1);
      } else if (difference == 0) {
        // Same day, don't update streak
        return;
      } else {
        // Streak broken, reset to 1
        await prefs.setInt(_workoutStreakKey, 1);
      }

      await prefs.setString(_lastWorkoutDateKey, todayDate.toIso8601String());
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workoutHistoryKey);
    await prefs.remove(_personalRecordsKey);
    await prefs.remove(_workoutStreakKey);
    await prefs.remove(_lastWorkoutDateKey);
  }
}
