import '../../Data/Model/diet_model.dart';

abstract class DrinksState {
  List<Object> get props => [];
}

class DrinksInitial extends DrinksState {}

class DrinksLoading extends DrinksState {}

class DrinksSuccess extends DrinksState {
  DrinksSuccess(this.drinks);
  final List<DietModel> drinks;

  @override
  List<Object> get props => [drinks];
}

class DrinksError extends DrinksState {
  DrinksError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
