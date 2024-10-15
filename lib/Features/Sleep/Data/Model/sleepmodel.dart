class SleepSession {
  final int? id;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int duration; // Duration in minutes

  SleepSession({
    this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bedtime': bedtime.toIso8601String(),
      'wake_time': wakeTime.toIso8601String(),
      'duration': duration,
    };
  }

  factory SleepSession.fromMap(Map<String, dynamic> map) {
    return SleepSession(
      id: map['id'],
      bedtime: DateTime.parse(map['bedtime']),
      wakeTime: DateTime.parse(map['wake_time']),
      duration: map['duration'],
    );
  }
}
