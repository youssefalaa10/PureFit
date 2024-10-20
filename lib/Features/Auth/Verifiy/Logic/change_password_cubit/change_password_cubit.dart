import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repo/change_password_repo.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo _repo;

  ChangePasswordCubit(this._repo) : super(ChangePasswordInitial());

  Future<void> changePassword(String email, String newPassword, context) async {
    try {
      emit(ChangePasswordLoading());

      final response = await _repo.changePassword(email, newPassword);

      if (response == "Password Changed Successfully") {
        emit(ChangePasswordSuccess(response));
      } else {
        emit(ChangePasswordError(response));
      }
    } catch (e) {
      emit(ChangePasswordError("An error occurred: $e"));
    }
  }
}
