import 'package:dio/dio.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';
import 'package:fitpro/Features/Signup/Data/Model/regsetier_model.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';
import 'package:flutter/foundation.dart';

class DioAuthApi {
  final Dio _dio;

  DioAuthApi({required Dio dio}) : _dio = dio;

  Future<void> _saveToken(String token) async {
    if (token.isNotEmpty) {
      await SaveTokenDB.saveToken(token);
    } else {
      if (kDebugMode) {
        print('Token not found in response');
      }
    }
  }

  Future<bool> dioRegister({required RegisterModel user}) async {
    try {
      final response = await _dio.post(
        "https://fit-pro-app.glitch.me/auth/register",
        data: user.toMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        await _saveToken(response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Registration error: $e");
      }
      return false;
    }
  }

  Future<bool> dioLogin({required LoginModel user}) async {
    try {
      final response = await _dio.post(
        "https://fit-pro-app.glitch.me/auth/login",
        data: user.toMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        await _saveToken(response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          print("Login error [${e.type}]: ${e.message}");
        }
        if (e.response != null) {
          if (kDebugMode) {
            print("Response data: ${e.response?.data}");
          }
          if (kDebugMode) {
            print("Status code: ${e.response?.statusCode}");
          }
        }
      } else {
        if (kDebugMode) {
          print("Unexpected error: $e");
        }
      }
      return false;
    }
  }
}
