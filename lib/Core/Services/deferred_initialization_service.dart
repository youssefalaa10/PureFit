import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'notificationcontroler.dart';
import 'voice_service.dart';

/// Service to handle deferred initialization of non-critical services
/// This prevents blocking the main thread during app startup
class DeferredInitializationService {
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  /// Initialize non-critical services after the first frame
  static Future<void> initializeAfterFirstFrame(BuildContext context) async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;
    developer.Timeline.startSync('deferred_services_init');

    try {
      // Wait for the first frame to complete
      await WidgetsBinding.instance.endOfFrame;

      // Initialize services in the background
      _initializeServicesInBackground();
    } catch (e) {
      developer.Timeline.finishSync();
      print('Deferred initialization failed: $e');
    }
  }

  /// Initialize services in background without blocking UI
  static Future<void> _initializeServicesInBackground() async {
    try {
      // Initialize notification service
      developer.Timeline.startSync('notification_service_init');
      await NotificationController.initializeEnhancedNotifications();
      developer.Timeline.finishSync();

      // Initialize voice service
      developer.Timeline.startSync('voice_service_init');
      await VoiceService().initialize();
      developer.Timeline.finishSync();

      // Request notification permissions (non-blocking)
      _requestPermissionsInBackground();

      _isInitialized = true;
      developer.Timeline.finishSync();
    } catch (e) {
      developer.Timeline.finishSync();
      print('Background service initialization failed: $e');
    } finally {
      _isInitializing = false;
    }
  }

  /// Request permissions in background without blocking UI
  static void _requestPermissionsInBackground() {
    Future.microtask(() async {
      try {
        final hasPermission =
            await NotificationController.requestNotificationPermission();
        if (!hasPermission) {
          print('Notification permission not granted');
        }
      } catch (e) {
        print('Permission request failed: $e');
      }
    });
  }

  /// Check if services are initialized
  static bool get isInitialized => _isInitialized;

  /// Force initialization if needed (for critical features)
  static Future<void> forceInitialize() async {
    if (_isInitialized) return;

    await _initializeServicesInBackground();
  }
}
