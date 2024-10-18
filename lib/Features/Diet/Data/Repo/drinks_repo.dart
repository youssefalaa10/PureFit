import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_drink_api.dart';
import '../Model/diet_model.dart';



class DrinksRepo {
  final DioDrinksApi dioDrinksApi;

  DrinksRepo({required this.dioDrinksApi});

  Future<List<DietModel>?> getDrinks() async {
    try {
      final drinksJson = await dioDrinksApi.getDrinks();
      if (drinksJson != null) {
        return drinksJson.map((json) => DietModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in DrinksRepo: $e");
      }
    }
    return null;
  }
}
