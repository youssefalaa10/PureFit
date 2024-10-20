import 'package:dio/dio.dart';

class DioForgotPasswordApi {
  final Dio _dio;

  DioForgotPasswordApi({required Dio dio}) : _dio = dio;

  Future<String> sendVerificationCode(String email) async {
    try {
      final response = await _dio.post(
        'https://fit-pro-app.glitch.me/auth/sendcode',
        data: {'email': email},
      );
        print('hhhhhh${response.data}');
      if (response.statusCode == 200 && response.data['message'] == "Verification Code Send") {
        return "Verification Code Send";
      } else {
        return "Failed to send code";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
