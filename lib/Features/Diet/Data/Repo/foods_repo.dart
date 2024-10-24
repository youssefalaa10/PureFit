import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_food_api.dart';
import '../Model/diet_model.dart';

class FoodsRepo {
  final DioFoodsApi dioFoodsApi;

  FoodsRepo({required this.dioFoodsApi});
  Future<List<DietModel>?> getFoods() async {
    try {
      final foodsJson = await dioFoodsApi.getFoods();
      if (foodsJson != null) {
        return foodsJson.map((json) => DietModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in FoodsRepo: $e");
      }
    }
    return null;
  }

  Future<List<DietModel>?> getFavouriteFoods(String id) async {
    try {
      final foodsJson = await dioFoodsApi.getFavouriteFoods(id);
      if (foodsJson != null) {
        return foodsJson.map((json) => DietModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in FoodsRepo: $e");
      }
    }
    return null;
  }
}
