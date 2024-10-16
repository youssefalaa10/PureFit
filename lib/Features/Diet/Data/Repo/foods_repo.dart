import 'package:fitpro/Features/Diet/Data/Model/foods_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_food_api.dart';

class FoodsRepo {
  final DioFoodsApi dioFoodsApi;

  FoodsRepo({required this.dioFoodsApi});
  Future<List<FoodsModel>?> getFoods() async {
    try {
      final foodsJson = await dioFoodsApi.getFoods();
      if (foodsJson != null) {
        return foodsJson.map((json) => FoodsModel.fromJson(json)).toList();
      }
    }
    catch (e) {
      if (kDebugMode) {
        print("Error in FoodsRepo: $e");
      }
    }
    return null;
  }
}
