import 'package:fitpro/Core/Networking/Dio/dio_verification_api.dart';

class VerificationRepo {
  final DioVerificationApi _api;

  VerificationRepo(this._api);

  Future<String> verifyCode(String email, String code) async {
    return await _api.verifyCode(email, code);
  }
}
