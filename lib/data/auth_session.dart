import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../models/account.dart';
import 'local_store.dart';

enum LoginResult { success, invalidCredentials }

enum RegisterResult { success, emailTaken }

/// App-wide login gate: users register/log in with email + password,
/// stored locally (salted + hashed) since there is no backend auth yet.
/// Session-only — closing the app requires logging in again.
class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  String? currentEmail;

  static String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  static String _generateSalt() {
    final random = Random.secure();
    return List<int>.generate(
      16,
      (_) => random.nextInt(256),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  RegisterResult register(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (LocalStore.getAccount(normalizedEmail) != null) return RegisterResult.emailTaken;
    final salt = _generateSalt();
    final account = Account(email: normalizedEmail, salt: salt, passwordHash: _hash(password, salt));
    LocalStore.putAccount(account);
    currentEmail = normalizedEmail;
    isLoggedIn.value = true;
    return RegisterResult.success;
  }

  LoginResult login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = LocalStore.getAccount(normalizedEmail);
    if (account == null || account.passwordHash != _hash(password, account.salt)) {
      return LoginResult.invalidCredentials;
    }
    currentEmail = normalizedEmail;
    isLoggedIn.value = true;
    return LoginResult.success;
  }

  void logout() {
    currentEmail = null;
    isLoggedIn.value = false;
  }
}
