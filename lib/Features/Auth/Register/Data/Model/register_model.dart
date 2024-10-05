class RegisterModel {
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

  RegisterModel(
      {
      // required this.userId,
      required this.password,
      required this.userName,
      required this.userEmail,
      required this.age,
      required this.userHeight,
      required this.userWeight,
      required this.gender,
      this.goalSteps,
      this.image});

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
      'image': image
    };
  }
}
