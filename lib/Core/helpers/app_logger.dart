import 'package:flutter/foundation.dart';


class AppLogger {
  /// General log method
  static void log(String message) {
    if (kDebugMode) {
      // Only prints in debug mode
      // ignore: avoid_print
      print('[LOGGER]: $message');
    }
  }

  /// Info logs
  static void info(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ℹ️ Logger-INFO]: $message');
    }
  }

  /// Warning logs
  static void warn(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[⚠️Logger-WARNING]: $message');
    }
  }

  /// Error logs
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[❌Logger-ERROR]: $message');
      if (error != null) print('   Error: $error');
      if (stackTrace != null) print('   StackTrace: $stackTrace');
    }
  }
}
