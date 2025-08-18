import '../../../../../Core/Networking/Dio/dio_forgot_password_api.dart';

class ForgotPasswordRepo {
  ForgotPasswordRepo(this._dioForgotPasswordApi);
  final DioForgotPasswordApi _dioForgotPasswordApi;

  Future<void> sendCode(String email) async {
    await _dioForgotPasswordApi.sendVerificationCode(email);
  }
}
