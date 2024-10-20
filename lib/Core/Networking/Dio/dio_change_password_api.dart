import 'package:dio/dio.dart';

import '../../../Features/Auth/Verifiy/Data/Model/change_password_model.dart';

class DioChangePasswordApi {
  final Dio _dio;

  DioChangePasswordApi({required Dio dio}) : _dio = dio;

  Future<String> changePassword(ChangePasswordModel model) async {
    try {
      final response = await _dio.post(
        'https://fit-pro-app.glitch.me/auth/resetpassword',
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        return "Password Changed Successfully";
      } else {
        return "Failed to Change Password";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
