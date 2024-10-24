import 'package:flutter/material.dart';
import 'package:PureFit/Core/Routing/app_router.dart';
import 'package:PureFit/Core/Services/notificationcontroler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PureFit/Core/Shared/theme/theme_color.dart';
import 'Core/Routing/routes.dart';
import 'Core/Shared/localization/app_localizations.dart';

class FitproApp extends StatefulWidget {
  final AppRouter appRouter;
  final Locale initialLocale;
  final bool isDarkMode;

  const FitproApp({
    super.key,
    required this.appRouter,
    required this.initialLocale,
    required this.isDarkMode,
  });

  // Method to toggle the theme externally
  static void toggleTheme(BuildContext context, bool isDarkMode) {
    final _FitproAppState? state =
        context.findAncestorStateOfType<_FitproAppState>();
    state?.toggleTheme(isDarkMode);
  }

  // Method to set the locale externally
  static void setLocale(BuildContext context, Locale newLocale) {
    final _FitproAppState? state =
        context.findAncestorStateOfType<_FitproAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _FitproAppState createState() => _FitproAppState();
}

class _FitproAppState extends State<FitproApp> {
  late Locale _locale;
  late bool _isDarkMode;

  // Create a GlobalKey for NavigatorState
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _isDarkMode = widget.isDarkMode;

    // Set the navigator key in NotificationController
    NotificationController.setNavigatorKey(navigatorKey);
  }

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
