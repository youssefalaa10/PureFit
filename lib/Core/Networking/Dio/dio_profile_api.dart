import 'package:dio/dio.dart';
import 'package:PureFit/Core/Shared/api_constants.dart';
import 'package:PureFit/Features/Profile/Data/Model/user_model.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:flutter/foundation.dart';

class DioProfileApi {
  final Dio _dio;

  DioProfileApi({required Dio dio}) : _dio = dio;

  Future<UserModel?> getProfile() async {
    try {
      final token = await SaveTokenDB.getToken();
      final response = await _dio.get(
        "${ApiConstants.baseUrl}${ApiConstants.apiGetProfile}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final user = UserModel.fromMap(response.data);

        return user;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile: $e");
      }
    }
    return null;
  }

  Future<bool> updateProfile(UserModel user, String profileId) async {
    try {
      final token = await SaveTokenDB.getToken();
      final response = await _dio.put(
        "${ApiConstants.baseUrl}${ApiConstants.apiGetProfile}/$profileId",
        data: user.toMap(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating profile: $e");
      }
      return false;
    }
  }
}
