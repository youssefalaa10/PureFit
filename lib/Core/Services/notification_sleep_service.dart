import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../Routing/Routes.dart';
import 'notificationcontroler.dart';

class NotificationService {
  NotificationService() {
    _initializeNotifications();
  }
  // Store the ID of the current repeating notification
  int? currentNotificationId;

  Future<void> _initializeNotifications() async {
    try {
      // Use the enhanced notification controller
      await NotificationController.initializeEnhancedNotifications();
      print('Enhanced notification channels initialized successfully.');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  // Method to show a notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? routeName, // Added optional route name parameter
  }) async {
    try {
      // Generate a unique notification ID
      final int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          customSound: 'resource://raw/fire', // Optional: custom sound
          payload: routeName != null
              ? {'screen': routeName}
              : null, // Include route in payload
        ),
      );

      print('Notification shown: $title - $body');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime
        scheduledTime, // Time when the notification should be triggered
    String? routeName,
  }) async {
    try {
      // Generate a unique notification ID
      final int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          customSound: 'resource://raw/fire',
          payload: routeName != null ? {'screen': routeName} : null,
        ),
        schedule: NotificationCalendar.fromDate(
            date: scheduledTime), // Schedule the notification
      );

      print('Scheduled notification: $title - $body at $scheduledTime');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Method to create or update a repeating notification
  Future<void> repeatAlarm(String title, String body) async {
    currentNotificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: currentNotificationId!,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        customSound: 'resource://raw/fire',
        payload: {'screen': Routes.sleepScreen}, // Correct payload mapping
      ),
      schedule: NotificationCalendar(
        second: 30,
        repeats: true, // Repeat every 30 seconds (adjust as needed)
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> cancel() async {
    await AwesomeNotifications().cancelAll();
  }

  // Enhanced notification methods using the controller
  Future<void> scheduleWorkoutReminder({
    required TimeOfDay workoutTime,
    required List<int> daysOfWeek,
    String? customMessage,
  }) async {
    await NotificationController.scheduleWorkoutReminder(
      workoutTime: workoutTime,
      daysOfWeek: daysOfWeek,
      customMessage: customMessage,
    );
  }

  Future<void> scheduleWaterIntakeReminders({
    required int intervalHours,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    await NotificationController.scheduleWaterIntakeReminders(
      intervalHours: intervalHours,
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<void> scheduleSleepReminders({
    required TimeOfDay bedtime,
    required TimeOfDay wakeUpTime,
    required int windDownMinutes,
  }) async {
    await NotificationController.scheduleSleepReminders(
      bedtime: bedtime,
      wakeUpTime: wakeUpTime,
      windDownMinutes: windDownMinutes,
    );
  }

  Future<void> showGoalAchievement({
    required String goalType,
    required String achievement,
    String? celebrationMessage,
  }) async {
    await NotificationController.showGoalAchievement(
      goalType: goalType,
      achievement: achievement,
      celebrationMessage: celebrationMessage,
    );
  }

  Future<void> showQuickCelebration(String message) async {
    await NotificationController.showQuickCelebration(message);
  }

  // Toggle methods
  Future<void> toggleWorkoutReminders(bool enabled) async {
    await NotificationController.toggleWorkoutReminders(enabled);
  }

  Future<void> toggleWaterIntakeReminders(bool enabled) async {
    await NotificationController.toggleWaterIntakeReminders(enabled);
  }

  Future<void> toggleSleepScheduleReminders(bool enabled) async {
    await NotificationController.toggleSleepScheduleReminders(enabled);
  }

  Future<void> toggleGoalCelebrations(bool enabled) async {
    await NotificationController.toggleGoalCelebrations(enabled);
  }

  // Get preferences
  Future<Map<String, bool>> getNotificationPreferences() async {
    return await NotificationController.getNotificationPreferences();
  }
}
