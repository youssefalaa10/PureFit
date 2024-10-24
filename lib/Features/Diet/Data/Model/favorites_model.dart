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
  @override
  final bool isFavorite;

  FavoriteModel({
    this.localId,
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.image,
    required this.isFavorite,
  });

  // Create a copyWith method to easily clone and modify values
  FavoriteModel copyWith({
    int? localId,
    String? id,
    String? name,
    int? calories,
    double? protein,
    double? fats,
    String? image,
    bool? isFavorite,
  }) {
    return FavoriteModel(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fats: fats ?? this.fats,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json['id'],
        localId: json['localId'],
        name: json["name"],
        calories: json["calories"],
        protein: (json["protein"] is int)
            ? (json["protein"] as int).toDouble()
            : json["protein"] as double,
        fats: (json["fats"] is int)
            ? (json["fats"] as int).toDouble()
            : json["fats"] as double,
        image: json["image"],
        isFavorite: json['isFavorite'] == 1,
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
