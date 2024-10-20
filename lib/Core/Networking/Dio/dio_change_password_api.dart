import 'package:dio/dio.dart';

import '../../../Features/Auth/Verifiy/Data/Model/change_password_model.dart';

class DioChangePasswordApi {
  final Dio _dio;

  DioChangePasswordApi({required Dio dio}) : _dio = dio;

  Future<void> changePassword(ChangePasswordModel model) async {
    try {
     await _dio.post(
        'https://fit-pro-app.glitch.me/auth/resetpassword',
        data: model.toJson(),
      );

    } catch (e) {
      throw "Error: $e";
    }
  }
}
