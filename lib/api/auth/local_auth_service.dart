import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const String _keyUsername = 'cached_username';

  /// Speichert den Namen unter dem Key 'cached_username'.
  static Future<void> saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, name);
  }

  /// Liest den Namen aus.
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Löscht den Key 'cached_username' aus den Preferences.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
}
