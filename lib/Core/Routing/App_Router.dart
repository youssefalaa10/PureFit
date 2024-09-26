import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/TrackSteps/Ui/TrackStepsScreen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.trackStepsScreen:
        return MaterialPageRoute(builder: (_) => const TrackstepsScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("No Routes defined"),
                  ),
                ));
    }
  }
}
