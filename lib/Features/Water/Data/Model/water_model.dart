class WaterIntake {
  final int? id;
  final String date;
  final int intake;

  WaterIntake({required this.id, required this.date, required this.intake});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'intake': intake,
    };
  }

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map['id'],
      date: map['date'] as String,
      intake: map['intake'] as int,
    );
  }
}
