import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? currentUser;

  // অ্যাডমিন চেক করার সময় লগইন স্ট্যাটাসও চেক করা হচ্ছে
  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('loggedIn') ?? false;
    final email = prefs.getString('email');
    return isLoggedIn && email == "admin@gmail.com";
  }

  static Future<List<Map<String, String>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('all_users_db');
    if (usersJson == null) return [];
    
    List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((item) => Map<String, String>.from(item)).toList();
  }

  static Future<void> registerUser(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> users = await getAllUsers();
    
    int index = users.indexWhere((u) => u['email'] == email);
    Map<String, String> userData = {
      'name': name,
      'email': email,
      'password': password,
    };

    if (index == -1) {
      users.add(userData);
    } else {
      users[index] = userData;
    }

    await prefs.setString('all_users_db', jsonEncode(users));
    await _setCurrentUser(prefs, name, email, password);
  }

  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> users = await getAllUsers();

    try {
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
      
      await _setCurrentUser(prefs, user['name']!, user['email']!, user['password']!);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _setCurrentUser(SharedPreferences prefs, String name, String email, String password) async {
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('loggedIn', true);
    currentUser = name;
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
    // currentUser ইমেইল বা পাসওয়ার্ড ক্লিয়ার করা নিরাপদ
    currentUser = null;
  }
}
