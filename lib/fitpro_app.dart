import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Services/notificationcontroler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Core/Routing/Routes.dart';
import 'Core/Shared/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class FitproApp extends StatelessWidget {
  final AppRouter appRouter;
   final Locale initialLocale;
  const FitproApp({super.key, required this.appRouter, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    // Create a GlobalKey for NavigatorState
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // Set the navigator key in NotificationController
    NotificationController.setNavigatorKey(navigatorKey);

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Change status bar color,
            statusBarBrightness:
                Brightness.light, // Change status bar brightness
            statusBarIconBrightness:
                Brightness.dark, // Change status bar icon brightness
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigator key for the MaterialApp
      // initialRoute: Routes.weeklyExerciseScreen,
      initialRoute: Routes.checkToken,
      onGenerateRoute: appRouter.generateRoute,

      // Add these lines for localization
      locale: initialLocale,
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
