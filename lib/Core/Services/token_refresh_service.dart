import 'package:PureFit/Core/Services/auth_service.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
// import 'package:PureFit/Core/Shared/api_constants.dart'; // Uncomment when backend is ready
// import 'package:dio/dio.dart'; // Uncomment when backend is ready

class TokenRefreshService {
  // static final Dio _dio = Dio(); // Uncomment when backend is ready

  /// Attempts to refresh the token
  /// Returns true if refresh was successful, false otherwise
  /// Note: Currently returns false since backend refresh endpoint is not available
  static Future<bool> refreshToken() async {
    try {
      final currentToken = await SaveTokenDB.getToken();
      if (currentToken == null || currentToken.isEmpty) {
        AppLogger.info('No token available for refresh');
        return false;
      }

      // TODO: Implement when backend refresh endpoint is available
      // For now, we'll just log that refresh is not available
      AppLogger.info(
          'Token refresh endpoint not available - user will be logged out');

      // When backend is ready, uncomment and modify this code:
      /*
      final response = await _dio.post<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiRefreshToken}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $currentToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['token'] as String?;
        if (newToken != null && newToken.isNotEmpty) {
          await SaveTokenDB.saveToken(newToken);
          AppLogger.info('Token refreshed successfully');
          return true;
        }
      }
      */

      return false;
    } catch (e) {
      AppLogger.error('Token refresh failed: $e', StackTrace.current);
      return false;
    }
  }

  /// Handles token refresh and logout if refresh fails
  static Future<bool> handleTokenRefresh() async {
    final refreshSuccess = await refreshToken();

    if (!refreshSuccess) {
      // Logout user and redirect to login
      await AuthService.logout();
      AppLogger.info('Token refresh failed, user logged out');
    }

    return refreshSuccess;
  }
}
