class VerificationModel {
  VerificationModel({required this.email, required this.verificationCode});
  final String email;
  final String verificationCode;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verificationCode': verificationCode,
    };
  }
}
