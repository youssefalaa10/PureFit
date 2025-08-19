class LoginModel {
  LoginModel({required this.userEmail, required this.userPassword});
  final String userEmail;
  final String userPassword;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': userEmail,
      'password': userPassword,
    };
  }
}
