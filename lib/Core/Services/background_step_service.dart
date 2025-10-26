import 'dart:async';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/TrakStepDb/track_steps_db.dart';
import 'package:PureFit/Core/Services/goal_tracking_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:PureFit/Core/Services/permission_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundStepService {
  static const int _stepSyncAlarmId = 1001;
  static const MethodChannel _channel = MethodChannel('step_tracking_channel');

  // Removed _stepCountSubscription - Android service now handles tracking
  static TrackStepsDB? _trackStepsDB;
  static bool _isServiceRunning = false;
  static int _currentGoal = 1000;

  /// Initialize background step tracking service
  static Future<void> initialize() async {
    try {
      AppLogger.log('Initializing Background Step Service');

      // Initialize database
      _trackStepsDB = TrackStepsDB();
      await _trackStepsDB!.initDb();

      // Load current goal
      await _loadCurrentGoal();

      // Check permissions using centralized manager
      final hasPermission = await PermissionManager.requestPermission(
        permissionName: 'activity_recognition',
        permission: Permission.activityRecognition,
        rationale:
            'Enable step tracking to monitor your daily activity and reach your fitness goals',
      );

      if (!hasPermission) {
        AppLogger.log(
            'Activity recognition permission not granted - cannot start service');
        return;
      }

      AppLogger.log(
          'Activity recognition permission granted - starting service');

      // Reset goal flags for new day
      await GoalTrackingService.resetGoalFlagsForNewDay();

      // Start Android foreground service (this is the key!)
      await _startAndroidService();

      // NOTE: We don't start Flutter pedometer tracking anymore
      // The Android service is the single source of truth for steps
      // This prevents dual tracking and ensures consistency

      // Schedule periodic sync
      await _scheduleStepSync();

      _isServiceRunning = true;
      AppLogger.log('Background Step Service initialized successfully');
    } catch (e) {
      AppLogger.log('Error initializing Background Step Service: $e');
    }
  }

  /// Start Android foreground service
  static Future<void> _startAndroidService() async {
    try {
      await _channel.invokeMethod('startForegroundService');
      AppLogger.log('Android foreground service started');
    } catch (e) {
      AppLogger.log('Error starting Android service: $e');
    }
  }

  /// Load current goal from preferences
  static Future<void> _loadCurrentGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentGoal =
          prefs.getInt('stepGoal') ?? 1000; // Default goal is 1000, not 10000

      // Sync goal with Android service
      await _channel.invokeMethod('updateGoal', _currentGoal);

      AppLogger.log('Current step goal loaded: $_currentGoal');
    } catch (e) {
      AppLogger.log('Error loading current goal: $e');
    }
  }

  // NOTE: Flutter pedometer tracking removed to prevent dual tracking
  // Android service is now the single source of truth for steps
  // These methods are kept for reference but not called

  /// Schedule periodic step sync
  static Future<void> _scheduleStepSync() async {
    try {
      await AndroidAlarmManager.periodic(
        const Duration(minutes: 15),
        _stepSyncAlarmId,
        _syncStepsInBackground,
        rescheduleOnReboot: true,
      );

      AppLogger.log('Step sync scheduled');
    } catch (e) {
      AppLogger.log('Error scheduling step sync: $e');
    }
  }

  /// Sync steps in background (called by alarm)
  @pragma('vm:entry-point')
  static Future<void> _syncStepsInBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSteps = prefs.getInt('savedSteps') ?? 0;
      final todayDate = DateTime.now().toIso8601String().split('T').first;

      // Save to database
      if (_trackStepsDB != null) {
        await _trackStepsDB!.upsertTrack(savedSteps, todayDate);
      }
    } catch (e) {
      AppLogger.log('Error syncing steps in background: $e');
    }
  }

  /// Stop background service
  static Future<void> stop() async {
    try {
      // Cancel alarm sync
      await AndroidAlarmManager.cancel(_stepSyncAlarmId);

      _isServiceRunning = false;
      AppLogger.log('Background Step Service stopped');
    } catch (e) {
      AppLogger.log('Error stopping Background Step Service: $e');
    }
  }

  /// Check if service is running
  static bool get isRunning => _isServiceRunning;

  /// Get current goal
  static int get currentGoal => _currentGoal;

  /// Get steps from Android service
  static Future<int> getStepsFromAndroidService() async {
    try {
      final steps = await _channel.invokeMethod<int>('getCurrentSteps');
      AppLogger.log('Fetched steps from Android service: $steps');
      return steps ?? 0;
    } catch (e) {
      AppLogger.log('Error getting steps from Android service: $e');
      // If Android service fails, return 0 as fallback
      return 0;
    }
  }

  /// Update goal in both Flutter and Android service
  static Future<void> updateGoal(int newGoal) async {
    try {
      _currentGoal = newGoal;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stepGoal', newGoal);

      // Update Android service (this will trigger service restart to reload goal)
      await _channel.invokeMethod('updateGoal', newGoal);

      // Force Android service to reload goal by restarting it
      await _restartAndroidService();

      AppLogger.log('Step goal updated to: $newGoal and service restarted');
    } catch (e) {
      AppLogger.log('Error updating goal: $e');
    }
  }

  /// Restart Android service to reload configuration
  static Future<void> _restartAndroidService() async {
    try {
      await _channel.invokeMethod('stopForegroundService');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await _channel.invokeMethod('startForegroundService');
      AppLogger.log('Android service restarted to reload configuration');
    } catch (e) {
      AppLogger.log('Error restarting Android service: $e');
    }
  }
}
