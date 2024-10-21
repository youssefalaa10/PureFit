import 'package:fitpro/Core/Networking/Dio/dio_verification_api.dart';

class VerificationRepo {
  final DioVerificationApi _api;

  VerificationRepo(this._api);

  Future<void> verifyCode(String email, String code) async {
     await _api.verifyCode(email, code);
  }
}
