import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../data/models/user_model.dart';

class ProfileCache {
  static const String _profileKey = 'user_profile';
  static const String _lastUpdateKey = 'profile_last_update';

  static Future<void> cacheProfile(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_profileKey, userJson);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  static Future<UserModel?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson == null) {
      return null;
    }

    try {
      final Map<String, dynamic> userMap = jsonDecode(profileJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('Error parsing cached profile: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_lastUpdateKey);
  }
} 