// class ExercisesModel {
//   final String id;
//   final String name;
//   final String duration;
//   final int caloriesBurned;

//   ExercisesModel({
//     required this.id,
//     required this.name,
//     required this.duration,
//     required this.caloriesBurned,
//   });

//   factory ExercisesModel.fromJson(Map<String, dynamic> json) {
//     return ExercisesModel(
//       id: json['_id'],
//       name: json['name'],
//       duration: json['duration'],
//       caloriesBurned: json['caloriesBurned'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'duration': duration,
//       'caloriesBurned': caloriesBurned,
//     };
//   }
// }
