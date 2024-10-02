import 'package:dio/dio.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';
import 'package:fitpro/Core/Shared/api_constans.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';
import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';
import 'package:fitpro/Features/Signup/Data/Model/regsetier_model.dart';

class DioAuthApi {
  final Dio _dio;

  DioAuthApi({required Dio dio}) : _dio = dio;

  Map<String, dynamic> _loginData(String email, String password) =>
      {"email": email, "password": password};

  Future<void> _saveToken(Map<String, dynamic> data) async {
    final token = data['token'];
    if (token != null) {
      await SaveTokenDB.saveToken(token);
    } else {
      print('Token not found in response');
    }
  }

  Future<bool> dioLogin(LoginModel loginModel) async {
    try {
      final response = await _dio.post(
        "${ApiConstans.baseUrl}${ApiConstans.apiLogin}",
        data: _loginData(loginModel.userEmail, loginModel.userPassword),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        await _saveToken(response.data);
        return true;
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> dioRegister({RegisterModel? user}) async {
    // Input validation to ensure no empty or invalid values
    if (user!.userEmail.isEmpty ||
        user.password.isEmpty ||
        user.userName.isEmpty ||
        user.gender.isEmpty) {
      print("One or more required fields are empty.");
      return false;
    }

    try {
      final response = await _dio.post(
        "${ApiConstans.baseUrl}${ApiConstans.apiRegister}",
        data: UserModel(
            password: user.password,
            userName: user.userName,
            userEmail: user.userEmail,
            age: user.age,
            userHeight: user.userHeight,
            userWeight: user.userWeight,
            gender: user.gender),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        await _saveToken(response.data);
        return true;
      }

      return false;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }
}
