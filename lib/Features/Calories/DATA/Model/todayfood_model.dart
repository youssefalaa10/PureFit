class TodayFoodModel {
  final String id;
  final String name;
  final int calories;
  final double fats;
  final double protein;
  final String image;
  final String amount;

  TodayFoodModel(
      {required this.amount,
      required this.id,
      required this.name,
      required this.calories,
      required this.fats,
      required this.protein,
      required this.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'calories': calories,
      'fats': fats,
      'protein': protein,
      'amount': amount,
      'image': image,
    };
  }

  factory TodayFoodModel.fromMap(Map<String, dynamic> map) {
    return TodayFoodModel(
      amount: map['amount'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      calories: map['calories'] as int,
      fats: map['fats'] as double,
      protein: map['protein'] as double,
      image: map['image'] as String,
    );
  }
}
