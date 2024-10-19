import 'package:bloc/bloc.dart';
import '../../Data/Model/diet_model.dart';
import '../../Data/Repo/foods_repo.dart';
import 'foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final FoodsRepo foodsRepo;
  List<DietModel> allFoods = []; // Store all foods
  List<DietModel> filteredFoods = []; // Store filtered foods

  FoodsCubit(this.foodsRepo) : super(FoodsInitial());

  Future<void> fetchFoods() async {
    emit(FoodsLoading());
    try {
      // Fetch all foods and favorites
      final foods = await foodsRepo.getFoods();
      // final favoriteIds = await foodsRepo.getFavouriteFoods(); // Fetch favorite IDs

      if (foods != null && foods.isNotEmpty) {
        
        // Set allFoods and mark favorites
        allFoods = foods.map((food) {
          return DietModel(
            id: food.id,
            name: food.name,
            calories: food.calories,
            protein: food.protein,
            fats: food.fats,
            image: food.image,
            isFavorite: false, // Mark favorite
          );
        }).toList();

        // Initialize filteredFoods with all foods
        filteredFoods = allFoods;
        emit(FoodsSuccess(filteredFoods));
      } else {
        emit(FoodsError("No foods found"));
      }
    } catch (e) {
      emit(FoodsError("Failed to load foods: $e"));
    }
  }

  void searchFoods(String query) {
    if (query.isEmpty) {
      filteredFoods = allFoods; // Reset to all foods if query is empty
    } else {
      filteredFoods = allFoods.where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    emit(FoodsSuccess(filteredFoods)); // Emit the filtered foods
  }
}
