import 'package:flutter/foundation.dart';

import '../../../../../Core/Networking/Dio/dio_auth_api.dart';
import '../Model/login_model.dart';

class LoginRepo {
  final DioAuthApi dioAuthApi;

  LoginRepo({required this.dioAuthApi});

  Future<bool> doLogin(LoginModel loginModel) async {
    try {
      bool success = await dioAuthApi.dioLogin(user: loginModel);
      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Error in LoginRepo: $e");
      }
      return false;
    }
  }
}
