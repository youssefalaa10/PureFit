class TodayFoodModel {
  TodayFoodModel(
      {required this.amount,
      required this.id,
      required this.name,
      required this.calories,
      required this.fats,
      required this.protein,
      required this.image});

  factory TodayFoodModel.fromMap(Map<String, dynamic> map) {
    return TodayFoodModel(
      amount: map['amount']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      calories: _parseInt(map['calories']),
      fats: _parseDouble(map['fats']),
      protein: _parseDouble(map['protein']),
      image: map['image']?.toString() ?? '',
    );
  }
  final String id;
  final String name;
  final int calories;
  final double fats;
  final double protein;
  final String image;
  final String amount;

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

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) {
      return value.toInt();
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
