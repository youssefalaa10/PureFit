import 'package:bloc/bloc.dart';
import '../../Data/Model/favorites_model.dart';
import '../../Data/Repo/favorite_repo.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo favoriteRepo;

  FavoriteCubit({required this.favoriteRepo}) : super(FavoriteInitial());

  // Load favorites from the local database
  Future<void> loadFavorites() async {
    emit(FavoriteLoading()); // Emit loading state before fetching
    final favorites = await favoriteRepo.fetchFavoritesLocally();

    if (favorites.isNotEmpty) {
      emit(FavoriteLoaded(favorites));
    } else {
      emit(FavoriteEmpty());
    }
  }

  Future<void> toggleFavorite(
    String dietItemId,
    FavoriteModel favoriteModel,
    bool isFavorite, // Use non-nullable bool
  ) async {
    // Toggle the favorite status
    isFavorite = !isFavorite;

    // Use copyWith to update the isFavorite field only
    final updatedFavorite = favoriteModel.copyWith(isFavorite: isFavorite);

    // Update the favorite status in the repository
    await favoriteRepo.updateFavoriteStatus(dietItemId, isFavorite);

    if (isFavorite) {
      // Insert the updated favorite model
      await favoriteRepo.insertFavoriteLocally(updatedFavorite);
      emit(FavoriteAdded());
    } else {
      // Remove the favorite if isFavorite is false
      await favoriteRepo.removeFavoriteLocally(dietItemId);
      emit(FavoriteRemoved());
    }

    // Reload the favorites list to reflect changes
    await loadFavorites();
  }

  // Sync local changes with the API
  // Future<void> syncFavoriteWithApi(String dietItemId) async {
  //   if (isFavorite == true) {
  //     await favoriteRepo.syncFavoritesWithApi(dietItemId, true);
  //   } else {
  //     await favoriteRepo.syncFavoritesWithApi(dietItemId, false);
  //   }
  // }
}
