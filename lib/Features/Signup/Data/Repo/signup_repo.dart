import 'package:fitpro/Core/Networking/DioAuthApi/dio_auth_api.dart';
import 'package:fitpro/Features/Signup/Data/Model/regsetier_model.dart';

class SignupRepo {
  final DioAuthApi dioAuthApi;

  SignupRepo({required this.dioAuthApi});

  doRegister(RegisterModel user) async {
    await dioAuthApi.dioRegister(user: user);
  }
}
