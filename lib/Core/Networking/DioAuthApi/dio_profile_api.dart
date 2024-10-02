import 'package:dio/dio.dart';
import 'package:fitpro/Core/Shared/api_constans.dart';
import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';

class DioProfileApi {
  final Dio _dio;

  DioProfileApi({required Dio dio}) : _dio = dio;

  Future<UserModel?> getProfile() async {
    try {
      final token = await SaveTokenDB.getToken();
      final response = await _dio.get(
        "${ApiConstans.baseUrl}${ApiConstans.apiGetProfile}",
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
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<bool> updateProfile(UserModel user, String profileId) async {
    try {
      final token = await SaveTokenDB.getToken();
      final response = await _dio.put(
        "${ApiConstans.baseUrl}${ApiConstans.apiGetProfile}/$profileId",
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
      print("Error updating profile: $e");
      return false;
    }
  }
}
