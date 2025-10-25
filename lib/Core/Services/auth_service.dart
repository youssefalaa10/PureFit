import 'package:PureFit/Core/Routing/Routes.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Logs out the user by clearing token and navigating to login
  static Future<void> logout() async {
    try {
      // Clear stored token
      await SaveTokenDB.clearToken();

      AppLogger.info('User logged out successfully');

      // Navigate to login screen
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          Routes.loginScreen,
          (route) => false,
        );
      }
    } catch (e) {
      AppLogger.error('Error during logout: $e', StackTrace.current);
    }
  }

  /// Checks if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final token = await SaveTokenDB.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error checking authentication: $e', StackTrace.current);
      return false;
    }
  }
}
