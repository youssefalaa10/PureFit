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

  Future<void> insertFavorite(FavoriteModel favorite) async {
    await favoriteRepo.insertFavoriteLocally(favorite);
  }

  Future<void> removeFavorite(String dietItemId) async {
    await favoriteRepo.removeFavoriteLocally(dietItemId);
  }

  // Toggle favorite status locally
  Future<void> toggleFavorite(
      String dietItemId, FavoriteModel favoriteModel,
      bool? isFavorite,
      ) async {
    isFavorite = !isFavorite!;
    await favoriteRepo.updateFavoriteStatus(dietItemId, isFavorite);

    if (isFavorite == true) {

      await insertFavorite(favoriteModel);

      emit(FavoriteAdded());
    } else {
      await removeFavorite(dietItemId);

      emit(FavoriteRemoved());
    }
    await loadFavorites(); // Reload to refresh state
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
