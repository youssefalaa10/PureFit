class RegisterModel {
  // Optional userId for future use (commented out for now)
  // final String userId;
  final String userEmail;
  final String password;
  final String userName;
  final int age;
  final int userHeight;
  final int userWeight;
  final String gender;
  final int? goalSteps;
  final String? image;
  final String? activity;
  final String? goal;

  // Constructor with required parameters
  RegisterModel({
    // required this.userId,
    this.activity,
    this.goal,
    required this.password,
    required this.userName,
    required this.userEmail,
    required this.age,
    required this.userHeight,
    required this.userWeight,
    required this.gender,
    this.goalSteps,
    this.image,
  });

  // Convert the RegisterModel to a map for storage or transmission
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'userId': userId,
      'password': password,
      'userEmail': userEmail,
      'userName': userName,
      'age': age,
      'userHeight': userHeight,
      'userWeight': userWeight,
      'gender': gender,
      'goalSteps': goalSteps,
      'image': image,
      'activity': activity,
      'goal': goal,
    };
  }

  // Method to create a copy of the RegisterModel with updated fields
  RegisterModel copyWith({
    String? userEmail,
    String? password,
    String? userName,
    int? age,
    int? userHeight,
    int? userWeight,
    String? gender,
    int? goalSteps,
    String? image,
  }) {
    return RegisterModel(
      // userId: this.userId, // Uncomment if using userId
      userEmail: userEmail ?? this.userEmail,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      userHeight: userHeight ?? this.userHeight,
      userWeight: userWeight ?? this.userWeight,
      gender: gender ?? this.gender,
      goalSteps: goalSteps ?? this.goalSteps,
      image: image ?? this.image,
    );
  }

  // Basic validation methods
  bool isValid() {
    return userEmail.isNotEmpty &&
        password.isNotEmpty &&
        userName.isNotEmpty &&
        age >= 9 &&
        userHeight > 0 &&
        userWeight > 0 &&
        gender.isNotEmpty;
  }

  // Optional method to validate email format
  bool isEmailValid() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(userEmail);
  }
}
