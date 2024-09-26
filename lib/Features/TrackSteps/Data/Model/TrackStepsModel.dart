class TrackStepsModel {
  final int id;
  final int steps;
  final String date;

  TrackStepsModel(this.id, {required this.steps, required this.date});

  factory TrackStepsModel.fromMap(Map<String, dynamic> map) {
    return TrackStepsModel(
      map['ID'] as int,
      steps: map['STEPS'] as int,
      date: map['DATE'] as String,
    );
  }
}
