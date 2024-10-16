import 'package:fitpro/Features/Diet/Data/Model/foods_model.dart';

abstract class FoodsState {
}

class FoodsInitial extends FoodsState {}

class FoodsLoading extends FoodsState {}

class FoodsSuccess extends FoodsState {
  final List<FoodsModel> foods;

  FoodsSuccess(this.foods);
}

class FoodsError extends FoodsState {
  final String message;

  FoodsError(this.message);
}

