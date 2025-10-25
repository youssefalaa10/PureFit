import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef NavigateFunction = void Function(String routeName);

class NotificationController {
  static GlobalKey<NavigatorState>? navigatorKey; // Nullable navigator key

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Extract the screen from the payload
    final String? screen = receivedAction.payload?['screen'];
    final String? type = receivedAction.payload?['type'];

    AppLogger.info('Received screen: $screen, type: $type');

    if (screen != null && navigatorKey != null) {
      // Use navigatorKey to navigate
      navigatorKey!.currentState?.pushNamedAndRemoveUntil(
        screen,
        (route) => (route.settings.name != screen) || route.isFirst,
        arguments: receivedAction,
      );
    } else {
      AppLogger.error('Navigation failed: screen or navigatorKey is null',
          StackTrace.current);
    }
  }

  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  // Initialize enhanced notifications
  static Future<void> initializeEnhancedNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
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
        // Step Reminder Channel
        NotificationChannel(
          channelKey: 'step_reminder',
          channelName: 'Step Reminders',
          channelDescription: 'Reminders to take steps and stay active',
          defaultColor: const Color(0xFF00BCD4),
          ledColor: Colors.cyan,
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
        // Sleep Schedule Channel (single definition)
        // Basic Channel (for backward compatibility)
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'General notifications',
          defaultColor: const Color(0xFF00BCD4),
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
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
      'workout_time',
      '${workoutTime.hour}:${workoutTime.minute}',
    );
    await prefs.setStringList(
      'workout_days',
      daysOfWeek.map((e) => e.toString()).toList(),
    );

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
      'water_start_time',
      '${startTime.hour}:${startTime.minute}',
    );
    await prefs.setString(
      'water_end_time',
      '${endTime.hour}:${endTime.minute}',
    );

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
      'wake_up_time',
      '${wakeUpTime.hour}:${wakeUpTime.minute}',
    );
    await prefs.setInt('wind_down_minutes', windDownMinutes);

    // Cancel existing sleep reminders
    await AwesomeNotifications().cancel(3000);

    // Wind-down reminder
    DateTime windDownTime = DateTime.now()
        .copyWith(hour: bedtime.hour, minute: bedtime.minute, second: 0)
        .subtract(Duration(minutes: windDownMinutes));

    // If time has passed, schedule for next day
    if (windDownTime.isBefore(DateTime.now())) {
      windDownTime = windDownTime.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3001,
        channelKey: 'sleep_schedule',
        title: '🌙 Wind Down Time',
        body: 'Start preparing for bed. Dim the lights and relax.',
        payload: {'screen': '/sleep', 'type': 'wind_down'},
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(
        date: windDownTime,
        allowWhileIdle: true,
      ),
    );

    // Bedtime reminder
    DateTime bedtimeDateTime = DateTime.now().copyWith(
      hour: bedtime.hour,
      minute: bedtime.minute,
      second: 0,
    );

    // If time has passed, schedule for next day
    if (bedtimeDateTime.isBefore(DateTime.now())) {
      bedtimeDateTime = bedtimeDateTime.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3002,
        channelKey: 'sleep_schedule',
        title: '😴 Bedtime',
        body: 'Time to go to bed for a good night\'s rest!',
        payload: {'screen': '/sleep', 'type': 'bedtime'},
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(
        date: bedtimeDateTime,
        allowWhileIdle: true,
      ),
    );

    // Wake-up alarm (most important one)
    DateTime wakeUpDateTime = DateTime.now().copyWith(
      hour: wakeUpTime.hour,
      minute: wakeUpTime.minute,
      second: 0,
    );

    // If time has passed, schedule for next day
    if (wakeUpDateTime.isBefore(DateTime.now())) {
      wakeUpDateTime = wakeUpDateTime.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3003,
        channelKey: 'sleep_schedule',
        title: '☀️ Good Morning!',
        body: 'Rise and shine! Start your day with energy and positivity.',
        payload: {'screen': '/dashboard', 'type': 'wake_up'},
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Alarm,
        criticalAlert: true,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar.fromDate(
        date: wakeUpDateTime,
        allowWhileIdle: true,
      ),
    );
  }

  /// Cancel all sleep-related notifications
  static Future<void> cancelSleepReminders() async {
    await AwesomeNotifications().cancel(3001); // Wind-down reminder
    await AwesomeNotifications().cancel(3002); // Bedtime reminder
    await AwesomeNotifications().cancel(3003); // Wake-up alarm

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sleep_schedule_enabled', false);
  }

  // Goal Achievement Celebrations
  static Future<void> showGoalAchievement({
    required String goalType,
    required String achievement,
    String? celebrationMessage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final bool celebrationsEnabled =
        prefs.getBool('goal_celebration_enabled') ?? true;

    // Only show celebration if enabled
    if (!celebrationsEnabled) {
      AppLogger.info('Goal celebrations are disabled, skipping notification');
      return;
    }

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
          'goal': goalType,
        },
        notificationLayout: NotificationLayout.BigText,
        // icon: 'resource://drawable/ic_launcher',
        // largeIcon: 'resource://drawable/ic_launcher',
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
        // icon: 'resource://drawable/ic_launcher',
        // largeIcon: 'resource://drawable/ic_launcher',
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

  // Request all required permissions for alarms and notifications
  static Future<Map<String, bool>> requestAllPermissions() async {
    final Map<String, bool> permissions = {};

    try {
      // Request notification permission
      final notificationPermission =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      permissions['notifications'] = notificationPermission;

      // Request alarm permission (Android 12+)
      final alarmPermission = await Permission.scheduleExactAlarm.request();
      permissions['alarms'] = alarmPermission.isGranted;

      // Request activity recognition permission for step tracking
      final activityPermission = await Permission.activityRecognition.request();
      permissions['activity_recognition'] = activityPermission.isGranted;

      return permissions;
    } catch (e) {
      AppLogger.error('Error requesting permissions: $e', StackTrace.current);
      return {
        'notifications': false,
        'alarms': false,
        'activity_recognition': false,
      };
    }
  }

  // Check if all required permissions are granted
  static Future<Map<String, bool>> checkAllPermissions() async {
    final Map<String, bool> permissions = {};

    try {
      // Check notification permission
      final notificationPermission =
          await AwesomeNotifications().isNotificationAllowed();
      permissions['notifications'] = notificationPermission;

      // Check alarm permission
      final alarmPermission = await Permission.scheduleExactAlarm.status;
      permissions['alarms'] = alarmPermission.isGranted;

      // Check activity recognition permission
      final activityPermission = await Permission.activityRecognition.status;
      permissions['activity_recognition'] = activityPermission.isGranted;

      return permissions;
    } catch (e) {
      AppLogger.error('Error checking permissions: $e', StackTrace.current);
      return {
        'notifications': false,
        'alarms': false,
        'activity_recognition': false,
      };
    }
  }

  // Step Reminder Alarm
  static Future<void> scheduleStepReminder({
    required TimeOfDay reminderTime,
    required List<int> daysOfWeek,
    String? customMessage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('step_reminder_enabled', true);
    await prefs.setString(
      'step_reminder_time',
      '${reminderTime.hour}:${reminderTime.minute}',
    );
    await prefs.setStringList(
      'step_reminder_days',
      daysOfWeek.map((e) => e.toString()).toList(),
    );

    // Cancel ALL existing step reminders by ID to prevent duplicates
    for (int i = 5000; i < 5008; i++) {
      await AwesomeNotifications().cancel(i);
    }
    await AwesomeNotifications().cancelNotificationsByGroupKey(
      'step_reminders',
    );

    // Schedule new reminders for selected days only
    for (int day in daysOfWeek) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 5000 + day,
          channelKey: 'step_reminder',
          title: '👟 Time to Move!',
          body: customMessage ??
              'Get up and take some steps! Your health depends on it.',
          payload: {'screen': '/tracksteps', 'type': 'step_reminder'},
          notificationLayout: NotificationLayout.BigText,
          category:
              NotificationCategory.Reminder, // Changed from Alarm to Reminder
          wakeUpScreen: true,
          // Removed fullScreenIntent to prevent immediate display
        ),
        schedule: NotificationCalendar(
          weekday: day,
          hour: reminderTime.hour,
          minute: reminderTime.minute,
          second: 0,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  static Future<void> cancelStepReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('step_reminder_enabled', false);
    await AwesomeNotifications().cancelNotificationsByGroupKey(
      'step_reminders',
    );
    // Also cancel by ID range
    for (int i = 5000; i < 5008; i++) {
      await AwesomeNotifications().cancel(i);
    }
  }

  static Future<Map<String, dynamic>> getStepReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final bool enabled = prefs.getBool('step_reminder_enabled') ?? false;
    final String? timeString = prefs.getString('step_reminder_time');
    final List<String>? days = prefs.getStringList('step_reminder_days');

    TimeOfDay? reminderTime;
    if (timeString != null) {
      final parts = timeString.split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return {
      'enabled': enabled,
      'time': reminderTime,
      'days': days?.map((e) => int.parse(e)).toList() ?? [1, 2, 3, 4, 5, 6, 7],
    };
  }

  // Cancel today's workout reminder when workout is completed
  static Future<void> cancelTodayWorkoutReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().weekday; // 1-7 (Monday-Sunday)
    await AwesomeNotifications().cancel(1000 + today);
    await prefs.setBool('workout_completed_today', true);
    await prefs.setString(
      'workout_completed_date',
      DateTime.now().toIso8601String().split('T').first,
    );
  }

  // Check if workout was completed today
  static Future<bool> isWorkoutCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('workout_completed_today') ?? false;
    final dateStr = prefs.getString('workout_completed_date');
    final today = DateTime.now().toIso8601String().split('T').first;

    if (dateStr != today) {
      // Reset for new day
      await prefs.setBool('workout_completed_today', false);
      return false;
    }
    return completed;
  }

  // Get workout reminder settings
  static Future<Map<String, dynamic>> getWorkoutReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final bool enabled =
        prefs.getBool('daily_workout_reminder_enabled') ?? false;
    final String? timeString = prefs.getString('daily_workout_reminder_time');

    TimeOfDay reminderTime =
        const TimeOfDay(hour: 10, minute: 0); // Default 10:00 AM
    if (timeString != null) {
      final parts = timeString.split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return {
      'enabled': enabled,
      'time': reminderTime,
    };
  }

  // Schedule daily workout reminder
  static Future<void> scheduleDailyWorkoutReminder({
    required TimeOfDay reminderTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_workout_reminder_enabled', true);
    await prefs.setString(
      'daily_workout_reminder_time',
      '${reminderTime.hour}:${reminderTime.minute}',
    );

    // Cancel existing reminders
    for (int day = 1; day <= 7; day++) {
      await AwesomeNotifications().cancel(1000 + day);
    }

    // Schedule for all 7 days of the week
    for (int day = 1; day <= 7; day++) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1000 + day,
          channelKey: 'workout_reminders',
          title: '💪 Time to Workout!',
          body: 'Don\'t forget your workout today 💪',
          payload: {'screen': '/workout', 'type': 'daily_workout_reminder'},
        ),
        schedule: NotificationCalendar(
          weekday: day,
          hour: reminderTime.hour,
          minute: reminderTime.minute,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  // Cancel daily workout reminder
  static Future<void> cancelDailyWorkoutReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_workout_reminder_enabled', false);

    // Cancel all daily workout reminders
    for (int day = 1; day <= 7; day++) {
      await AwesomeNotifications().cancel(1000 + day);
    }
  }
}
