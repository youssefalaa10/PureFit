import 'diet_model.dart';
import 'favorites_model.dart';

abstract class BaseDietModel {
  // Abstract getter for isFavorite

  factory BaseDietModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('localId')) {
      return FavoriteModel.fromJson(json);
    }
    return DietModel.fromJson(json);
  }
  String get id;
  String get name;
  int get calories;
  double get protein;
  double get fats;
  String get image;
  bool get isFavorite;

  Map<String, dynamic> toJson();
}
