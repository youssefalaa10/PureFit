import 'dart:async';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/TrakStepDb/track_steps_db.dart';
import 'package:PureFit/Core/Services/goal_tracking_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:pedometer/pedometer.dart';
import 'package:PureFit/Core/Services/permission_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BackgroundStepService {
  static const int _stepSyncAlarmId = 1001;
  static const MethodChannel _channel = MethodChannel('step_tracking_channel');

  static StreamSubscription<StepCount>? _stepCountSubscription;
  static TrackStepsDB? _trackStepsDB;
  static int _lastKnownSteps = 0;
  static bool _isServiceRunning = false;
  static int _currentGoal = 10000;

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
      final hasPermission =
          await PermissionManager.isPermissionGranted('activity_recognition');
      if (!hasPermission) {
        AppLogger.log('Activity recognition permission not granted');
        return;
      }

      // Reset goal flags for new day
      await GoalTrackingService.resetGoalFlagsForNewDay();

      // Start Android foreground service (this is the key!)
      await _startAndroidService();

      // Start Flutter step tracking as backup
      await _startStepTracking();

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
      _currentGoal = prefs.getInt('stepGoal') ?? 10000;

      // Sync goal with Android service
      await _channel.invokeMethod('updateGoal', _currentGoal);

      AppLogger.log('Current step goal loaded: $_currentGoal');
    } catch (e) {
      AppLogger.log('Error loading current goal: $e');
    }
  }

  /// Start step tracking
  static Future<void> _startStepTracking() async {
    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
        cancelOnError: false,
      );

      AppLogger.log('Step tracking started');
    } catch (e) {
      AppLogger.log('Error starting step tracking: $e');
    }
  }

  /// Handle step count updates
  static Future<void> _onStepCount(StepCount event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final initialSteps = prefs.getInt('initialSteps') ?? event.steps;
      final todayDate = DateTime.now().toIso8601String().split('T').first;

      // Handle first launch
      if (prefs.getBool('isFirstLaunch') ?? true) {
        await prefs.setInt('initialSteps', event.steps);
        await prefs.setInt('savedSteps', 0);
        await prefs.setBool('isFirstLaunch', false);
        _lastKnownSteps = 0;
        return;
      }

      // Calculate today's steps
      int todaySteps = event.steps - initialSteps;
      todaySteps = todaySteps < 0 ? 0 : todaySteps;

      _lastKnownSteps = todaySteps;

      // Save to database
      await _trackStepsDB?.upsertTrack(todaySteps, todayDate);
      await prefs.setInt('savedSteps', todaySteps);
    } catch (e) {
      AppLogger.log('Error processing step count: $e');
    }
  }

  /// Handle step count errors
  static void _onStepCountError(Object error) {
    AppLogger.log('Step count error: $error');

    // Restart after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _startStepTracking();
    });
  }

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
      await _stepCountSubscription?.cancel();
      await AndroidAlarmManager.cancel(_stepSyncAlarmId);

      _isServiceRunning = false;
      AppLogger.log('Background Step Service stopped');
    } catch (e) {
      AppLogger.log('Error stopping Background Step Service: $e');
    }
  }

  /// Check if service is running
  static bool get isRunning => _isServiceRunning;

  /// Get current step count
  static int get currentSteps => _lastKnownSteps;

  /// Get current goal
  static int get currentGoal => _currentGoal;

  /// Get steps from Android service
  static Future<int> getStepsFromAndroidService() async {
    try {
      final steps = await _channel.invokeMethod<int>('getCurrentSteps');
      return steps ?? _lastKnownSteps;
    } catch (e) {
      AppLogger.log('Error getting steps from Android service: $e');
      return _lastKnownSteps;
    }
  }

  /// Update goal in both Flutter and Android service
  static Future<void> updateGoal(int newGoal) async {
    try {
      _currentGoal = newGoal;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stepGoal', newGoal);

      // Update Android service
      await _channel.invokeMethod('updateGoal', newGoal);

      AppLogger.log('Step goal updated to: $newGoal');
    } catch (e) {
      AppLogger.log('Error updating goal: $e');
    }
  }
}
