import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/admin_user.dart';
import '../widgets/options_background.dart';
import 'admin_user_form_screen.dart';

/// Admin-only screen listing registered users, with add/edit/delete. Reached
/// from the home screen only while admin mode is on.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<AdminUser>> _users;

  @override
  void initState() {
    super.initState();
    _users = LocalStore.adminUsers;
  }

  void _reload() => setState(() => _users = LocalStore.adminUsers);

  Future<void> _openForm({AdminUser? user}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (context) => AdminUserFormScreen(user: user)),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete(AdminUser user) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true) {
      await LocalStore.deleteAdminUser(user.email);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuUsers)),
      body: OptionsBackground(
        child: FutureBuilder<List<AdminUser>>(
          future: _users,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final users = snapshot.data!;
            if (users.isEmpty) {
              return Center(child: Text(l10n.noUsers, style: const TextStyle(color: Colors.white)));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final title = user.displayName.isEmpty ? user.email : user.displayName;
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(title),
                  subtitle: Text([user.email, user.phone].where((s) => s.isNotEmpty).join('\n')),
                  isThreeLine: user.displayName.isNotEmpty && user.phone.isNotEmpty,
                  onTap: () => _openForm(user: user),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(user: user)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(user)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
