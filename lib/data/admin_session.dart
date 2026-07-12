import 'package:flutter/foundation.dart';

/// App-wide admin gate. There is no backend auth yet (see [LocalStore]), so
/// this checks a hardcoded PIN and flips a session-only flag — a placeholder
/// until real Spring Boot-backed admin auth exists.
class AdminSession {
  AdminSession._();

  static final AdminSession instance = AdminSession._();

  static const String _pin = '1234';

  final ValueNotifier<bool> isAdmin = ValueNotifier<bool>(false);

  bool tryLogin(String pin) {
    if (pin == _pin) {
      isAdmin.value = true;
      return true;
    }
    return false;
  }

  void logout() => isAdmin.value = false;
}
