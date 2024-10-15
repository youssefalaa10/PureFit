import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Services/notificationcontroler.dart';
import 'package:flutter/material.dart';

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
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigator key for the MaterialApp
      initialRoute: Routes.checkToken,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
