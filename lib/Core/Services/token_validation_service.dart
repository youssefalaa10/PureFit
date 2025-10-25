import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';

class TokenValidationService {
  static const int _tokenValidityDays = 30;

  /// Validates if the current token is still valid
  /// Returns true if token exists and is not expired
  static Future<bool> isTokenValid() async {
    try {
      final token = await SaveTokenDB.getToken();
      if (token == null || token.isEmpty) {
        AppLogger.info('No token found');
        return false;
      }

      // Check if token has expiration timestamp stored
      final tokenData = await SaveTokenDB.getTokenData();
      if (tokenData == null) {
        AppLogger.info('No token data found, token may be expired');
        return false;
      }

      final now = DateTime.now();
      final tokenExpiry =
          DateTime.fromMillisecondsSinceEpoch(tokenData['expiresAt']);

      if (now.isAfter(tokenExpiry)) {
        AppLogger.info('Token has expired');
        await SaveTokenDB.clearToken();
        return false;
      }

      AppLogger.info('Token is valid');
      return true;
    } catch (e) {
      AppLogger.error('Error validating token: $e', StackTrace.current);
      return false;
    }
  }

  /// Checks if token is close to expiration (within 7 days)
  static Future<bool> isTokenNearExpiry() async {
    try {
      final tokenData = await SaveTokenDB.getTokenData();
      if (tokenData == null) return true;

      final now = DateTime.now();
      final tokenExpiry =
          DateTime.fromMillisecondsSinceEpoch(tokenData['expiresAt']);
      final daysUntilExpiry = tokenExpiry.difference(now).inDays;

      return daysUntilExpiry <= 7;
    } catch (e) {
      AppLogger.error('Error checking token expiry: $e', StackTrace.current);
      return true;
    }
  }

  /// Calculates token expiration date
  static DateTime calculateTokenExpiry() {
    return DateTime.now().add(const Duration(days: _tokenValidityDays));
  }
}
