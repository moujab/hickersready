import 'package:flutter/material.dart';

import '../data/auth_session.dart';
import '../data/locale_controller.dart';
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
  bool _isSubmitting = false;
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

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
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
    } catch (_) {
      // Network/host failure (offline, wrong API_BASE_URL, timeout, TLS, …).
      // Surface it instead of leaving the button dead.
      if (mounted) setState(() => _errorText = l10n.connectionError);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => LocaleController.instance.toggle(),
                        icon: const Icon(Icons.language),
                        // Deliberately not localized: each label is shown in
                        // the language it switches TO.
                        label: Text(LocaleController.instance.isArabic ? 'English' : 'العربية'),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isRegisterMode ? l10n.register : l10n.login),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => setState(() {
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
