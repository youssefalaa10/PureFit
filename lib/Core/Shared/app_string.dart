import 'package:fitpro/Core/Shared/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class AppString {
  //font
  static const String font = 'Lato';
  // images----------------------------------------------------------
  static String profile = "assets/images/profile.jpeg";
  static String waterLottie = "assets/lottie/water_lottie.json";
  static String sleepLottie = "assets/lottie/sleep_lottie.json";
  static String bottlewater = "assets/lottie/bottle.json";
  static String cupwater = "assets/lottie/cupWater.json";

  // UserAgeScreen ---------------------------------------------------
  static String howOldAreYou = "How old Are You?";
  static String helpUsCreateYourPersonalizedPlan =
      "This helps us create your personalized plan";
  static String next = "Next";
  // UserGenderScreen
  static String tellUsAboutYourself = "Tell us about yourself!";
  static String tellYourGender =
      "To give you a better experience we need to know your gender";
  static String male = "Male";
  static String female = "Female";
  // BodyMetrics screen---------------------------------------------------
  static String tellUsYourWeight = 'Tell us your weight';
  static String tellUsYourHeight = 'Tell us your height';

  static String welcomeBack(BuildContext context) => 'welcomeBack'.tr(context);
  static String workouts(BuildContext context) => 'workouts'.tr(context);
  static String recommendedWorkouts(BuildContext context) =>
      'recommendedWorkouts'.tr(context);
  // MyPlan screen ------------------------------------------------

  static String myPlan = "My Plan";
  static String dailyPlan = "Daily Plan";
  static String statics = "Statics";
  static String calories = "Calories";
  static String steps = "Steps";
  static String sleep = "Sleep";
  static String water = "Water";
  static String bmiCalculator = "BMI";
  static String lastupdate = "Last Update:";
  static String kcal = "Kcal";
  static String hours = "Hours";
  static String liters = "Liters";

  // TrackSteps Screen ---------------------------------
  static String myActivity = "My Activity";
  static String greatWork = "Great Work!";
  static String stepsdetails = "Steps Details";
  static String yourDailytasksAlmostDone = "Your Daily Tasks \n Almost Done!";

  // Calories Screen ____________________
  static String youHavetoEatMoreCalories = "You Have to Eat \n More Calories!";
  static String keepGoing = "Keep Going!";

  // Sleep Screen
  static String startsleep = "Start Sleep";
  static String imWakedUp = "I'm Waked Up";
  static String sleepdetails = "Sleep Details";
  static String today = "Today";
  static String setnewAlarm = "Set New Alarm";
  static String todaymeals = "Today meals";
  static String caloriesdetails = "Calories Details";

//Water screen
  static String addwater = "Today, I would like to drink";
  static String waterIntakeDetails = "Water Intake Details";
  static String setnewtarget = "Set New Target";
  static String waterIntakeTarget = "Water Intake Target";
}
