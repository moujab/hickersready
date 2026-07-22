import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/invitation.dart';
import '../widgets/app_banners.dart';
import '../widgets/options_background.dart';
import 'invitation_form_screen.dart';

/// Menu item 1: "Trails we did" — lists past invitations; tapping one pops
/// up the full invitation. Admins can add, edit, and delete invitations.
class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late Future<List<Invitation>> _invitations;

  @override
  void initState() {
    super.initState();
    _invitations = LocalStore.invitations;
  }

  void _reload() => setState(() => _invitations = LocalStore.invitations);

  Future<void> _openForm({Invitation? invitation}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (context) => InvitationFormScreen(invitation: invitation)),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete(Invitation invitation) async {
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
      await LocalStore.deleteInvitation(invitation.id);
      _reload();
    }
  }

  void _showInvitation(BuildContext context, Invitation invitation) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(invitation.trailName),
        content: Text(invitation.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuTrailsDone), bottom: const AppBanners()),
      body: OptionsBackground(
        child: FutureBuilder<List<Invitation>>(
          future: _invitations,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final invitations = snapshot.data!;
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: invitations.length,
                itemBuilder: (context, index) {
                  final invitation = invitations[index];
                  return ListTile(
                    title: Text(invitation.trailName),
                    subtitle: Text('${invitation.date.year}/${invitation.date.month}/${invitation.date.day}'),
                    onTap: () => _showInvitation(context, invitation),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(invitation: invitation),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(invitation),
                              ),
                            ],
                          )
                        : null,
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: AdminSession.instance.isAdmin,
        builder: (context, isAdmin, _) =>
            isAdmin ? FloatingActionButton(onPressed: () => _openForm(), child: const Icon(Icons.add)) : const SizedBox.shrink(),
      ),
    );
  }
}
