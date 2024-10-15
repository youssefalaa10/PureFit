import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

typedef NavigateFunction = void Function(String routeName);

class NotificationController {
  static GlobalKey<NavigatorState>? navigatorKey; // Nullable navigator key

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Extract the screen from the payload
    String? screen = receivedAction.payload?['screen'];

    print('Received screen: $screen'); // Check what screen is received

    if (screen != null && navigatorKey != null) {
      // Use navigatorKey to navigate
      navigatorKey!.currentState?.pushNamedAndRemoveUntil(
        screen, // Replace with your target screen
        (route) => (route.settings.name != screen) || route.isFirst,
        arguments: receivedAction,
      );
    } else {
      print('Navigation failed: screen or navigatorKey is null');
    }
  }

  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key; // Set the navigator key
  }
}
