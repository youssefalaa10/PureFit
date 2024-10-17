class FavoritesModel {
  final List<String> favoriteFoods; // List of food IDs
  final List<String> favoriteDrinks; // List of drink IDs

  FavoritesModel({
    required this.favoriteFoods,
    required this.favoriteDrinks,
  });

  // Factory method to create a FavoritesModel object from JSON
  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      favoriteFoods: List<String>.from(json["favoriteFoods"] ?? []),
      favoriteDrinks: List<String>.from(json["favoriteDrinks"] ?? []),
    );
  }

  // Method to convert a FavoritesModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      "favoriteFoods": favoriteFoods,
      "favoriteDrinks": favoriteDrinks,
    };
  }
}
