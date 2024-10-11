import 'package:bloc/bloc.dart';
import 'package:fitpro/Core/local_db/DioSavedToken/save_token.dart';

import '../../Data/Model/login_model.dart';
import '../../Data/Repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginInitial());

  doLogin(LoginModel userlogin) async {
    try {
      emit(LoginLoading());
      SaveTokenDB.clearToken();
      String? token = await SaveTokenDB.getToken();
      if (token != null || token!.isNotEmpty) {
        emit(LoginSuccess());
      } else {}
      await loginRepo.doLogin(userlogin);
    } catch (e) {
      emit(LoginFaliuer(message: e.toString()));
    }
  }
}
