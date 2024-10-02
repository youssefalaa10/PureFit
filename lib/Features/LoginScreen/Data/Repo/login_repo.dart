import 'package:fitpro/Core/Networking/DioAuthApi/dio_auth_api.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';

class LoginRepo {
  final DioAuthApi dioAuthApi;

  LoginRepo({required this.dioAuthApi});

  doLogin(LoginModel loginModel) async {
    await dioAuthApi.dioLogin(loginModel);
  }
}
