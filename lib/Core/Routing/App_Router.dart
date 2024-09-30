import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/Login/UI/login_screen.dart';
import 'package:fitpro/Features/Signup/UI/signup_screen.dart';
import 'package:fitpro/Features/TrackSteps/Ui/TrackStepsScreen.dart';
import 'package:fitpro/Features/Welcome/UI/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../../Features/UserInfo/UI/user_age_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
        case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        case Routes.signupScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.trackStepsScreen:
        return MaterialPageRoute(builder: (_) => const TrackstepsScreen());
      case Routes.userAgeScreen:
        return MaterialPageRoute(builder: (_) =>  UserAgeScreen());  
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
