import 'package:PureFit/Features/Water/Data/Model/water_model.dart';
import 'package:PureFit/Features/Water/Data/Repo/water_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/helpers/app_logger.dart';
import '../../../../Core/Services/goal_tracking_service.dart';

part 'water_intake_state.dart';

class WaterIntakeCubit extends Cubit<WaterIntakeState> {
  WaterIntakeCubit(this.waterRepo) : super(WaterIntakeInitial());
  final WaterRepo waterRepo;

  Future<void> fetchTodayIntake() async {
    try {
      emit(WaterIntakeLoading());
      // Fetch today's intake from the database
      final int todayIntake = await waterRepo.getTodayIntake();
      final List<WaterIntake> allIntakes = await waterRepo.getHistoryIntakes();
      emit(WaterIntakeSuccess(allIntakes, todayIntake));
    } catch (e) {
      AppLogger.error('error in fetchTodayIntake', e, StackTrace.current);
      emit(WaterIntakeFailure('Failed to load water intake data'));
    }
  }

  Future<void> addWaterIntake(int intakeAmount) async {
    try {
      emit(WaterIntakeLoading());
      await waterRepo.inserOrUpdateIntake(intakeAmount);
      await fetchTodayIntake(); // Refresh data after updating intake

      // Check if water goal is reached and send celebration (only once per day)
      await _checkWaterGoalAchievement();
    } catch (e) {
      emit(WaterIntakeFailure('Failed to update water intake'));
    }
  }

  /// Check if water goal is achieved and send celebration notification
  Future<void> _checkWaterGoalAchievement() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int waterGoal = prefs.getInt('waterGoal') ?? 2; // Default 2 liters
      final int todayIntake = await waterRepo.getTodayIntake();

      await GoalTrackingService.checkWaterGoalAchievement(
          todayIntake, waterGoal);
    } catch (e) {
      AppLogger.error(
          'Error checking water goal achievement: $e', StackTrace.current);
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
