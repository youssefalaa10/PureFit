import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Signup/Data/Model/regsetier_model.dart';
import 'package:fitpro/Features/Signup/Data/Repo/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;
  SignupCubit(this.signupRepo) : super(SignupInitial());

  doSignup(RegisterModel user) async {
    emit(SignupLoading());
    try {
      await signupRepo.doRegister(user);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFaliuer(message: e.toString()));
    }
  }
}
