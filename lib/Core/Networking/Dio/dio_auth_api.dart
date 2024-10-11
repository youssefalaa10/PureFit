import 'package:dio/dio.dart';
import 'package:fitpro/Core/local_db/DioSavedToken/save_token.dart';

import 'package:flutter/foundation.dart';

import '../../../Features/Auth/Login/Data/Model/login_model.dart';
import '../../../Features/Auth/Register/Data/Model/register_model.dart';

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
    } on DioException catch (dioError) {
      throw dioError.response?.data;
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
        if (response.data['success'] == true &&
            response.data['token'] != null) {
          await _saveToken(response.data['token']);
          print(response.data['message']); // Successful login message
          return true;
        } else {
          // Handle cases where the token is not returned or success is false
          print(response.data[
              'message']); // Error message from the API (e.g. "Invalid email or password")
          return false;
        }
      } else {
        print("Unexpected response: ${response.statusCode}");
        return false;
      }
    } on DioException catch (dioError) {
      // Handle Dio-related errors (such as server-side errors)
      if (dioError.response != null) {
        print("Server Error: ${dioError.response?.data['message']}");
      } else {
        print("Connection Error: ${dioError.message}");
      }
      return false;
    } catch (e) {
      // Handle other types of exceptions (e.g., null pointer exceptions)
      print("Other Exception: ${e.toString()}");
      return false;
    }
  }
}
