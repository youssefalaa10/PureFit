import '../../../../Core/Networking/Dio/dio_favorite_api.dart';
import '../../../../Core/local_db/food_db/food_db.dart';
import '../Model/favorites_model.dart';

class FavoriteRepo {
  final DioFavoriteApi dioFavoriteApi;
  final DietFavoriteDb dietFavoriteDb;

  FavoriteRepo({required this.dioFavoriteApi, required this.dietFavoriteDb});

  // Insert favorite item into the local database (SQFlite)
  Future<void> insertFavoriteLocally(FavoriteModel favorite) async {
    await dietFavoriteDb.insertFavorite(favorite);
  }

  // Fetch all favorite items from the local database (SQFlite)
  Future<List<FavoriteModel>> fetchFavoritesLocally() async {
    final favorites = await dietFavoriteDb.fetchFavorites();
    print('Fetched from local DB: $favorites'); // Debugging purpose
    return favorites;
  }

  // Remove a specific favorite item by id
  Future<void> removeFavoriteLocally(String dietItemId) async {
    await dietFavoriteDb
        .deleteFavorite(dietItemId); // Implement this method in DietFavoriteDb
  }

  // Sync favorites with the API
  Future<bool> syncFavoritesWithApi(String dietItemId, bool isFavorite) async {
    try {
      if (isFavorite) {
        await dioFavoriteApi.addFavorite(dietItemId);
      } else {
        await dioFavoriteApi.removeFavorite(dietItemId);
      }
      return true;
    } catch (e) {
      print("Error syncing with API: $e");
      return false;
    }
  }

  Future<void> updateFavoriteStatus(String id, bool isFavorite) async {
    await dietFavoriteDb.updateFavoriteStatus(id, isFavorite);
  }
}
