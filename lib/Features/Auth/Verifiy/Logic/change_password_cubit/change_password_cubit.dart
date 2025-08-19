import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repo/change_password_repo.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._repo) : super(ChangePasswordInitial());
  final ChangePasswordRepo _repo;

  Future<void> changePassword(String email, String newPassword, context) async {
    try {
      emit(ChangePasswordLoading());

      await _repo.changePassword(email, newPassword);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordError('An error occurred: $e'));
    }
  }
}
