import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../features/user-auth/domain/entities/app_user.dart';

class LocalStorage {
  static const String _keyAccessToken = 'access_token';
  static const String _keyUser = 'user';

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<void> saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'role': user.role,
      'image': user.image,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
    });
    await prefs.setString(_keyUser, userJson);
  }

  static Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return AppUser(
        id: userMap['id'] as String,
        name: userMap['name'] as String,
        email: userMap['email'] as String,
        role: userMap['role'] as String,
        image: userMap['image'] as String?,
        createdAt: DateTime.parse(userMap['createdAt'] as String),
        updatedAt: DateTime.parse(userMap['updatedAt'] as String),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyUser);
  }
}
