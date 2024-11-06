import 'dart:convert';

class ApiErrorModel {
  final String? message;
  final bool? success;
  ApiErrorModel({required this.message,  this.success});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'success': success,
    };
  }

  factory ApiErrorModel.fromMap(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['message'] as String,
      success: map['success'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiErrorModel.fromJson(String source) =>
      ApiErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
