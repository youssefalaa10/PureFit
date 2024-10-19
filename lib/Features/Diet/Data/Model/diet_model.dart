import 'base_diet_model.dart';

class DietModel implements BaseDietModel {
  @override
  final String id;
  @override
  final String name;
  @override
  final int calories;
  @override
  final double protein;
  @override
  final double fats;
  @override
  final String image;

  DietModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.image,
  });

  // Default implementation for isFavorite
  @override
  bool get isFavorite => false;

  factory DietModel.fromJson(Map<String, dynamic> json) {
    return DietModel(
      id: json["_id"],
      name: json["name"],
      calories: json["calories"],
      protein: (json["protein"] is int)
          ? (json["protein"] as int).toDouble()
          : json["protein"] as double,
      fats: (json["fats"] is int)
          ? (json["fats"] as int).toDouble()
          : json["fats"] as double,
      image: json["image"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "calories": calories,
      "protein": protein,
      "fats": fats,
      "image": image,
      // isFavorite is not included in DietModel's JSON representation
    };
  }
}
