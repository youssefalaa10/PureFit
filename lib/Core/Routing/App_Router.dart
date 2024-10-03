import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Features/AuthHelper/cubit/tokencheck_cubit.dart';
import 'package:fitpro/Features/AuthHelper/token_check.dart';
import 'package:fitpro/Features/Calories/Ui/calories_screen.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/LoginScreen/Logic/cubit/login_cubit.dart';
import 'package:fitpro/Features/LoginScreen/Ui/login_screen.dart';
import 'package:fitpro/Features/MyPlan/myplan_screen.dart';
import 'package:fitpro/Features/Layout/layout_screen.dart';
import 'package:fitpro/Features/Profile/UI/edit_profile_screen.dart';
import 'package:fitpro/Features/Signup/Ui/signup_screen.dart';
import 'package:fitpro/Features/Sleep/sleep_screan.dart';
import 'package:fitpro/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:fitpro/Features/Water/water_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Features/Exercises/UI/exercise_screen.dart';
import '../../Features/Exercises/UI/weekly_exercise_screen.dart';
import '../../Features/Profile/Logic/cubit/profile_cubit.dart';
import '../../Features/Profile/UI/profile_screen.dart';
import '../../Features/Signup/Logic/cubit/signup_cubit.dart';
import '../../Features/TrackSteps/Ui/track_steps_screen.dart';
import '../../Features/UserInfo/UI/body_metrics.dart';
import '../../Features/UserInfo/UI/user_age_screen.dart';
import '../../Features/UserInfo/UI/user_gender_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.trackStepsScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<TrackStepCubit>(),
                  child: const TrackStepsScreen(),
                ));

      case Routes.userGenderScreen:
        return MaterialPageRoute(builder: (_) => const UserGenderScreen());

      case Routes.userAgeScreen:
        return MaterialPageRoute(builder: (_) => const UserAgeScreen());
      case Routes.bodyMetricsScreen:
        return MaterialPageRoute(builder: (_) => const BodyMetricsScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<ProfileCubit>(),
                  child: const ProfileScreen(),
                ));
      case Routes.editProfileScreen:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case Routes.layoutScreen:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());

      case Routes.myPlanScreen:
        return MaterialPageRoute(builder: (_) => const MyPlanScreen());
      case Routes.caloriesScreen:
        return MaterialPageRoute(builder: (_) => const CaloriesScreen());

      case Routes.waterScreen:
        return MaterialPageRoute(builder: (_) => const WaterScreen());

      case Routes.sleepScreen:
        return MaterialPageRoute(builder: (_) => const SleepScrean());
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIT<SignupCubit>(),
            child: const SignupScreen(),
          ),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<LoginCubit>(),
                  child: const LoginScreen(),
                ));
      case Routes.exerciseScreen:
        return MaterialPageRoute(builder: (_) => const ExerciseScreen());
      case Routes.weeklyExerciseScreen:
        return MaterialPageRoute(builder: (_) => const WeeklyExerciseScreen());

      case Routes.checkToken:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => TokencheckCubit(),
                  child: const TokenCheck(),
                ));

      default:
        return null;
    }
  }
}
