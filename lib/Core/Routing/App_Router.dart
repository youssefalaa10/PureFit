import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:fitpro/Features/AuthHelper/cubit/tokencheck_cubit.dart';
import 'package:fitpro/Features/AuthHelper/token_check.dart';
import 'package:fitpro/Features/Calories/Ui/calories_details.dart';
import 'package:fitpro/Features/Calories/Ui/calories_screen.dart';
import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:fitpro/Features/MyPlan/myplan_screen.dart';
import 'package:fitpro/Features/Layout/layout_screen.dart';
import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';
import 'package:fitpro/Features/Profile/UI/edit_profile_screen.dart';
import 'package:fitpro/Features/Sleep/set_alarm.dart';
import 'package:fitpro/Features/Sleep/sleep_screan.dart';
import 'package:fitpro/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:fitpro/Features/TrackSteps/Ui/track_step_details.dart';
import 'package:fitpro/Features/UserInfo/UI/info_pageveiw.dart';
import 'package:fitpro/Features/Water/Logic/cubit/water_intake_cubit.dart';
import 'package:fitpro/Features/Water/water_screen.dart';
import 'package:fitpro/Features/Water/water_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Features/Auth/Login/Logic/cubit/login_cubit.dart';
import '../../Features/Auth/Login/Ui/login_screen.dart';
import '../../Features/Auth/Register/Logic/cubit/register_cubit.dart';
import '../../Features/Auth/Register/Ui/register_screen.dart';
import '../../Features/Exercises/Data/Model/exercise_model.dart';
import '../../Features/Exercises/Data/Model/workout_categories_model.dart';
import '../../Features/Exercises/Logic/cubit/exercise_cubit.dart';
import '../../Features/Exercises/UI/exercise_screen.dart';
import '../../Features/Exercises/UI/get_ready_screen.dart';
import '../../Features/Exercises/UI/rest_screen.dart';
import '../../Features/Exercises/UI/training_screen.dart';
import '../../Features/Exercises/UI/weekly_exercise_screen.dart';
import '../../Features/Profile/Logic/cubit/profile_cubit.dart';
import '../../Features/Profile/UI/profile_screen.dart';
import '../../Features/Sleep/Components/timer_picker.dart';
import '../../Features/TrackSteps/Ui/track_steps_screen.dart';
import '../../Features/UserInfo/UI/body_metrics.dart';
import '../../Features/UserInfo/UI/user_age_screen.dart';
import '../../Features/UserInfo/UI/user_gender_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Home Screen ======================================================
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Track Steps Screen ===============================================
      case Routes.trackStepsScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<TrackStepCubit>(),
                  child: const TrackStepsScreen(),
                ));

      // User Gender Screen ===============================================
      case Routes.userGenderScreen:
        return MaterialPageRoute(builder: (_) => const UserGenderScreen());

      // User Age Screen =================================================
      case Routes.userAgeScreen:
        return MaterialPageRoute(builder: (_) => const UserAgeScreen());

      // Body Metrics Screen =============================================
      case Routes.bodyMetricsScreen:
        return MaterialPageRoute(builder: (_) => const BodyMetricsScreen());

      // Info Page View ==================================================
      case Routes.infoPageView:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<RegisterCubit>(),
                  child: const InfoPageView(),
                ));

      // Profile Screen ==================================================
      case Routes.profileScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<ProfileCubit>(),
                  child: const ProfileScreen(),
                ));

      // Edit Profile Screen ============================================
      case Routes.editProfileScreen:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIT<ProfileCubit>(),
            child: EditProfileScreen(userModel: user),
          ),
        );

      // Layout Screen ==================================================
      case Routes.layoutScreen:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());

      // My Plan Screen ================================================
      case Routes.myPlanScreen:
        return MaterialPageRoute(builder: (_) => const MyPlanScreen());

      // Calories Screen ==============================================
      case Routes.caloriesScreen:
        return MaterialPageRoute(builder: (_) => const CaloriesScreen());

      // Water Screen =================================================
      case Routes.waterScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<WaterIntakeCubit>(),
                  child: const WaterScreen(),
                ));

      // Sleep Screen ==================================================
      case Routes.sleepScreen:
        return MaterialPageRoute(builder: (_) => const SleepScrean());

      // Register Screen ===============================================
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIT<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );

      // Login Screen =================================================
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<LoginCubit>(),
                  child: const LoginScreen(),
                ));

      // Exercise Screen ==============================================
      case Routes.exerciseScreen:
        return MaterialPageRoute(
          builder: (context) {
            final categoryId = settings.arguments as WorkoutCategoriesModel;
            return BlocProvider(
              create: (context) {
                final cubit = getIT<ExerciseCubit>();
                // cubit.fetchExercises(categoryId.id);
                return cubit;
              },
              child: ExerciseScreen(workoutCategory: categoryId),
            );
          },
        );

      // Weekly Exercise Screen ===============================================
      case Routes.weeklyExerciseScreen:
        return MaterialPageRoute(builder: (_) => const WeeklyExerciseScreen());

      // Token Check Screen ===================================================
      case Routes.checkToken:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => TokencheckCubit(),
                  child: const TokenCheck(),
                ));

      // Detailed Calories Screen =============================================
      case Routes.detaildCaloriesScreen:
        return MaterialPageRoute(builder: (_) => const CaloriesDetails());

      // Water Details Screen =================================================
      case Routes.waterDetails:
        return MaterialPageRoute(builder: (_) => const WaterDetails());

      // Track Steps Details Screen ============================================
      case Routes.trackStepsDetailsScreen:
        return MaterialPageRoute(builder: (_) => const TrackStepDetails());

      // Get Ready Screen ======================================================
      case Routes.getReadyScreen:
        final exercises = settings.arguments as List<ExerciseModel>;
        return MaterialPageRoute(
          builder: (_) => GetReadyScreen(exercises: exercises),
        );

      // Rest Screen ======================================================
      case Routes.restScreen:
      final exercises = settings.arguments as List<ExerciseModel>;
        return MaterialPageRoute(builder: (_) =>  RestScreen(exercises: exercises,));

      // Training Screen ==================================================
      case Routes.trainingScreen:
        final exercises = settings.arguments as List<ExerciseModel>;
        return MaterialPageRoute(builder: (_) =>  TrainingScreen(exercises: exercises,));

      // Set Alarm Screen ======================================================
      case Routes.setAlarm:
        return MaterialPageRoute(builder: (_) => const SetAlarm());

      // Timer Picker Screen ======================================================
      case Routes.timerPicker:
        return MaterialPageRoute(builder: (_) => const TimerPickerScreen());

      default:
        return null;
    }
  }
}
