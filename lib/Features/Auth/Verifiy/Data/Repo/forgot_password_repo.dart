

import '../../../../../Core/Networking/Dio/dio_forgot_password_api.dart';

class ForgotPasswordRepo {
  final DioForgotPasswordApi _dioForgotPasswordApi;

  ForgotPasswordRepo(this._dioForgotPasswordApi);

  Future<String> sendCode(String email) async {
    return await _dioForgotPasswordApi.sendVerificationCode(email);
  }
}
