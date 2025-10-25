import 'package:PureFit/Core/Services/token_refresh_service.dart';
import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  static bool _isRefreshing = false;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SaveTokenDB.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      AppLogger.info('Received 401, attempting token refresh');

      // Prevent multiple simultaneous refresh attempts
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          final refreshSuccess = await TokenRefreshService.handleTokenRefresh();

          if (refreshSuccess) {
            // Retry the original request with new token
            final newToken = await SaveTokenDB.getToken();
            if (newToken != null) {
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              // Retry the request
              final dio = Dio();
              try {
                final response = await dio.fetch<dynamic>(err.requestOptions);
                handler.resolve(response);
                return;
              } catch (e) {
                AppLogger.error('Request retry failed: $e', StackTrace.current);
              }
            }
          } else {
            AppLogger.info('Token refresh failed - user will be logged out');
          }
        } finally {
          _isRefreshing = false;
        }
      }
    }

    super.onError(err, handler);
  }
}
