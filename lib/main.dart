import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Core/Routing/app_router.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  // Platform-specific initialization
  if (!kIsWeb) {
    // Android-specific imports and initialization
    try {
      await initializeAndroidServices();
    } catch (e) {
      print('Android services initialization failed: $e');
    }
  }

  setUpGit();
  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale') ?? 'en';
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(BlocProvider(
    create: (context) => getIT<ProfileCubit>()..getProfile(),
    child: FitproApp(
      appRouter: AppRouter(),
      initialLocale: Locale(savedLocaleCode),
      isDarkMode: isDarkMode,
    ),
  ));
}
