import '../../../../../Core/Networking/Dio/dio_change_password_api.dart';
import '../Model/change_password_model.dart';

class ChangePasswordRepo {
  ChangePasswordRepo(this._api);
  final DioChangePasswordApi _api;

  Future<void> changePassword(String email, String newPassword) async {
    final model = ChangePasswordModel(email: email, newPassword: newPassword);
    await _api.changePassword(model);
  }
}
