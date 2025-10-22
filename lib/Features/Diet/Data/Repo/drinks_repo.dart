import 'package:flutter/foundation.dart';

import '../../../../Core/Networking/Dio/dio_drink_api.dart';
import '../../../../Core/helpers/app_logger.dart';
import '../Model/diet_model.dart';

class DrinksRepo {
  DrinksRepo({required this.dioDrinksApi});
  final DioDrinksApi dioDrinksApi;

  Future<List<DietModel>?> getDrinks() async {
    try {
      final drinksJson = await dioDrinksApi.getDrinks();
      if (drinksJson != null) {
        return drinksJson.map((json) => DietModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('Error in DrinksRepo: $e', StackTrace.current);
      }
    }
    return null;
  }
}
