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
    age: 0,
    userHeight: 0,
    userWeight: 0,
    gender: "",
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
  String? validateFields() {
    if (registerModel.userEmail.isEmpty) {
      return "Email cannot be empty.";
    } else if (registerModel.password.isEmpty) {
      return "Password cannot be empty.";
    } else if (registerModel.userName.isEmpty) {
      return "User name cannot be empty.";
    } else if (registerModel.age < 9) {
      return "Age must be at least 9.";
    } else if (registerModel.userHeight <= 0) {
      return "Height must be greater than 0.";
    } else if (registerModel.userWeight <= 0) {
      return "Weight must be greater than 0.";
    } else if (registerModel.gender.isEmpty) {
      return "Gender must be specified.";
    }
    return null; // All fields are valid
  }

  // Perform the registration
  Future<void> doRegister() async {
    emit(RegisterLoading());

    print(registerModel.userHeight);
    // Validate the fields before proceeding
    final error = validateFields();
    if (error != null) {
      emit(RegisterFailure(message: error));
      return; // Exit if validation fails
    }

    try {
      final success = await registerRepo.doRegister(registerModel);
      if (success) {
        emit(RegisterSuccess());
      } else {
        emit(
            RegisterFailure(message: "Registration failed. Please try again."));
      }
    } catch (e) {
      emit(RegisterFailure(message: "An error occurred: ${e.toString()}"));
    }
  }
}
