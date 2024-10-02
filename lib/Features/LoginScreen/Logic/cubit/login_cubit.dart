import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';
import 'package:fitpro/Features/LoginScreen/Data/Repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginInitial());

  doLogin(LoginModel userlogin) async {
    emit(LoginLoading());
    try {
      loginRepo.doLogin(userlogin);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFaliuer(message: e.toString()));
    }
  }
}
