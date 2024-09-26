import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../Features/TrackSteps/Ui/track_steps_screen.dart';
import '../../Features/UserInfo/UI/user_age_screen.dart';
import '../../Features/UserInfo/UI/user_gender_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.trackStepsScreen:
        return MaterialPageRoute(builder: (_) => const TrackStepsScreen());
      case Routes.userGenderScreen:
        return MaterialPageRoute(builder: (_) => const UserGenderScreen());
      case Routes.userAgeScreen:
        return MaterialPageRoute(builder: (_) => const UserAgeScreen());
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
