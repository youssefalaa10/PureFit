import 'dart:convert';

class ApiErrorModel {
  ApiErrorModel({required this.message, this.success});

  factory ApiErrorModel.fromMap(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['message'] as String,
      success: map['success'] as bool,
    );
  }

  factory ApiErrorModel.fromJson(String source) =>
      ApiErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String? message;
  final bool? success;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'success': success,
    };
  }

  String toJson() => json.encode(toMap());
}
