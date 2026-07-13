import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// App-wide admin gate, checked against the Spring Boot backend's
/// configured PIN (see `hikersway.admin-pin` in the backend's
/// application.properties).
class AdminSession {
  AdminSession._();

  static final AdminSession instance = AdminSession._();

  final ValueNotifier<bool> isAdmin = ValueNotifier<bool>(false);

  Future<bool> tryLogin(String pin) async {
    final response = await ApiClient.post('/admin/login', {'pin': pin});
    if (response.statusCode == 200) {
      isAdmin.value = true;
      return true;
    }
    return false;
  }

  void logout() => isAdmin.value = false;
}
