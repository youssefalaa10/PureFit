import 'base_diet_model.dart';

class FavoriteModel implements BaseDietModel {
  @override
  final String id;
  int? localId;
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
  
  // Use a constructor parameter to determine if it's a favorite
  @override
  final bool isFavorite; // Now this holds the actual favorite state

  FavoriteModel({
    this.localId,
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.image,
    required this.isFavorite, // Capture the isFavorite state
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json['id'], // Auto-generated
        localId: json['localId'],
        name: json["name"],
        calories: json["calories"],
        protein: (json["protein"] is int) ? (json["protein"] as int).toDouble() : json["protein"] as double,
        fats: (json["fats"] is int) ? (json["fats"] as int).toDouble() : json["fats"] as double,
        image: json["image"], 
        isFavorite: json['isFavorite'] == 1, // Convert 1 or 0 to boolean
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "calories": calories,
        "protein": protein,
        "fats": fats,
        "image": image,
        "isFavorite": isFavorite ? 1 : 0,
      };
}
