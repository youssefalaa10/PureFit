import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Diet/Data/Model/diet_model.dart';

import '../../Data/Repo/drinks_repo.dart'; // Import the DrinksRepo
import 'drinks_state.dart'; // Import the state classes for drinks

class DrinksCubit extends Cubit<DrinksState> {
  final DrinksRepo drinksRepo;
  List<DietModel> allDrinks = []; // Store all drinks
  List<DietModel> filteredDrinks = []; // Store filtered drinks

  DrinksCubit(this.drinksRepo) : super(DrinksInitial());

  // Fetch drinks from the repository
  fetchDrinks() async {
    emit(DrinksLoading());
    try {
      final drinks = await drinksRepo.getDrinks();
      if (drinks != null && drinks.isNotEmpty) {
        allDrinks = drinks; // Save the fetched drinks
        filteredDrinks = drinks; // Initialize filtered drinks with all drinks
        if (!isClosed) {
          emit(DrinksSuccess(filteredDrinks));
        }
      } else {
        if (!isClosed) {
          emit(DrinksError("No drinks found"));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(DrinksError("Failed to load drinks: $e"));
      }
    }
  }

  // Search for drinks based on the query
  void searchDrinks(String query) {
    if (query.isEmpty) {
      filteredDrinks = allDrinks; // Reset to all drinks if query is empty
    } else {
      filteredDrinks = allDrinks.where((drink) {
        return drink.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    emit(DrinksSuccess(filteredDrinks)); // Emit the filtered drinks
  }
}
