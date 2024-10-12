class Exercise {
  final String categoryId;
  final String equipment;
  final String? gifUrl;
  final int id;
  final String name;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  Exercise({
    required this.categoryId,
    required this.equipment,
    required this.gifUrl,
    required this.id,
    required this.name,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
  });

  // Factory method to parse JSON data into an Exercise object
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      categoryId: json['categoryId'],
      equipment: json['equipment'],
      gifUrl: json['gifUrl']??'data:image/png;base64,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',
      id: json['id'],
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
      'id': id,
      'name': name,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }
}
