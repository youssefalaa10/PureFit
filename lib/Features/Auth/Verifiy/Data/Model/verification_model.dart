class VerificationModel {
  final String email;
  final String verificationCode;

  VerificationModel({required this.email, required this.verificationCode});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verificationCode': verificationCode,
    };
  }
}
