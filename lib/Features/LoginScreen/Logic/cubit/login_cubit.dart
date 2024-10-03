import 'package:bloc/bloc.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';
import 'package:fitpro/Features/LoginScreen/Data/Repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super (LoginInitial());

  doLogin(LoginModel userlogin) async {
    emit(LoginLoading());
    try {
      SaveTokenDB.clearToken();
      await loginRepo.doLogin(userlogin);
      String? token = await SaveTokenDB.getToken();
      if (token != null || token!.isNotEmpty) {
        print(token);
        emit(LoginSuccess());
      }
    } catch (e) {
      emit(LoginFaliuer(message: e.toString()));
    }
  }
}
