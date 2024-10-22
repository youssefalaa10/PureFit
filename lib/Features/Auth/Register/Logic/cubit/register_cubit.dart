import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Auth/Register/Logic/cubit/register_state.dart';
import '../../Data/Model/register_model.dart';
import '../../Data/Repo/register_repo.dart';

// Enhanced RegisterCubit
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  String? password;
  String? userName;
  String? userEmail;
  int? age = 9;
  int? userHeight = 170;
  int? userWeight = 58;
  String? gender = "male";
  String? goal;
  String? activity;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  // Validate the registration fields

  // Perform the registration
  Future<void> doRegister() async {
    final registerModel = RegisterModel(
        userEmail: userEmail!,
        password: password!,
        userName: userName!,
        age: age!,
        userHeight: userHeight!,
        userWeight: userWeight!,
        gender: gender!,
        goal: goal ?? 'fat lose',
        activity: activity ?? ' ',
        image: "");

    try {
      emit(RegisterLoading());
      final success = await registerRepo.doRegister(registerModel);
      if (success) {
        emit(RegisterSuccess());
      }
    } catch (e) {
      emit(RegisterFailure(message: "An error occurred: ${e.toString()}"));
    }
  }
}
