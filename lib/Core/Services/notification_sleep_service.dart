import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Store the ID of the current repeating notification
  int? currentNotificationId;

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await AwesomeNotifications().initialize(
        'resource://drawable/file', // Replace with your actual icon resource
        [
          NotificationChannel(
            enableVibration: true,
            channelKey: 'basic_channel',
            channelName: 'PureFit Alarm',
            channelDescription: 'PureFit Alarm Channel',
            defaultColor: const Color(0xFF9D50BB),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            defaultRingtoneType: DefaultRingtoneType.Ringtone,
            playSound: true,
            soundSource: 'resource://raw/fire', // Custom sound
          ),
        ],
      );
      print('Notification channel initialized successfully.');
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
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
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
        notificationLayout: NotificationLayout.Default,
        customSound: 'resource://raw/fire',
        payload: {'screen': Routes.sleepScreen}, // Correct payload mapping
      ),
      schedule: NotificationCalendar(
        second: 30,
        repeats: true, // Repeat every 30 seconds (adjust as needed)
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> cancel() async {
    await AwesomeNotifications().cancelAll();
  }
}
