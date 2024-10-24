
import '../../Data/Model/diet_model.dart';

abstract class FoodsState {}

class FoodsInitial extends FoodsState {}

class FoodsLoading extends FoodsState {}

class FoodsSuccess extends FoodsState {
  final List<DietModel> foods;

  FoodsSuccess(this.foods);
}

class FoodsError extends FoodsState {
  final String message;

  FoodsError(this.message);
}
