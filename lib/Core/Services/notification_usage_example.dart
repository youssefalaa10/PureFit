// Example usage of enhanced notifications
// This file shows how to use the enhanced notification features

import 'package:flutter/material.dart';

import 'notificationcontroler.dart';

class NotificationUsageExample {
  // Example: Schedule workout reminders
  static Future<void> setupWorkoutReminders() async {
    await NotificationController.scheduleWorkoutReminder(
      workoutTime: const TimeOfDay(hour: 18, minute: 0), // 6:00 PM
      daysOfWeek: [1, 3, 5], // Monday, Wednesday, Friday
      customMessage: 'Time to crush your workout! 💪',
    );
  }

  // Example: Schedule water intake reminders
  static Future<void> setupWaterReminders() async {
    await NotificationController.scheduleWaterIntakeReminders(
      intervalHours: 2, // Every 2 hours
      startTime: const TimeOfDay(hour: 8, minute: 0), // 8:00 AM
      endTime: const TimeOfDay(hour: 22, minute: 0), // 10:00 PM
    );
  }

  // Example: Schedule sleep reminders
  static Future<void> setupSleepReminders() async {
    await NotificationController.scheduleSleepReminders(
      bedtime: const TimeOfDay(hour: 22, minute: 30), // 10:30 PM
      wakeUpTime: const TimeOfDay(hour: 7, minute: 0), // 7:00 AM
      windDownMinutes: 30, // 30 minutes before bedtime
    );
  }

  // Example: Show goal achievement
  static Future<void> celebrateGoalAchievement() async {
    await NotificationController.showGoalAchievement(
      goalType: 'weight_loss',
      achievement: 'Lost 10 pounds!',
      celebrationMessage: 'Amazing progress! Keep it up!',
    );
  }

  // Example: Show quick celebration
  static Future<void> celebrateWorkoutCompletion() async {
    await NotificationController.showQuickCelebration(
      'Great job completing your workout! 🎉',
    );
  }

  // Example: Toggle notifications
  static Future<void> toggleNotifications() async {
    // Enable workout reminders
    await NotificationController.toggleWorkoutReminders(true);

    // Disable water reminders
    await NotificationController.toggleWaterIntakeReminders(false);

    // Enable sleep reminders
    await NotificationController.toggleSleepScheduleReminders(true);

    // Enable goal celebrations
    await NotificationController.toggleGoalCelebrations(true);
  }

  // Example: Get notification preferences
  static Future<void> checkNotificationSettings() async {
    final preferences =
        await NotificationController.getNotificationPreferences();

    print('Workout reminders: ${preferences['workout_reminders']}');
    print('Water intake: ${preferences['water_intake']}');
    print('Sleep schedule: ${preferences['sleep_schedule']}');
    print('Goal celebrations: ${preferences['goal_celebration']}');
  }
}
