class ChangePasswordModel {
  ChangePasswordModel({required this.email, required this.newPassword});
  final String email;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
    };
  }
}
