import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Services/notificationcontroler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Core/Routing/Routes.dart';

class FitproApp extends StatelessWidget {
  final AppRouter appRouter;

  const FitproApp({super.key, required this.appRouter});

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
            statusBarColor: Colors.white, // Change status bar color,
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
    );
  }
}
