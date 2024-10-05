class LoginModel {
  final String userEmail;
  final String userPassword;

  LoginModel({required this.userEmail, required this.userPassword});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': userEmail,
      'password': userPassword,
    };
  }
}
