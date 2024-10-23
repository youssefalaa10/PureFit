import 'package:fitpro/Core/local_db/EatToday/today_calories.dart';
import 'package:fitpro/Features/Calories/DATA/Model/todayfood_model.dart';

class TodayfoodRepo {
  final TodayCaloriesDB todayCaloriesDB;
  TodayfoodRepo(this.todayCaloriesDB);

  Future<void> insertFoodToday(TodayFoodModel todayMeal) async {
    await todayCaloriesDB.insertFoodtoday(todayMeal);
  }

  getFoodToday() async {
    final foodstoday = await todayCaloriesDB.getFoodstoday();

    return foodstoday;
  }

  Future<void> removeFoodToday(String dietItemId) async {
    await todayCaloriesDB.deleteFoodtoday(dietItemId);
  }

  Future<void> resetData() async {
    await todayCaloriesDB.clearTodayFood();
  }
}
