class ForgotPasswordModel {
  final String email;

  ForgotPasswordModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
