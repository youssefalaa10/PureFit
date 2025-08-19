import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:bloc/bloc.dart';

import '../../Data/Model/login_model.dart';
import '../../Data/Repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());
  final LoginRepo loginRepo;

  doLogin(LoginModel userlogin) async {
    emit(LoginLoading());
    try {
      await loginRepo.doLogin(userlogin);
      final String? token = await SaveTokenDB.getToken();
      if (token != null) {
        emit(LoginSuccess());
      }
    } catch (e) {
      emit(LoginFaliuer(message: e.toString()));
    }
  }
}
