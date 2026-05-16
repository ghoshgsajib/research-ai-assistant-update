import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? currentUser;

  static Future<void> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('loggedIn', true);

    currentUser = name;
  }

  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');
    final storedName = prefs.getString('name');

    final isValid = email == storedEmail && password == storedPassword;

    if (isValid) {
      currentUser = storedName;
      await prefs.setBool('loggedIn', true);
    }

    return isValid;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final loggedIn = prefs.getBool('loggedIn') ?? false;
    currentUser = prefs.getString('name');

    return loggedIn && currentUser != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('loggedIn', false);
    currentUser = null;
  }
}
