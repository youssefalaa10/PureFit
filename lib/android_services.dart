import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> initializeAndroidServices() async {
  // Initialize Android Alarm Manager
  await AndroidAlarmManager.initialize();

  // Initialize notifications
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  );
}
