import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef NavigateFunction = void Function(String routeName);

class NotificationController {
  static GlobalKey<NavigatorState>? navigatorKey; // Nullable navigator key

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Extract the screen from the payload
    final String? screen = receivedAction.payload?['screen'];
    final String? type = receivedAction.payload?['type'];

    print('Received screen: $screen, type: $type');

    if (screen != null && navigatorKey != null) {
      // Use navigatorKey to navigate
      navigatorKey!.currentState?.pushNamedAndRemoveUntil(
        screen,
        (route) => (route.settings.name != screen) || route.isFirst,
        arguments: receivedAction,
      );
    } else {
      print('Navigation failed: screen or navigatorKey is null');
    }
  }

  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  // Initialize enhanced notifications
  static Future<void> initializeEnhancedNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        // Workout Reminders Channel
        NotificationChannel(
          channelKey: 'workout_reminders',
          channelName: 'Workout Reminders',
          channelDescription:
              'Notifications for workout reminders and motivation',
          defaultColor: const Color(0xFF4CAF50),
          ledColor: Colors.green,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          playSound: true,
          enableVibration: true,
        ),
        // Water Intake Channel
        NotificationChannel(
          channelKey: 'water_intake',
          channelName: 'Water Intake Alerts',
          channelDescription: 'Reminders to stay hydrated throughout the day',
          defaultColor: const Color(0xFF2196F3),
          ledColor: Colors.blue,
          importance: NotificationImportance.Default,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          playSound: true,
          enableVibration: true,
        ),
        // Sleep Schedule Channel
        NotificationChannel(
          channelKey: 'sleep_schedule',
          channelName: 'Sleep Schedule',
          channelDescription: 'Bedtime and wake-up reminders for better sleep',
          defaultColor: const Color(0xFF9C27B0),
          ledColor: Colors.purple,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          playSound: true,
          enableVibration: true,
        ),
        // Goal Achievement Channel
        NotificationChannel(
          channelKey: 'goal_celebration',
          channelName: 'Goal Achievements',
          channelDescription: 'Celebrations for reaching fitness milestones',
          defaultColor: const Color(0xFFFF9800),
          ledColor: Colors.orange,
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );
  }

  // Workout Reminders
  static Future<void> scheduleWorkoutReminder({
    required TimeOfDay workoutTime,
    required List<int> daysOfWeek,
    String? customMessage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('workout_reminder_enabled', true);
    await prefs.setString(
        'workout_time', '${workoutTime.hour}:${workoutTime.minute}');
    await prefs.setStringList(
        'workout_days', daysOfWeek.map((e) => e.toString()).toList());

    // Cancel existing workout reminders
    await AwesomeNotifications().cancel(1000);

    for (int day in daysOfWeek) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1000 + day,
          channelKey: 'workout_reminders',
          title: '💪 Time to Workout!',
          body: customMessage ??
              'Your scheduled workout time is here. Let\'s get moving!',
          payload: {'screen': '/workout', 'type': 'workout_reminder'},
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar(
          weekday: day,
          hour: workoutTime.hour,
          minute: workoutTime.minute,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  // Water Intake Alerts
  static Future<void> scheduleWaterIntakeReminders({
    required int intervalHours,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('water_intake_enabled', true);
    await prefs.setInt('water_interval', intervalHours);
    await prefs.setString(
        'water_start_time', '${startTime.hour}:${startTime.minute}');
    await prefs.setString(
        'water_end_time', '${endTime.hour}:${endTime.minute}');

    // Cancel existing water reminders
    await AwesomeNotifications().cancel(2000);

    final waterMessages = [
      '💧 Time to hydrate! Your body needs water.',
      '🚰 Don\'t forget to drink water for better health!',
      '💦 Stay hydrated and keep your energy up!',
      '🥤 Water break! Your body will thank you.',
      '💧 Hydration reminder - drink up!',
    ];

    int notificationId = 2000;
    DateTime currentTime = DateTime.now().copyWith(
      hour: startTime.hour,
      minute: startTime.minute,
      second: 0,
    );

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute <= endTime.minute)) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'water_intake',
          title: '💧 Hydration Reminder',
          body: waterMessages[notificationId % waterMessages.length],
          payload: {'screen': '/water', 'type': 'water_reminder'},
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar.fromDate(date: currentTime),
      );

      currentTime = currentTime.add(Duration(hours: intervalHours));
      notificationId++;
    }
  }

  // Sleep Schedule Notifications
  static Future<void> scheduleSleepReminders({
    required TimeOfDay bedtime,
    required TimeOfDay wakeUpTime,
    required int windDownMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sleep_schedule_enabled', true);
    await prefs.setString('bedtime', '${bedtime.hour}:${bedtime.minute}');
    await prefs.setString(
        'wake_up_time', '${wakeUpTime.hour}:${wakeUpTime.minute}');
    await prefs.setInt('wind_down_minutes', windDownMinutes);

    // Cancel existing sleep reminders
    await AwesomeNotifications().cancel(3000);

    // Wind-down reminder
    final DateTime windDownTime = DateTime.now()
        .copyWith(
          hour: bedtime.hour,
          minute: bedtime.minute,
          second: 0,
        )
        .subtract(Duration(minutes: windDownMinutes));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3001,
        channelKey: 'sleep_schedule',
        title: '🌙 Wind Down Time',
        body: 'Start preparing for bed. Dim the lights and relax.',
        payload: {'screen': '/sleep', 'type': 'wind_down'},
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar.fromDate(date: windDownTime),
    );

    // Bedtime reminder
    final DateTime bedtimeDateTime = DateTime.now().copyWith(
      hour: bedtime.hour,
      minute: bedtime.minute,
      second: 0,
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3002,
        channelKey: 'sleep_schedule',
        title: '😴 Bedtime',
        body: 'Time to go to bed for a good night\'s rest!',
        payload: {'screen': '/sleep', 'type': 'bedtime'},
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar.fromDate(date: bedtimeDateTime),
    );

    // Wake-up reminder
    final DateTime wakeUpDateTime = DateTime.now().copyWith(
      hour: wakeUpTime.hour,
      minute: wakeUpTime.minute,
      second: 0,
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3003,
        channelKey: 'sleep_schedule',
        title: '☀️ Good Morning!',
        body: 'Rise and shine! Start your day with energy and positivity.',
        payload: {'screen': '/dashboard', 'type': 'wake_up'},
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar.fromDate(date: wakeUpDateTime),
    );
  }

  // Goal Achievement Celebrations
  static Future<void> showGoalAchievement({
    required String goalType,
    required String achievement,
    String? celebrationMessage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('goal_celebration_enabled', true);

    final celebrationMessages = {
      'weight_loss':
          '🎉 Congratulations! You\'ve reached your weight loss goal!',
      'muscle_gain': '💪 Amazing! You\'ve built the muscle you wanted!',
      'endurance':
          '🏃‍♂️ Fantastic! Your endurance has improved significantly!',
      'strength': '💪 Incredible! You\'ve gained impressive strength!',
      'flexibility': '🤸‍♀️ Wonderful! You\'ve improved your flexibility!',
      'steps': '👟 Awesome! You\'ve hit your daily step goal!',
      'water': '💧 Great job! You\'ve met your hydration target!',
      'workout_streak': '🔥 Amazing streak! Keep up the consistency!',
    };

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4000 + DateTime.now().millisecondsSinceEpoch.remainder(1000),
        channelKey: 'goal_celebration',
        title: '🏆 Goal Achieved!',
        body: celebrationMessages[goalType] ??
            celebrationMessage ??
            'Congratulations on your achievement!',
        payload: {
          'screen': '/achievements',
          'type': 'goal_achievement',
          'goal': goalType
        },
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  // Quick celebration for immediate achievements
  static Future<void> showQuickCelebration(String message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4000 + DateTime.now().millisecondsSinceEpoch.remainder(1000),
        channelKey: 'goal_celebration',
        title: '🎉 Great Job!',
        body: message,
        payload: {'type': 'quick_celebration'},
      ),
    );
  }

  // Toggle notification types
  static Future<void> toggleWorkoutReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('workout_reminder_enabled', enabled);

    if (!enabled) {
      await AwesomeNotifications().cancel(1000);
    }
  }

  static Future<void> toggleWaterIntakeReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('water_intake_enabled', enabled);

    if (!enabled) {
      await AwesomeNotifications().cancel(2000);
    }
  }

  static Future<void> toggleSleepScheduleReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sleep_schedule_enabled', enabled);

    if (!enabled) {
      await AwesomeNotifications().cancel(3000);
    }
  }

  static Future<void> toggleGoalCelebrations(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('goal_celebration_enabled', enabled);
  }

  // Get notification preferences
  static Future<Map<String, bool>> getNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'workout_reminders': prefs.getBool('workout_reminder_enabled') ?? false,
      'water_intake': prefs.getBool('water_intake_enabled') ?? false,
      'sleep_schedule': prefs.getBool('sleep_schedule_enabled') ?? false,
      'goal_celebration': prefs.getBool('goal_celebration_enabled') ?? true,
    };
  }

  // Request notification permission
  static Future<bool> requestNotificationPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
