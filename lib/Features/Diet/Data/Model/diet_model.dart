class DietModel {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double fats;
  final String image;

  DietModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.image,
  });

  // Factory method to create a Food object from JSON
  factory DietModel.fromJson(Map<String, dynamic> json) {
    return DietModel(
      id: json["_id"],
      name: json["name"],
      calories: json["calories"],
      // Cast to double if the API returns int
      protein: (json["protein"] is int)
          ? (json["protein"] as int).toDouble()
          : json["protein"] as double,
      fats: (json["fats"] is int)
          ? (json["fats"] as int).toDouble()
          : json["fats"] as double,
      image: json["image"],
    );
  }

  // Method to convert a Food object to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "calories": calories,
      "protein": protein,
      "fats": fats,
      "image": image,
    };
  }
}
