import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Auth/Register/Logic/cubit/register_state.dart';
import '../../Data/Model/register_model.dart';
import '../../Data/Repo/register_repo.dart';

// Enhanced RegisterCubit
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterModel registerModel = RegisterModel(
    password: "",
    userName: "",
    userEmail: "",
    age: 9,
    userHeight: 170,
    userWeight: 58,
    gender: "male",
  );

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  // Update user data in the model
  void updateUserEmail(String email) {
    registerModel = registerModel.copyWith(userEmail: email);
  }

  void updatePassword(String password) {
    registerModel = registerModel.copyWith(password: password);
  }

  void updateUserName(String userName) {
    registerModel = registerModel.copyWith(userName: userName);
  }

  void updateAge(int age) {
    registerModel = registerModel.copyWith(age: age);
  }

  void updateHeight(int height) {
    registerModel = registerModel.copyWith(userHeight: height);
  }

  void updateWeight(int weight) {
    registerModel = registerModel.copyWith(userWeight: weight);
  }

  void updateGender(String gender) {
    registerModel = registerModel.copyWith(gender: gender);
  }

  // Validate the registration fields

  // Perform the registration
  Future<void> doRegister() async {
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
