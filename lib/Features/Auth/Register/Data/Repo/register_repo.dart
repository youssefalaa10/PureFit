import '../../../../../Core/Networking/Dio/dio_auth_api.dart';
import '../Model/register_model.dart';

class RegisterRepo {
  final DioAuthApi dioAuthApi;

  RegisterRepo({required this.dioAuthApi});

  Future<bool> doRegister(RegisterModel user) async {
    return await dioAuthApi.dioRegister(user: user);
  }
}
