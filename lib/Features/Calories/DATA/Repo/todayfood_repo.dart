import 'package:PureFit/Core/local_db/EatToday/today_calories.dart';
import 'package:PureFit/Features/Calories/DATA/Model/todayfood_model.dart';

class TodayfoodRepo {
  TodayfoodRepo(this.todayCaloriesDB);
  final TodayCaloriesDB todayCaloriesDB;

  Future<void> insertFoodToday(TodayFoodModel todayMeal) async {
    await todayCaloriesDB.insertFoodtoday(todayMeal);
  }

  Future<List<TodayFoodModel>> getFoodToday() async {
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
