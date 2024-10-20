class ChangePasswordModel {
  final String email;
  final String newPassword;

  ChangePasswordModel({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
    };
  }
}
