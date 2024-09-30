import 'package:dio/dio.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';
import 'package:fitpro/Core/Networking/interceptors/dio_interceptor.dart';
import 'package:fitpro/Core/Shared/api_constans.dart';

class DioAuthApi {
  final Dio _dio = Dio();

  DioAuthApi() {
    _dio.interceptors.add(DioInterceptor());
  }

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

  Future<bool> dioLogin(String email, String password) async {
    try {
      final response = await _dio.post(
        "${ApiConstans.baseUrl}${ApiConstans.apiLogin}",
        data: _loginData(email, password),
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

  Future<bool> dioRegister({
    required String email,
    required String password,
    required String userName,
    required int age,
    required int height,
    required int weight,
    required String gender,
    int? goalSteps,
    String? image,
  }) async {
    // Input validation to ensure no empty or invalid values
    if (email.isEmpty ||
        password.isEmpty ||
        userName.isEmpty ||
        gender.isEmpty) {
      print("One or more required fields are empty.");
      return false;
    }

    try {
      final response = await _dio.post(
        "${ApiConstans.baseUrl}${ApiConstans.apiRegister}",
        data: {
          "userEmail": email,
          "password": password,
          "userName": userName,
          "age": age,
          "userHeight": height,
          "userWeight": weight,
          "gender": gender,
          "goalSteps": goalSteps,
          "image": image,
        },
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
