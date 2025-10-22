import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_food_api.dart';
import '../../../../Core/helpers/app_logger.dart';
import '../Model/diet_model.dart';

class FoodsRepo {
  FoodsRepo({required this.dioFoodsApi});
  final DioFoodsApi dioFoodsApi;
  Future<List<DietModel>?> getFoods() async {
    try {
      final foodsJson = await dioFoodsApi.getFoods();
      if (foodsJson != null) {
        return foodsJson.map((json) => DietModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.log('Error in FoodsRepo: $e');
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
        AppLogger.error('Error in FoodsRepo: $e', StackTrace.current);
      }
    }
    return null;
  }
}
