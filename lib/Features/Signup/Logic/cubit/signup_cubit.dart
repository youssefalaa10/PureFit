import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Signup/Data/Model/regsetier_model.dart';
import 'package:fitpro/Features/Signup/Data/Repo/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;

  SignupCubit(this.signupRepo) : super(SignupInitial());

  Future<void> doSignup(RegisterModel user) async {
    emit(SignupLoading());
    try {
      final success = await signupRepo.doRegister(user);
      if (success) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(message: "Registration failed. Please try again."));
      }
    } catch (e) {
      emit(SignupFailure(message: e.toString()));
    }
  }
}
