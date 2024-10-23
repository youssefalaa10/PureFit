part of 'todayfood_cubit.dart';

sealed class TodayfoodState {}

final class TodayfoodInitial extends TodayfoodState {}

final class TodayfoodLoading extends TodayfoodState {}

final class TodayfoodLoaded extends TodayfoodState {
  final List<TodayFoodModel> todayFoods;
  final double totalCalories;
  final double totalProtein;
  final double totalFats;

  TodayfoodLoaded({
    required this.todayFoods,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFats,
  });
}

final class TodayfoodError extends TodayfoodState {
  final String message;

  TodayfoodError(this.message);
}