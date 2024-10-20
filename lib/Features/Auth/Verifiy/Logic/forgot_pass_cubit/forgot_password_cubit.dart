import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repo/forgot_password_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepo _repo;

  ForgotPasswordCubit(this._repo) : super(ForgotPasswordInitial());

  Future<void> sendCode(String email) async {
    emit(ForgotPasswordLoading());

    final response = await _repo.sendCode(email);

    if (response == "Verification Code Send") {
      emit(ForgotPasswordSuccess(response));
    } else {
      emit(ForgotPasswordError("Failed to send verification code."));
    }
  }
}
