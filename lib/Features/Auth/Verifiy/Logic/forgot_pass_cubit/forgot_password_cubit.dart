import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repo/forgot_password_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repo) : super(ForgotPasswordInitial());
  final ForgotPasswordRepo _repo;

  Future<void> sendCode(String email) async {
    try {
      emit(ForgotPasswordLoading());

      await _repo.sendCode(email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
