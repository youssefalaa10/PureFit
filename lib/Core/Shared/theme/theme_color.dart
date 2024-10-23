import 'package:flutter/material.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';


   ThemeData lightTheme = ThemeData(
    primaryColor: ColorManager.primaryColor,
    scaffoldBackgroundColor: ColorManager.backGroundColor,
    colorScheme: ColorScheme(
      primary: ColorManager.primaryColor,
      primaryContainer: ColorManager.lightBlueColor, // Optional
      secondary: ColorManager.blueColor,
      secondaryContainer: ColorManager.lightGreenColor, // Optional
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ColorManager.primaryColor,//black
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorManager.backGroundColor,
      iconTheme:  IconThemeData(color: ColorManager.primaryColor),//black
    ),
    textTheme:  TextTheme(
      bodyMedium: TextStyle(color: ColorManager.primaryColor),//black
      bodySmall: TextStyle(color: ColorManager.primaryColor),//black
    ),
    iconTheme:  IconThemeData(color: ColorManager.primaryColor),//black
    cardColor: Colors.white,
  );

 ThemeData darkTheme = ThemeData(
    primaryColor: ColorManager.backGroundColor,
    scaffoldBackgroundColor: ColorManager.primaryColor,
    colorScheme: ColorScheme(
      primary: ColorManager.backGroundColor,
      primaryContainer: ColorManager.darkColor, // Optional
      secondary: ColorManager.blueColor,
      secondaryContainer: ColorManager.lightOrangeColor, // Optional
      surface: ColorManager.primaryColor,
      error: Colors.red,
      onPrimary: ColorManager.primaryColor,//black
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: ColorManager.primaryColor,//black
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorManager.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    cardColor: ColorManager.primaryColor,
  );

