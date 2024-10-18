import '../../Data/Model/diet_model.dart';

abstract class DrinksState {
  List<Object> get props => [];
}

class DrinksInitial extends DrinksState {}

class DrinksLoading extends DrinksState {}

class DrinksSuccess extends DrinksState {
  final List<DietModel> drinks;

  DrinksSuccess(this.drinks);

  @override
  List<Object> get props => [drinks];
}

class DrinksError extends DrinksState {
  final String message;

  DrinksError(this.message);

  @override
  List<Object> get props => [message];
}
