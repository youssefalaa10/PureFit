import 'package:PureFit/Features/Calories/Logic/cubit/todayfood_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:PureFit/Features/Auth/Verifiy/Logic/forgot_pass_cubit/forgot_password_cubit.dart';
import 'package:PureFit/Features/Diet/Data/Model/base_diet_model.dart';
import 'package:PureFit/Features/Exercises/UI/exercise_screen.dart';
import 'package:PureFit/Features/Exercises/UI/exercisepageveiw_.dart';

import '../../Features/AiChat/trainer_chat.dart';
import '../../Features/Auth/Login/Logic/cubit/login_cubit.dart';
import '../../Features/Auth/Login/Ui/login_screen.dart';
import '../../Features/Auth/Register/Logic/cubit/register_cubit.dart';
import '../../Features/Auth/Register/Ui/register_screen.dart';
import '../../Features/Auth/Verifiy/Logic/change_password_cubit/change_password_cubit.dart';
import '../../Features/Auth/Verifiy/Logic/verifiy_cubit/verification_cubit.dart';
import '../../Features/Auth/Verifiy/UI/change_password.dart';
import '../../Features/Auth/Verifiy/UI/forgot_password.dart';
import '../../Features/Auth/Verifiy/UI/verification.dart';
import '../../Features/AuthHelper/cubit/tokencheck_cubit.dart';
import '../../Features/AuthHelper/token_check.dart';
import '../../Features/Calories/Ui/calories_details.dart';
import '../../Features/Calories/Ui/calories_screen.dart';
import '../../Features/Diet/Data/Repo/favorite_repo.dart';
import '../../Features/Diet/Logic/favorite_cubit/favorite_cubit.dart';
import '../../Features/Diet/UI/diet_detials_screen.dart';
import '../../Features/Exercises/Data/Model/exercise_model.dart';
import '../../Features/Exercises/Data/Model/workout_categories_model.dart';
import '../../Features/Exercises/Logic/exercise_cubit/exercise_cubit.dart';
import '../../Features/Exercises/Logic/training_cubit/training_cubit.dart';
import '../../Features/Exercises/Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import '../../Features/Exercises/UI/weekly_exercise_screen.dart';
import '../../Features/Home/home_screen.dart';
import '../../Features/Layout/layout_screen.dart';
import '../../Features/MyPlan/myplan_screen.dart';
import '../../Features/Profile/Data/Model/user_model.dart';
import '../../Features/Profile/Logic/cubit/profile_cubit.dart';
import '../../Features/Profile/UI/edit_profile_screen.dart';
import '../../Features/Profile/UI/profile_screen.dart';
import '../../Features/Profile/UI/settings/terms_conditions.dart';
import '../../Features/Profile/UI/settings_screen.dart';
import '../../Features/Sleep/Logic/cubit/sleep_cubit.dart';
import '../../Features/Sleep/set_alarm.dart';
import '../../Features/Sleep/sleep_screan.dart';
import '../../Features/Sleep/timer_picker.dart';
import '../../Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import '../../Features/TrackSteps/Ui/track_step_details.dart';
import '../../Features/TrackSteps/Ui/track_steps_screen.dart';
import '../../Features/UserInfo/UI/body_metrics.dart';
import '../../Features/UserInfo/UI/fitness_goal_screen.dart';
import '../../Features/UserInfo/UI/info_pageveiw.dart';
import '../../Features/UserInfo/UI/user_age_screen.dart';
import '../../Features/UserInfo/UI/user_gender_screen.dart';
import '../../Features/Water/Logic/cubit/water_intake_cubit.dart';
import '../../Features/Water/water_screen.dart';
import '../../Features/Water/water_target.dart';
import '../DI/dependency.dart';
import 'Routes.dart';

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

      // Settings Screen ===============================================
      case Routes.settingScreen:
        return MaterialPageRoute(builder: (_) => const SettingScreen());

      // Layout Screen ==================================================
      case Routes.layoutScreen:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());

      // My Plan Screen ================================================
      case Routes.myPlanScreen:
        return MaterialPageRoute(builder: (_) => const MyPlanScreen());

      // Calories Screen ==============================================
      case Routes.caloriesScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<TodayfoodCubit>(),
                  child: const CaloriesScreen(),
                ));

      // Water Screen =================================================
      case Routes.waterScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<WaterIntakeCubit>(),
                  child: const WaterScreen(),
                ));

      case Routes.sleepScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<SleepCubit>(),
                  child: const SleepScreen(),
                ));

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
        return MaterialPageRoute(
          builder: (context) {
            // final profileId = settings.arguments as String;
            return BlocProvider(
              create: (context) => getIT<WeeklyExerciseCubit>(),
              child: const WeeklyExerciseScreen(), // Pass profileId
            );
          },
        );
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
        final fullsteps = settings.arguments as int;

        return MaterialPageRoute(
            builder: (_) => TrackStepDetails(fullstepsOftoday: fullsteps));

      // Get Ready Screen ======================================================
      case Routes.trainingScreen:
        final exercises = settings.arguments as List<ExerciseModel>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => TrainingCubit(exercises),
            child: ExerciseStages(exercises: exercises),
          ),
        );

      // // Rest Screen ======================================================
      // case Routes.restScreen:
      //   final exercises = settings.arguments as List<ExerciseModel>;
      //   return MaterialPageRoute(
      //       builder: (_) => RestScreen(
      //             exercises: exercises,
      //           ));

      // // Training Screen ==================================================
      // case Routes.trainingScreen:
      //   final exercises = settings.arguments as List<ExerciseModel>;
      //   return MaterialPageRoute(
      //       builder: (_) => TrainingScreen(
      //             exercises: exercises,
      //           ));

      // Set Alarm Screen ======================================================
      case Routes.setAlarm:
        return MaterialPageRoute(builder: (_) => const SetAlarm());

      // Timer Picker Screen ======================================================
      case Routes.timerPicker:
        return MaterialPageRoute(builder: (_) => const TimerPickerScreen());

      // FoodDiet ===============================================================
      // case Routes.foodDietScreen:
      //   return MaterialPageRoute(
      //       builder: (_) => const DietScreen()); //in laDietScreen// Food Item Screen =========================DietModel====================
      // case Routes.foodItem:
      //   return MaterialPageRoute(builder: (_) => const FoodItem());

      // Food Details Screen ===================================================
      case Routes.detailsScreen:
        final dietItem = settings.arguments as BaseDietModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                FavoriteCubit(favoriteRepo: getIT<FavoriteRepo>()),
            child: DetailScreen(dietItem: dietItem),
          ),
        );

      // Change Password =========================================================
      case Routes.changePasswordScreen:
        return MaterialPageRoute(
          builder: (context) {
            final email = settings.arguments as String;
            return BlocProvider(
              create: (context) => getIT<ChangePasswordCubit>(),
              child: ChangePasswordScreen(email: email),
            );
          },
        );

      // Forgot Password ========================================================
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIT<ForgotPasswordCubit>(),
                  child: const ForgotPasswordScreen(),
                ));

      // Verification Screen ====================================================
      case Routes.verificationScreen:
        return MaterialPageRoute(
          builder: (context) {
            final email = settings.arguments as String;
            return BlocProvider(
              create: (context) => getIT<VerificationCubit>(),
              child: VerificationScreen(email: email),
            );
          },
        );

      // Fitness Goal Screen ===================================================
      case Routes.fitnessGoalScreen:
        return MaterialPageRoute(builder: (_) => const FitnessGoalScreen());
      // Trainer  Screen ===================================================
      case Routes.trainerChat:
        return MaterialPageRoute(builder: (_) => const TrainerChat());

      case Routes.termsOfServiceScreen:
        return MaterialPageRoute(builder: (_) => const TermsOfServiceScreen());

      default:
        return null;
    }
  }
}
