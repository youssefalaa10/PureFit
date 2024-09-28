import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String userId;
  final String userEmail;
  final String userName;
  final int age;
  final int userHeight;
  final int userWeight;
  final String gender;
  final int goalSteps;
  
  UserModel({
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.age,
      required this.userHeight,
      required this.userWeight,
      required this.gender,
      required this.goalSteps,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'age': age,
      'userHeight': userHeight,
      'userWeight': userWeight,
      'gender': gender,
      'goalSteps': goalSteps,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,String userId) {
    return UserModel(
      userId: userId,
      userEmail: map['userEmail'] as String,
      userName: map['userName'] as String,
      age: map['age'] as int,
      userHeight: map['userHeight'] as int,
      userWeight: map['userWeight'] as int,
      gender: map['gender'] as String,
      goalSteps: map['goalSteps'] as int,
    );
  }
  // Save the UserModel to SharedPreferences as a JSON string
  Future<void> saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(toMap());
    await prefs.setString('userModel', userJson);
  }

  // Load the UserModel from SharedPreferences
  static Future<UserModel?> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userModel');
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromMap(userMap, userMap['userId']);
    }
    return null;
  }

  // Clear the UserModel from SharedPreferences
  static Future<void> clearFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userModel');
  }

  
// Create a copy of a UserModel with updated fields
  UserModel copyWith({
    String? userId,
    String? userEmail,
    String? userName,
    int? age,
    int? userHeight,
    int? userWeight,
    String? gender,
    int? goalSteps,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      userHeight: userHeight ?? this.userHeight,
      userWeight: userWeight ?? this.userWeight,
      gender: gender ?? this.gender,
      goalSteps: goalSteps ?? this.goalSteps,
    );
  }
}
