import 'package:dio/dio.dart';

import '../../helpers/app_logger.dart';

class DioVerificationApi {
  DioVerificationApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<void> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post<dynamic>(
        'https://fit-pro-app.glitch.me/auth/verifycode',
        data: {'email': email, 'verificationCode': code},
      );
      AppLogger.info('dio verify : ${response.data}');
    } catch (e) {
      AppLogger.error('Error verifying code: $e', StackTrace.current);
      // return "Error: $e";
      throw 'Verification Failedddd ';
    }
  }
}
