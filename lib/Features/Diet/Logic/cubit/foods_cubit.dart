import 'package:bloc/bloc.dart';

import '../../Data/Repo/foods_repo.dart';
import 'foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final FoodsRepo foodsRepo;

  FoodsCubit(this.foodsRepo) : super(FoodsInitial());

  fetchFoods() async {
    emit(FoodsLoading());
    try {
      final foods = await foodsRepo.getFoods();
      if (foods != null && foods.isNotEmpty) {
        if (!isClosed) {
          emit(FoodsSuccess(foods));
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
}
