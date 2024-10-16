import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Diet/Data/Model/foods_model.dart';

import '../../Data/Repo/foods_repo.dart';
import 'foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final FoodsRepo foodsRepo;
  List<FoodsModel> allFoods = []; // Store all foods
  List<FoodsModel> filteredFoods = []; // Store filtered foods
  FoodsCubit(this.foodsRepo) : super(FoodsInitial());

  fetchFoods() async {
    emit(FoodsLoading());
    try {
      final foods = await foodsRepo.getFoods();
      if (foods != null && foods.isNotEmpty) {
        allFoods = foods; // Save the fetched foods
        filteredFoods = foods; // Initialize filtered foods with all foods
        if (!isClosed) {
          emit(FoodsSuccess(filteredFoods));
        }
      } else {
        if (!isClosed) {
          emit(FoodsError("No foods found"));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(FoodsError("Failed to load foods: $e"));
      }
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
