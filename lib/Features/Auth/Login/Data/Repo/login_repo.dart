import '../../../../../Core/Networking/Dio/dio_auth_api.dart';
import '../Model/login_model.dart';

class LoginRepo {
  final DioAuthApi dioAuthApi;

  LoginRepo({required this.dioAuthApi});

  Future<bool> doLogin(LoginModel loginModel) async {
    return await dioAuthApi.dioLogin(user: loginModel);
  }
}
