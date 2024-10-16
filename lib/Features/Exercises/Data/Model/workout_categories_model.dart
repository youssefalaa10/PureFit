

class WorkoutCategoriesModel {
  final String id;
  final String thumbnail;
  final String programName;
  final String workoutName;
  final String timeOfFullProgram;
  final String level;
  final int burnedCalories;


  WorkoutCategoriesModel({
    required this.id,
    required this.thumbnail,
    required this.programName,
    required this.workoutName,
    required this.timeOfFullProgram,
    required this.level,
    required this.burnedCalories,

  });

  factory WorkoutCategoriesModel.fromJson(Map<String, dynamic> json) {



    return WorkoutCategoriesModel(
      id: json['_id'],
      thumbnail: json['thumbnail'],
      programName: json['programName'],
      workoutName: json['workoutName'],
      timeOfFullProgram: json['timeOf_FullProgram'],
      level: json['level'],
      burnedCalories: json['burnedCalories'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'thumbnail': thumbnail,
      'programName': programName,
      'workoutName': workoutName,
      'timeOf_FullProgram': timeOfFullProgram,
      'level': level,
      'burnedCalories': burnedCalories,

    };
  }
}
