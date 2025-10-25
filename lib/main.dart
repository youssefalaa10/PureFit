import 'dart:developer' as developer;

import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Core/Routing/app_router.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:PureFit/fitpro_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for Android-specific packages
import 'android_services.dart' if (dart.library.html) 'web_services.dart';

void main() async {
  // Performance monitoring - track total startup time
  developer.Timeline.startSync('app_startup');

  WidgetsFlutterBinding.ensureInitialized();

  // Platform-specific initialization
  if (!kIsWeb) {
    developer.Timeline.startSync('android_services_init');
    try {
      await initializeAndroidServices();
    } catch (e) {
      AppLogger.log('Android services initialization failed: $e');
    }
    developer.Timeline.finishSync();
  }

  developer.Timeline.startSync('dependency_injection');
  setUpGit();
  developer.Timeline.finishSync();

  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  developer.Timeline.startSync('preferences_loading');
  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale') ?? 'en';
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  developer.Timeline.finishSync();

  developer.Timeline.startSync('app_launch');
  runApp(BlocProvider(
    create: (context) => getIT<ProfileCubit>()..getProfile(),
    child: FitproApp(
      appRouter: AppRouter(),
      initialLocale: Locale(savedLocaleCode),
      isDarkMode: isDarkMode,
    ),
  ));
  developer.Timeline.finishSync();
  developer.Timeline.finishSync(); // Finish total startup tracking
}
