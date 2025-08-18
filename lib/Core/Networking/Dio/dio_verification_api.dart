import 'package:dio/dio.dart';

class DioVerificationApi {
  DioVerificationApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<void> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post(
        'https://fit-pro-app.glitch.me/auth/verifycode',
        data: {'email': email, 'verificationCode': code},
      );
      print('dio verify : ${response.data}');
    } catch (e) {
      // return "Error: $e";
      throw 'Verification Failedddd ';
    }
  }
}
