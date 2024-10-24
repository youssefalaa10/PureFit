import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Water/Data/Model/water_model.dart';
import 'package:PureFit/Features/Water/Data/Repo/water_repo.dart';

part 'water_intake_state.dart';

class WaterIntakeCubit extends Cubit<WaterIntakeState> {
  final WaterRepo waterRepo;

  WaterIntakeCubit(this.waterRepo) : super(WaterIntakeInitial());

  Future<void> fetchTodayIntake() async {
    try {
      emit(WaterIntakeLoading());
      // Fetch today's intake from the database
      int todayIntake = await waterRepo.getTodayIntake();
      List<WaterIntake> allIntakes = await waterRepo.getHistoryIntakes();
      emit(WaterIntakeSuccess(allIntakes, todayIntake));
    } catch (e) {
      print("error");
      emit(WaterIntakeFailure("Failed to load water intake data"));
    }
  }

  Future<void> addWaterIntake(int intakeAmount) async {
    try {
      emit(WaterIntakeLoading());
      await waterRepo.inserOrUpdateIntake(intakeAmount);
      await fetchTodayIntake(); // Refresh data after updating intake
    } catch (e) {
      emit(WaterIntakeFailure("Failed to update water intake"));
    }
  }

  // Delete a specific intake by ID and refresh the list
  // Future<void> deleteIntake(int id) async {
  //   try {
  //     emit(WaterIntakeLoading());
  //     await waterRepo.deleteIntake(id);
  //     await fetchTodayIntake(); // Refresh data after deletion
  //   } catch (e) {
  //     emit(WaterIntakeFailure("Failed to delete intake"));
  //   }
  // }
}
