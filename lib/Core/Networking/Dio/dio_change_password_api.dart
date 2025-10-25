import 'package:PureFit/Core/Networking/ErrorHandler/api_error_handler.dart';
import 'package:dio/dio.dart';

import '../../../Features/Auth/Verifiy/Data/Model/change_password_model.dart';

class DioChangePasswordApi {
  DioChangePasswordApi({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<void> changePassword(ChangePasswordModel model) async {
    try {
      await _dio.post<dynamic>(
        'https://fit-pro-app.glitch.me/auth/resetpassword',
        data: model.toJson(),
      );
    } catch (error) {
      final api = ApiErrorHandler.handle(error);
      throw '${api.message}';
    }
  }
}
