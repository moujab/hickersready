import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/admin_user.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for a registered user. Pass an existing [user] to
/// edit it (email becomes read-only, password optional), or omit it to create
/// a new account (email + password required).
class AdminUserFormScreen extends StatefulWidget {
  const AdminUserFormScreen({super.key, this.user});

  final AdminUser? user;

  @override
  State<AdminUserFormScreen> createState() => _AdminUserFormScreenState();
}

class _AdminUserFormScreenState extends State<AdminUserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _fatherController;
  late final TextEditingController _familyController;
  late final TextEditingController _phoneController;
  bool _saving = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _fatherController = TextEditingController(text: widget.user?.father ?? '');
    _familyController = TextEditingController(text: widget.user?.family ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _fatherController.dispose();
    _familyController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    final email = _emailController.text.trim().toLowerCase();
    try {
      if (_isEdit) {
        await LocalStore.updateAdminUser(
          email: email,
          password: _passwordController.text,
          name: _nameController.text.trim(),
          father: _fatherController.text.trim(),
          family: _familyController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      } else {
        final result = await LocalStore.createAdminUser(
          email: email,
          password: _passwordController.text,
          name: _nameController.text.trim(),
          father: _fatherController.text.trim(),
          family: _familyController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        if (result != 'success') {
          if (!mounted) return;
          setState(() => _saving = false);
          final message = result == 'emailTaken' ? l10n.emailTaken : l10n.genericError;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          return;
        }
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? l10n.adminEditUser : l10n.adminNewUser)),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _emailController,
                readOnly: _isEdit,
                decoration: InputDecoration(labelText: l10n.settingsEmail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.fieldRequired;
                  if (!_emailPattern.hasMatch(value.trim())) return l10n.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  helperText: _isEdit ? l10n.adminPasswordHintEdit : l10n.adminPasswordHintNew,
                  helperMaxLines: 2,
                ),
                validator: (value) {
                  // Required only when creating a new user.
                  if (!_isEdit && (value == null || value.isEmpty)) return l10n.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.settingsFirstName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fatherController,
                decoration: InputDecoration(labelText: l10n.settingsFatherName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _familyController,
                decoration: InputDecoration(labelText: l10n.settingsFamilyName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: l10n.settingsPhone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
