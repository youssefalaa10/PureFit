import '../../Data/Model/diet_model.dart';

abstract class FoodsState {}

class FoodsInitial extends FoodsState {}

class FoodsLoading extends FoodsState {}

class FoodsSuccess extends FoodsState {
  FoodsSuccess(this.foods);
  final List<DietModel> foods;
}

class FoodsError extends FoodsState {
  FoodsError(this.message);
  final String message;
}
