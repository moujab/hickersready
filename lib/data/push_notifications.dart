import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'auth_session.dart';

/// Registers this app instance (browser or phone) for Firebase Cloud
/// Messaging push notifications and reports the FCM token to the backend,
/// which pushes announcement reminders to every registered device — even
/// when the app is closed.
///
/// Permission is only requested once the user logs in (browsers are more
/// likely to allow a prompt tied to a signed-in session than one fired on
/// first page load).
class PushNotifications {
  PushNotifications._();

  static final PushNotifications instance = PushNotifications._();

  /// Web Push certificate key pair from the Firebase console
  /// (Project settings → Cloud Messaging → Web Push certificates).
  /// Only used on web; Android ignores it.
  static const String _vapidKey =
      'BN3vFkSn6VPMVpEeAafKzVSB3sPmy9I08o-yE9ZOMQXCPm0wRV3UXC3MV5LsS9YS7A_9SLUpwvwxOKtupUbG7AM';

  bool _started = false;

  /// Idempotent: hooks the login listener once; registers immediately if the
  /// user is already logged in.
  void start() {
    if (_started) return;
    _started = true;
    AuthSession.instance.isLoggedIn.addListener(_onLoginChanged);
    if (AuthSession.instance.isLoggedIn.value) _onLoginChanged();
    FirebaseMessaging.instance.onTokenRefresh.listen(_register, onError: (_) {});
  }

  Future<void> _onLoginChanged() async {
    if (!AuthSession.instance.isLoggedIn.value) return;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await messaging.getToken(
        vapidKey: kIsWeb ? _vapidKey : null,
      );
      if (token != null) await _register(token);
    } catch (e) {
      // Push is best-effort: never let a denied permission or an FCM hiccup
      // break login. The in-app bell still shows announcements.
      debugPrint('Push registration failed: $e');
    }
  }

  Future<void> _register(String token) async {
    try {
      await ApiClient.post('/device-tokens', {
        'token': token,
        'email': AuthSession.instance.currentEmail,
        'platform': kIsWeb ? 'web' : 'android',
      });
    } catch (e) {
      debugPrint('Token registration failed: $e');
    }
  }
}
