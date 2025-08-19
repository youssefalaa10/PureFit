class TrackStepsModel {
  TrackStepsModel(this.id, {required this.steps, required this.date});

  factory TrackStepsModel.fromMap(Map<String, dynamic> map) {
    return TrackStepsModel(
      _parseInt(map['ID']),
      steps: _parseInt(map['STEPS']),
      date: map['DATE']?.toString() ?? '',
    );
  }
  final int id;
  final int steps;
  final String date;

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
