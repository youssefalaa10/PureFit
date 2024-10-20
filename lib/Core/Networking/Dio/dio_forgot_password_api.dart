import 'package:dio/dio.dart';

class DioForgotPasswordApi {
  final Dio _dio;

  DioForgotPasswordApi({required Dio dio}) : _dio = dio;

  Future<void> sendVerificationCode(String email) async {
    try {
      await _dio.post(
        'https://fit-pro-app.glitch.me/auth/sendcode',
        data: {'email': email},
      );

    } catch (e) {
      throw "Check your internet connection";
    }
  }
}
