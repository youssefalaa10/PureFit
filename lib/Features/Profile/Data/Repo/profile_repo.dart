import 'package:PureFit/Features/Profile/Data/Model/user_model.dart';

import '../../../../Core/Networking/Dio/dio_profile_api.dart';

class ProfileRepo {
  ProfileRepo({required this.dioProfileApi});
  final DioProfileApi dioProfileApi;

  Future<UserModel?> getProfile() async {
    return await dioProfileApi.getProfile();
  }

  Future<bool> updateProfile(UserModel user, String profileId) async {
    return await dioProfileApi.updateProfile(user, profileId);
  }
}
