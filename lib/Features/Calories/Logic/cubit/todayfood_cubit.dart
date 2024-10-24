import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Calories/DATA/Model/todayfood_model.dart';
import 'package:PureFit/Features/Calories/DATA/Repo/todayfood_repo.dart';

part 'todayfood_state.dart';

class TodayfoodCubit extends Cubit<TodayfoodState> {
  final TodayfoodRepo todayfoodRepo;
  TodayfoodCubit(this.todayfoodRepo) : super(TodayfoodInitial());

  void getFoodToday() async {
    try {
      emit(TodayfoodLoading());
      final todayFoods = await todayfoodRepo.getFoodToday();
      final totalCalories =
          todayFoods.fold(0.0, (sum, item) => sum + item.calories);
      final totalProtein =
          todayFoods.fold(0.0, (sum, item) => sum + item.protein);
      final totalFats = todayFoods.fold(0.0, (sum, item) => sum + item.fats);

      emit(TodayfoodLoaded(
        todayFoods: todayFoods,
        totalCalories: totalCalories,
        totalProtein: totalProtein,
        totalFats: totalFats,
      ));
    } catch (e) {
      emit(TodayfoodError("Failed to load food data"));
    }
  }

  void removeFoodToday(String dietItemId) async {
    try {
      await todayfoodRepo.removeFoodToday(dietItemId);
      getFoodToday(); // Refresh the data after deletion
    } catch (e) {
      emit(TodayfoodError("Failed to remove food item"));
    }
  }

  resetDB() async {
    final now = DateTime.now();
    await AndroidAlarmManager.oneShotAt(
      DateTime(now.year, now.month, now.day, 24, 0),
      0, // unique ID for this alarm
      clearetoday, // The callback function that runs
      // The callback function that runs
      exact: true,
      wakeup: true,
    );
  }

  Future<void> clearetoday() async {
    await todayfoodRepo.resetData();
    getFoodToday(); // Refresh data after reset
  }
}
