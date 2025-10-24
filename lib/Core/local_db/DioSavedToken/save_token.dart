import 'dart:convert';

import 'package:PureFit/Core/Services/token_validation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveTokenDB {
  const SaveTokenDB._();

  static const String _tokenKey = 'TokenKey';
  static const String _tokenDataKey = 'TokenDataKey';

  static Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();

    // Calculate expiration date (30 days from now)
    final expiresAt = TokenValidationService.calculateTokenExpiry();

    // Create token data object
    final tokenData = {
      'token': token,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };

    // Save both token and token data
    await preferences.setString(_tokenKey, token);
    await preferences.setString(_tokenDataKey, jsonEncode(tokenData));
  }

  static Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getTokenData() async {
    final preferences = await SharedPreferences.getInstance();
    final tokenDataString = preferences.getString(_tokenDataKey);

    if (tokenDataString == null) return null;

    try {
      return jsonDecode(tokenDataString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_tokenDataKey);
  }
}
