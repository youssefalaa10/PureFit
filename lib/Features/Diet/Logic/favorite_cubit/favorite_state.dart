part of 'favorite_cubit.dart';

abstract class FavoriteState {
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  FavoriteLoaded(this.favoriteItems);
  final List<FavoriteModel> favoriteItems;

  @override
  List<Object?> get props => [favoriteItems];
}

class FavoriteAdded extends FavoriteState {}

class FavoriteRemoved extends FavoriteState {}

class FavoriteEmpty extends FavoriteState {}

class FavoriteError extends FavoriteState {
  FavoriteError(this.errorMessage);
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
