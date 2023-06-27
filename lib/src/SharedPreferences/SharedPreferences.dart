import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyLoggedIn = 'logged_in';

  // Guardar datos del usuario y estado de inicio de sesión
  static Future<bool> saveUserData(
      String username, String email, bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUsername, username);
    prefs.setString(_keyEmail, email);
    prefs.setBool(_keyLoggedIn, isLoggedIn);
    return true;
  }

  // Obtener nombre de usuario
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Obtener correo electrónico
  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Obtener estado de inicio de sesión
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // Actualizar estado de inicio de sesión
  static Future<void> updateLoggedInStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyLoggedIn, isLoggedIn);
  }
}
