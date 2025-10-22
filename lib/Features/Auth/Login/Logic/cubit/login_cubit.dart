import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:bloc/bloc.dart';

import '../../Data/Model/login_model.dart';
import '../../Data/Repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());
  final LoginRepo loginRepo;

  Future<void> doLogin(LoginModel userlogin) async {
    emit(LoginLoading());
    try {
      final bool ok = await loginRepo.doLogin(userlogin);
      if (ok) {
        final String? token = await SaveTokenDB.getToken();
        if (token != null && token.isNotEmpty) {
          // Refresh profile right after login so userId is available
          try {
            final profileCubit = getIT<ProfileCubit>();
            await profileCubit.getProfile();
          } catch (_) {}
          emit(LoginSuccess());
        } else {
          emit(LoginFaliuer(message: 'Invalid token'));
        }
      } else {
        await SaveTokenDB.clearToken();
        emit(LoginFaliuer(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginFaliuer(message: e.toString()));
    }
  }
}
