import 'package:dio/dio.dart';

class DioVerificationApi {
  final Dio _dio;

  DioVerificationApi({required Dio dio}) : _dio = dio;

  Future<String> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post(
        'https://fit-pro-app.glitch.me/auth/verifycode',
        data: {'email': email, 'verificationCode': code},
      );
      print('dio verify : ${response.data}');
      if (response.statusCode == 200) {
        return "Verification Successful";
      } else {
        return "Verification Failed";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}