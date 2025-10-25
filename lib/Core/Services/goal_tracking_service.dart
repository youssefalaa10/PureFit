import 'package:shared_preferences/shared_preferences.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';

/// Centralized service for managing goal achievements and celebrations
class GoalTrackingService {
  static const String _stepGoalKey = 'step_goal_achieved_today';
  static const String _waterGoalKey = 'water_goal_achieved_today';
  static const String _stepResetDateKey = 'step_goal_reset_date';
  static const String _waterResetDateKey = 'water_goal_reset_date';
  static const String _stepLastAchievedGoalKey = 'step_last_achieved_goal';
  static const String _waterLastAchievedGoalKey = 'water_last_achieved_goal';

  /// Check if a specific goal value has already been achieved today
  static Future<bool> isSpecificGoalAchievedToday(
      String goalType, int goalValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String lastAchievedKey = _getLastAchievedGoalKey(goalType);
      final int lastAchievedGoal = prefs.getInt(lastAchievedKey) ?? 0;

      // If the current goal is higher than what was last achieved, allow celebration
      return goalValue <= lastAchievedGoal;
    } catch (e) {
      AppLogger.error(
          'Error checking specific goal achievement: $e', StackTrace.current);
      return false;
    }
  }

  /// Check if a goal has already been achieved today (legacy method for backward compatibility)
  static Future<bool> isGoalAchievedToday(String goalType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String key = _getGoalKey(goalType);
      return prefs.getBool(key) ?? false;
    } catch (e) {
      AppLogger.error(
          'Error checking goal achievement: $e', StackTrace.current);
      return false;
    }
  }

  /// Mark a specific goal value as achieved for today
  static Future<void> markSpecificGoalAchieved(
      String goalType, int goalValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String lastAchievedKey = _getLastAchievedGoalKey(goalType);
      final int lastAchievedGoal = prefs.getInt(lastAchievedKey) ?? 0;

      // Only update if this is a higher goal than previously achieved
      if (goalValue > lastAchievedGoal) {
        await prefs.setInt(lastAchievedKey, goalValue);
      }
    } catch (e) {
      AppLogger.error(
          'Error marking specific goal as achieved: $e', StackTrace.current);
    }
  }

  /// Mark a goal as achieved for today
  static Future<void> markGoalAchieved(String goalType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String key = _getGoalKey(goalType);
      await prefs.setBool(key, true);
    } catch (e) {
      AppLogger.error('Error marking goal as achieved: $e', StackTrace.current);
    }
  }

  /// Reset goal achievement flags for new day
  static Future<void> resetGoalFlagsForNewDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String todayDate =
          DateTime.now().toIso8601String().split('T').first;

      // Reset step goal flag
      final String? lastStepResetDate = prefs.getString(_stepResetDateKey);
      if (lastStepResetDate != todayDate) {
        await prefs.setBool(_stepGoalKey, false);
        await prefs.setInt(_stepLastAchievedGoalKey, 0);
        await prefs.setString(_stepResetDateKey, todayDate);
      }

      // Reset water goal flag
      final String? lastWaterResetDate = prefs.getString(_waterResetDateKey);
      if (lastWaterResetDate != todayDate) {
        await prefs.setBool(_waterGoalKey, false);
        await prefs.setInt(_waterLastAchievedGoalKey, 0);
        await prefs.setString(_waterResetDateKey, todayDate);
      }
    } catch (e) {
      AppLogger.error('Error resetting goal flags: $e', StackTrace.current);
    }
  }

  /// Check and celebrate step goal achievement with dynamic goal support
  static Future<void> checkStepGoalAchievement(
      int currentSteps, int goalSteps) async {
    try {
      final bool alreadyAchieved =
          await isSpecificGoalAchievedToday('steps', goalSteps);

      if (currentSteps >= goalSteps && !alreadyAchieved) {
        await markSpecificGoalAchieved('steps', goalSteps);
        await NotificationController.showGoalAchievement(
          goalType: 'steps',
          achievement: 'You hit your daily step goal of $goalSteps steps!',
        );
      }
    } catch (e) {
      AppLogger.error(
          'Error checking step goal achievement: $e', StackTrace.current);
    }
  }

  /// Check and celebrate water goal achievement with dynamic goal support
  static Future<void> checkWaterGoalAchievement(
      int currentIntakeMl, int goalLiters) async {
    try {
      final int goalInMl = goalLiters * 1000;
      final bool alreadyAchieved =
          await isSpecificGoalAchievedToday('water', goalInMl);

      if (currentIntakeMl >= goalInMl && !alreadyAchieved) {
        await markSpecificGoalAchieved('water', goalInMl);
        await NotificationController.showGoalAchievement(
          goalType: 'water',
          achievement: 'You hit your daily water goal of ${goalLiters}L!',
        );
      }
    } catch (e) {
      AppLogger.error(
          'Error checking water goal achievement: $e', StackTrace.current);
    }
  }

  /// Get the appropriate key for a goal type
  static String _getGoalKey(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'steps':
        return _stepGoalKey;
      case 'water':
        return _waterGoalKey;
      default:
        return '${goalType}_goal_achieved_today';
    }
  }

  /// Get the appropriate key for last achieved goal value
  static String _getLastAchievedGoalKey(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'steps':
        return _stepLastAchievedGoalKey;
      case 'water':
        return _waterLastAchievedGoalKey;
      default:
        return '${goalType}_last_achieved_goal';
    }
  }

  /// Get all goal achievement statuses for today
  static Future<Map<String, bool>> getAllGoalStatuses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'steps': prefs.getBool(_stepGoalKey) ?? false,
        'water': prefs.getBool(_waterGoalKey) ?? false,
      };
    } catch (e) {
      AppLogger.error('Error getting goal statuses: $e', StackTrace.current);
      return {
        'steps': false,
        'water': false,
      };
    }
  }

  /// Get current goal achievement status for debugging
  static Future<Map<String, dynamic>> getGoalAchievementStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'steps': {
          'achieved_today': prefs.getBool(_stepGoalKey) ?? false,
          'last_achieved_goal': prefs.getInt(_stepLastAchievedGoalKey) ?? 0,
          'reset_date': prefs.getString(_stepResetDateKey),
        },
        'water': {
          'achieved_today': prefs.getBool(_waterGoalKey) ?? false,
          'last_achieved_goal': prefs.getInt(_waterLastAchievedGoalKey) ?? 0,
          'reset_date': prefs.getString(_waterResetDateKey),
        },
      };
    } catch (e) {
      AppLogger.error(
          'Error getting goal achievement status: $e', StackTrace.current);
      return {};
    }
  }

  /// Reset all goal flags (useful for testing or manual reset)
  static Future<void> resetAllGoalFlags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_stepGoalKey, false);
      await prefs.setBool(_waterGoalKey, false);
      await prefs.setInt(_stepLastAchievedGoalKey, 0);
      await prefs.setInt(_waterLastAchievedGoalKey, 0);
      await prefs.remove(_stepResetDateKey);
      await prefs.remove(_waterResetDateKey);
    } catch (e) {
      AppLogger.error('Error resetting all goal flags: $e', StackTrace.current);
    }
  }
}
