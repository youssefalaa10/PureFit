
import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Auth/Register/Logic/cubit/register_state.dart';

import '../../Data/Model/register_model.dart';
import '../../Data/Repo/register_repo.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;


  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> doRegister(RegisterModel user) async {
    emit(RegisterLoading());
    try {
      final success = await registerRepo.doRegister(user);
      if (success) {
        emit(RegisterSuccess());
      } else {
        emit(
            RegisterFailure(message: "Registration failed. Please try again."));
      }
    } catch (e) {
      emit(RegisterFailure(message: e.toString()));
    }
  }
}
