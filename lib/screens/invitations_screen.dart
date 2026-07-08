import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/app_localizations.dart';
import '../models/invitation.dart';

/// Menu item 1: "Trails we did" — lists past invitations; tapping one pops
/// up the full invitation.
class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuTrailsDone)),
      body: ListView.builder(
        itemCount: MockData.invitations.length,
        itemBuilder: (context, index) {
          final invitation = MockData.invitations[index];
          return ListTile(
            title: Text(invitation.trailName),
            subtitle: Text('${invitation.date.year}/${invitation.date.month}/${invitation.date.day}'),
            onTap: () => _showInvitation(context, invitation),
          );
        },
      ),
    );
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
}
