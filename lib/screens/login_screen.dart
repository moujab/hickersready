import 'package:flutter/material.dart';

import '../data/auth_session.dart';
import '../l10n/app_localizations.dart';

/// Login/register gate shown before the rest of the app is reachable.
/// Accounts are local-only (email + hashed password) until a real backend
/// exists.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_isRegisterMode) {
      final result = await AuthSession.instance.register(email, password);
      if (result == RegisterResult.emailTaken && mounted) {
        setState(() => _errorText = l10n.emailTaken);
      }
    } else {
      final result = await AuthSession.instance.login(email, password);
      if (result == LoginResult.invalidCredentials && mounted) {
        setState(() => _errorText = l10n.invalidCredentials);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: l10n.settingsEmail),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: l10n.password, errorText: _errorText),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.fieldRequired;
                        if (_isRegisterMode && value.length < 6) return l10n.passwordTooShort;
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(_isRegisterMode ? l10n.register : l10n.login),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() {
                        _isRegisterMode = !_isRegisterMode;
                        _errorText = null;
                      }),
                      child: Text(_isRegisterMode ? l10n.haveAccountLogin : l10n.noAccountRegister),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
