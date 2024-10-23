class ExerciseModel {
  final String categoryId;
  final String equipment;
  final String? gifUrl;
  // final int id;
  final String name;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  ExerciseModel({
    required this.categoryId,
    required this.equipment,
    required this.gifUrl,
    // required this.id,
    required this.name,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
  });

  // Factory method to parse JSON data into an Exercise object
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      categoryId: json['categoryId'],
      equipment: json['equipment'],
      gifUrl: json['gifUrl'],
      // id: json['id'],
      name: json['name'],
      target: json['target'],
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      instructions: List<String>.from(json['instructions']),
    );
  }

  // Method to convert Exercise object to JSON (useful if needed)
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'equipment': equipment,
      'gifUrl': gifUrl,
      // 'id': id,
      'name': name,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }
}
