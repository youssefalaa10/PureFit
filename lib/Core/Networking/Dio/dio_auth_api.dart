import 'package:PureFit/Core/Networking/ErrorHandler/api_error_handler.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:dio/dio.dart';

import '../../../Features/Auth/Login/Data/Model/login_model.dart';
import '../../../Features/Auth/Register/Data/Model/register_model.dart';
import '../../Shared/api_constants.dart';
import '../../helpers/app_logger.dart';

class DioAuthApi {
  DioAuthApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<void> _saveToken(String token) async {
    if (token.isNotEmpty) {
      await SaveTokenDB.saveToken(token);
    }
  }

  Future<bool> dioRegister({required RegisterModel user}) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        '${ApiConstants.baseUrl}${ApiConstants.apiRegister}',
        data: user.toMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 400) {
        if (response.data != null && response.data['token'] != null) {
          await _saveToken(response.data['token']);
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (error) {
      final api = ApiErrorHandler.handle(error);
      throw '${api.message}';
    }
  }

  Future<bool> dioLogin({required LoginModel user}) async {
    try {
      final String originalUrl =
          '${ApiConstants.baseUrl}${ApiConstants.apiLogin}';

      AppLogger.info('Attempting login for: ${user.userEmail}');

      final Response<dynamic> response = await _dio.post<dynamic>(
        originalUrl,
        data: user.toMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
          followRedirects: false,
          maxRedirects: 0,
        ),
      );

      AppLogger.info('Login status: ${response.statusCode}');
      AppLogger.info('Login response: ${response.data}');

      // Handle 308 Permanent Redirect by following the Location header and retrying the POST
      if (response.statusCode == 308) {
        final String? location = response.headers.value('location');
        if (location != null && location.isNotEmpty) {
          final String redirectUrl = _resolveRedirectUrl(originalUrl, location);
          AppLogger.info('Following redirect to: $redirectUrl');
          final Response<dynamic> redirected = await _dio.post<dynamic>(
            redirectUrl,
            data: user.toMap(),
            options: Options(
              headers: {
                'Content-Type': 'application/json',
              },
              validateStatus: (status) {
                return status != null && status < 500;
              },
              followRedirects: false,
              maxRedirects: 0,
            ),
          );

          AppLogger.info('Redirected status: ${redirected.statusCode}');
          AppLogger.info('Redirected response: ${redirected.data}');

          if (redirected.statusCode != null &&
              redirected.statusCode! >= 200 &&
              redirected.statusCode! < 300 &&
              redirected.data is Map &&
              redirected.data['token'] != null) {
            await _saveToken(redirected.data['token']);
            return true;
          }
          return false;
        }
        return false;
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data != null &&
            response.data is Map &&
            response.data['token'] != null) {
          await _saveToken(response.data['token']);
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (error) {
      final api = ApiErrorHandler.handle(error);
      throw '${api.message}';
    }
  }

  String _resolveRedirectUrl(String baseUrl, String location) {
    try {
      final Uri resolved = Uri.parse(baseUrl).resolve(location);
      return resolved.toString();
    } catch (_) {
      return location;
    }
  }
}
