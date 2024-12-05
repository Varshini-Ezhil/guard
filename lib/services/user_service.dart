import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';

  // Save a new user
  static Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing users or create empty list
    final usersList = await getUsers();

    // Check if user already exists
    if (usersList.any((u) => u.phone == user.phone)) {
      throw Exception('User with this phone number already exists');
    }

    usersList.add(user);

    // Save updated list
    await prefs.setString(
        _usersKey, jsonEncode(usersList.map((u) => u.toJson()).toList()));

    // Set as current user
    await setCurrentUser(user);
  }

  // Get all users
  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return [];

    final usersList = jsonDecode(usersJson) as List;
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  // Login user
  static Future<User> loginUser(String phone, String password) async {
    final users = await getUsers();

    final user = users.firstWhere(
      (u) => u.phone == phone && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    await setCurrentUser(user);
    return user;
  }

  // Set current user
  static Future<void> setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);

    if (userJson == null) return null;

    return User.fromJson(jsonDecode(userJson));
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, user.name);
    await prefs.setString(_emailKey, user.email);
    await prefs.setString(_phoneKey, user.phone);
  }

  static Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final email = prefs.getString(_emailKey);
    final phone = prefs.getString(_phoneKey);

    if (name != null && email != null && phone != null) {
      return User(
        name: name,
        email: email,
        phone: phone,
        password: '', // We don't store or retrieve password
      );
    }
    return null;
  }
}
