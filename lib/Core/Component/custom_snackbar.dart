import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(
    BuildContext context,
    String message,
  ) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0),
        ),
        backgroundColor: ColorManager.primaryColor.withOpacity(0.95),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: ColorManager.whiteColor,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Provide a method to get the GlobalKey
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;
}
