class WaterIntake {
  WaterIntake({required this.date, required this.intake, this.id});

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: _parseInt(map['id']),
      date: map['date']?.toString() ?? '',
      intake: _parseInt(map['intake']),
    );
  }
  final int? id;
  final String date;
  final int intake;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'intake': intake,
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
}
