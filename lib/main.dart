import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Services/notificationcontroler.dart';
import 'package:fitpro/fitpro_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  );
  setUpGit();
  runApp(FitproApp(appRouter: AppRouter()));
}
