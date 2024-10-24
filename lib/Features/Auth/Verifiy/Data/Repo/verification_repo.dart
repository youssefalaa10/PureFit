import 'package:PureFit/Core/Networking/Dio/dio_verification_api.dart';

class VerificationRepo {
  final DioVerificationApi _api;

  VerificationRepo(this._api);

  Future<void> verifyCode(String email, String code) async {
    try {
      await _api.verifyCode(email, code);
    } catch (e) {
      throw "Error verifying code";
    }
  }
}
