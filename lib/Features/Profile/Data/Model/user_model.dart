import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.age,
    required this.userHeight,
    required this.userWeight,
    required this.gender,
    this.activity,
    this.goal,
    this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['id']?.toString() ?? '',
      userEmail: map['userEmail']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      age: _parseInt(map['age']),
      userHeight: _parseInt(map['userHeight']),
      userWeight: _parseInt(map['userWeight']),
      gender: map['gender']?.toString() ?? '',
      image: map['image']?.toString(),
      activity: map['activity']?.toString(),
      goal: map['goal']?.toString(),
    );
  }
  final String userId;
  final String userEmail;
  final String userName;
  final int age;
  final int userHeight;
  final int userWeight;
  final String gender;
  final String? image;
  final String? activity;
  final String? goal;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'age': age,
      'userHeight': userHeight,
      'userWeight': userWeight,
      'gender': gender,
      'image': image,
      'activity': activity,
      'goal': goal,
      // Add other fields as needed'
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) {
      return value.toInt();
    }
    return 0;
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
      return UserModel.fromMap(userMap);
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
    String? password,
    String? userId,
    String? userEmail,
    String? userName,
    int? age,
    int? userHeight,
    int? userWeight,
    String? gender,
    String? image,
    final String? activity,
    final String? goal,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      userHeight: userHeight ?? this.userHeight,
      userWeight: userWeight ?? this.userWeight,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      activity: activity ?? this.activity,
      goal: goal ?? this.goal,
    );
  }
}
