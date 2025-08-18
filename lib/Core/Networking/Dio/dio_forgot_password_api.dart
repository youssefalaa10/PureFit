import 'package:dio/dio.dart';

class DioForgotPasswordApi {
  DioForgotPasswordApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<void> sendVerificationCode(String email) async {
    try {
      await _dio.post(
        'https://fit-pro-app.glitch.me/auth/sendcode',
        data: {'email': email},
      );
    } catch (e) {
      throw 'Check your internet connection';
    }
  }
}
