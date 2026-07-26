import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/auth_session.dart';
import 'data/push_notifications.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    PushNotifications.instance.start();
  } catch (e) {
    // Firebase is only used for push; the app must still work without it
    // (e.g. offline first paint or an unsupported platform).
    debugPrint('Firebase init failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: PushNotifications.navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: const Locale('ar'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: ValueListenableBuilder<bool>(
        valueListenable: AuthSession.instance.isLoggedIn,
        builder: (context, isLoggedIn, _) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
