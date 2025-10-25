import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class PermissionManager {
  static final Map<String, bool> _permissionCache = {};
  static final Map<String, DateTime> _lastRequestTime = {};

  // Minimum time between requests (5 minutes)
  static const Duration _cooldownPeriod = Duration(minutes: 5);

  /// Request permission with rationale and cooldown
  static Future<bool> requestPermission({
    required String permissionName,
    required Permission permission,
    required String rationale,
    String? deniedMessage,
  }) async {
    try {
      // Check cache first
      if (_permissionCache.containsKey(permissionName)) {
        final cached = _permissionCache[permissionName]!;
        AppLogger.log('Using cached permission for $permissionName: $cached');
        return cached;
      }

      // Check cooldown
      if (_isInCooldown(permissionName)) {
        AppLogger.log(
            'Permission $permissionName is in cooldown, skipping request');
        return false;
      }

      // Check current status
      final status = await permission.status;

      if (status.isGranted) {
        _permissionCache[permissionName] = true;
        return true;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.log('Permission $permissionName permanently denied');
        _permissionCache[permissionName] = false;
        return false;
      }

      // Request permission
      AppLogger.log('Requesting $permissionName: $rationale');
      final result = await permission.request();

      _permissionCache[permissionName] = result.isGranted;
      _lastRequestTime[permissionName] = DateTime.now();

      return result.isGranted;
    } catch (e) {
      AppLogger.log('Error requesting $permissionName: $e');
      return false;
    }
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission({
    String rationale =
        'Enable notifications for step reminders and goal celebrations',
  }) async {
    try {
      if (_permissionCache.containsKey('notifications')) {
        return _permissionCache['notifications']!;
      }

      if (_isInCooldown('notifications')) {
        return false;
      }

      AppLogger.log('Requesting notification permission: $rationale');
      final result =
          await AwesomeNotifications().requestPermissionToSendNotifications();

      _permissionCache['notifications'] = result;
      _lastRequestTime['notifications'] = DateTime.now();

      return result;
    } catch (e) {
      AppLogger.log('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Check if permission is granted (cached)
  static Future<bool> isPermissionGranted(String permissionName) async {
    if (_permissionCache.containsKey(permissionName)) {
      return _permissionCache[permissionName]!;
    }
    return false;
  }

  /// Check if permission is in cooldown
  static bool _isInCooldown(String permissionName) {
    final lastRequest = _lastRequestTime[permissionName];
    if (lastRequest == null) return false;

    return DateTime.now().difference(lastRequest) < _cooldownPeriod;
  }

  /// Clear cache (useful for testing or app restart)
  static void clearCache() {
    _permissionCache.clear();
    _lastRequestTime.clear();
    AppLogger.log('Permission cache cleared');
  }

  /// Get all permission statuses
  static Future<Map<String, bool>> getAllPermissionStatuses() async {
    return Map.from(_permissionCache);
  }
}
