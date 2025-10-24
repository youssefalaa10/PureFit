import 'package:PureFit/Core/Routing/app_router.dart';
import 'package:PureFit/Core/Services/auth_service.dart';
import 'package:PureFit/Core/Services/deferred_initialization_service.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:PureFit/Core/Shared/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Core/Routing/routes.dart';
import 'Core/Shared/localization/app_localizations.dart';

class FitproApp extends StatefulWidget {
  const FitproApp({
    required this.appRouter,
    required this.initialLocale,
    required this.isDarkMode,
    super.key,
  });
  final AppRouter appRouter;
  final Locale initialLocale;
  final bool isDarkMode;

  // Method to toggle the theme externally
  static void toggleTheme(BuildContext context, bool isDarkMode) {
    final FitproAppState? state =
        context.findAncestorStateOfType<FitproAppState>();
    state?.toggleTheme(isDarkMode);
  }

  // Method to set the locale externally
  static void setLocale(BuildContext context, Locale newLocale) {
    final FitproAppState? state =
        context.findAncestorStateOfType<FitproAppState>();
    state?.setLocale(newLocale);
  }

  @override
  FitproAppState createState() => FitproAppState();
}

class FitproAppState extends State<FitproApp> {
  late Locale _locale;
  late bool _isDarkMode;

  // Use the global navigator key from AuthService
  GlobalKey<NavigatorState> get navigatorKey => AuthService.navigatorKey;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _isDarkMode = widget.isDarkMode;

    // Set the navigator key in NotificationController
    NotificationController.setNavigatorKey(navigatorKey);

    // Defer non-critical initialization to improve startup time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeferredInitializationService.initializeAfterFirstFrame(context);
    });
  }

  // Removed _initializeNotifications - now handled by DeferredInitializationService

  // Method to toggle the theme and update SharedPreferences
  void toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  // Method to change the locale and update SharedPreferences
  void setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigator key for MaterialApp
      initialRoute: Routes.checkToken,
      onGenerateRoute: widget.appRouter.generateRoute,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
