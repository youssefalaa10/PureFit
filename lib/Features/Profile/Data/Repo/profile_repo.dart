import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';

import '../../../../Core/Networking/DioAuthApi/dio_profile_api.dart';

class ProfileRepo {
  final DioProfileApi dioProfileApi;

  ProfileRepo({required this.dioProfileApi});

  Future<UserModel?> getProfile() async {
    return await dioProfileApi.getProfile();
  }

  Future<bool> updateProfile(UserModel user, String profileId) async {
    return await dioProfileApi.updateProfile(user, profileId);
  }
}
