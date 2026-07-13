import 'package:flutter/foundation.dart';

import 'api_client.dart';

enum LoginResult { success, invalidCredentials }

enum RegisterResult { success, emailTaken }

/// App-wide login gate: users register/log in with email + password,
/// checked against the Spring Boot backend (password hashing happens
/// server-side via BCrypt).
class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  String? currentEmail;

  Future<RegisterResult> register(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final response = await ApiClient.post('/auth/register', {
      'email': normalizedEmail,
      'password': password,
    });
    if (response.statusCode == 409) return RegisterResult.emailTaken;
    currentEmail = normalizedEmail;
    isLoggedIn.value = true;
    return RegisterResult.success;
  }

  Future<LoginResult> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final response = await ApiClient.post('/auth/login', {
      'email': normalizedEmail,
      'password': password,
    });
    if (response.statusCode == 401) return LoginResult.invalidCredentials;
    currentEmail = normalizedEmail;
    isLoggedIn.value = true;
    return LoginResult.success;
  }

  void logout() {
    currentEmail = null;
    isLoggedIn.value = false;
  }
}
