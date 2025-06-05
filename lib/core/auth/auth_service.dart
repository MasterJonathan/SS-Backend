import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId; // Placeholder for user data
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@example.com' && password == 'password') {
      _isAuthenticated = true;
      _userId = 'admin_user_id';
      _userEmail = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String fullName) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // For demo, auto-login after register
    _isAuthenticated = true;
    _userId = 'new_user_id';
    _userEmail = email;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    notifyListeners();
  }
}