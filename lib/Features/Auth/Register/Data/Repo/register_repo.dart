import '../../../../../Core/Networking/Dio/dio_auth_api.dart';
import '../Model/register_model.dart';

class RegisterRepo {
  RegisterRepo({required this.dioAuthApi});
  final DioAuthApi dioAuthApi;

  Future<bool> doRegister(RegisterModel user) async {
    return await dioAuthApi.dioRegister(user: user);
  }
}
