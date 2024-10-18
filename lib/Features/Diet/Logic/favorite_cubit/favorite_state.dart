part of 'favorite_cubit.dart';

abstract class FavoriteState {
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteModel> favoriteItems; 

  FavoriteLoaded(this.favoriteItems);
  
  @override
  List<Object?> get props => [favoriteItems];
}

class FavoriteAdded extends FavoriteState {}

class FavoriteRemoved extends FavoriteState {}
class FavoriteEmpty extends FavoriteState {}
class FavoriteError extends FavoriteState {
  final String errorMessage;

  FavoriteError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
