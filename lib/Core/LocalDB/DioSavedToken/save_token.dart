import 'package:shared_preferences/shared_preferences.dart';

class SaveTokenDB {
  const SaveTokenDB._();

  static const String _tokenKey = "TokenKey";

  static Future<void> saveToken(String token) async {
    final preferances = await SharedPreferences.getInstance();

    await preferances.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final preferances = await SharedPreferences.getInstance();
    return preferances.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final preferances = await SharedPreferences.getInstance();
    await preferances.clear();
  }
}
