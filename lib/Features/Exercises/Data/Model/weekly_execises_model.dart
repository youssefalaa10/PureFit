class WeeklyExerciseModel {
  WeeklyExerciseModel({
    required this.profileId,
    required this.weeks,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
  });

  // Factory method to parse the JSON and create a WeeklyExerciseModel instance
  factory WeeklyExerciseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Week> weeksMap = {};

    // Convert weeks into Week objects
    json['weeks'].forEach((weekKey, weekData) {
      if (weekData is Map<String, dynamic> && weekKey != '_id') {
        weeksMap[weekKey] = Week.fromJson(weekData);
      }
    });

    return WeeklyExerciseModel(
      profileId: json['profileId'],
      weeks: weeksMap,
      createdAt: DateTime.parse(json['createdAt']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
  final String profileId;
  final Map<String, Week> weeks;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
}

class Week {
  Week({required this.id, required this.days});

  // Factory method to parse each week
  factory Week.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> daysMap = {};

    // Convert day values
    json.forEach((dayKey, dayValue) {
      if (dayKey.startsWith('day')) {
        daysMap[dayKey] = dayValue;
      }
    });

    return Week(
      id: json['_id'],
      days: daysMap,
    );
  }
  final String id;
  final Map<String, bool> days;

  // Method to update a specific day in the week
  void updateDay(String day, bool value) {
    if (days.containsKey(day)) {
      days[day] = value;
    }
  }
}
