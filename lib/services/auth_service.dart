import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthService._(); // Конструктор

  // Метод для логина
  bool login(String username, String password) {
    // Простейшая логика для проверки логина (например, проверка на жесткое имя и пароль)
    if (username == "user" && password == "password") {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Логика выхода
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
