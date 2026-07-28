import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

enum LoginResult { success, invalidCredentials }

enum RegisterResult { success, emailTaken }

/// App-wide login gate: users register/log in with email + password,
/// checked against the Spring Boot backend (password hashing happens
/// server-side via BCrypt).
class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  static const _emailPrefsKey = 'loggedInEmail';

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  String? currentEmail;

  /// Restores the previous session (if any) from device storage so the user
  /// only has to log in once, not on every app start.
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_emailPrefsKey);
    if (savedEmail != null && savedEmail.isNotEmpty) {
      currentEmail = savedEmail;
      isLoggedIn.value = true;
    }
  }

  Future<RegisterResult> register(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final response = await ApiClient.post('/auth/register', {
      'email': normalizedEmail,
      'password': password,
    });
    if (response.statusCode == 409) return RegisterResult.emailTaken;
    await _persistLogin(normalizedEmail);
    return RegisterResult.success;
  }

  Future<LoginResult> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final response = await ApiClient.post('/auth/login', {
      'email': normalizedEmail,
      'password': password,
    });
    if (response.statusCode == 401) return LoginResult.invalidCredentials;
    await _persistLogin(normalizedEmail);
    return LoginResult.success;
  }

  Future<void> _persistLogin(String normalizedEmail) async {
    currentEmail = normalizedEmail;
    isLoggedIn.value = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailPrefsKey, normalizedEmail);
  }

  void logout() {
    currentEmail = null;
    isLoggedIn.value = false;
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_emailPrefsKey));
  }
}
