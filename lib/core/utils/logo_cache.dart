import 'package:shared_preferences/shared_preferences.dart';

class LogoCache {
  static const String _logoKey = 'office_logo';
  static const String _lastUpdateKey = 'logo_last_update';
  static const Duration _cacheDuration = Duration(hours: 24); // Cache for 24 hours

  static Future<void> cacheLogo(String base64Logo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_logoKey, base64Logo);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  static Future<String?> getCachedLogo() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);
    
    if (lastUpdate == null) {
      return null;
    }

    final lastUpdateTime = DateTime.parse(lastUpdate);
    final now = DateTime.now();
    
    // Check if cache is expired
    if (now.difference(lastUpdateTime) > _cacheDuration) {
      await clearCache();
      return null;
    }

    return prefs.getString(_logoKey);
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logoKey);
    await prefs.remove(_lastUpdateKey);
  }
} 