import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Core/Routing/app_router.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:PureFit/fitpro_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  );
  setUpGit();
  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale') ?? 'en';
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(BlocProvider(
    create: (context) => getIT<ProfileCubit>(),
    child: FitproApp(
      appRouter: AppRouter(),
      initialLocale: Locale(savedLocaleCode),
      isDarkMode: isDarkMode,
    ),
  ));
}
