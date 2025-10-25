import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

bool _alarmManagerInitialized = false;

Future<void> initializeAndroidServices() async {
  // Initialize Android Alarm Manager
  if (!_alarmManagerInitialized) {
    await AndroidAlarmManager.initialize();
    _alarmManagerInitialized = true;
  }

  // Initialize notifications
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  );
}
