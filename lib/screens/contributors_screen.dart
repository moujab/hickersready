import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/app_localizations.dart';
import 'contributor_detail_screen.dart';

/// Menu item 4: "Contributors" — local businesses advertising their
/// products. v1 uses mock/admin-managed data; the model is shaped for a
/// future self-serve submission + moderation flow.
class ContributorsScreen extends StatelessWidget {
  const ContributorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuContributors)),
      body: ListView.builder(
        itemCount: MockData.contributors.length,
        itemBuilder: (context, index) {
          final contributor = MockData.contributors[index];
          return ListTile(
            title: Text(contributor.businessName),
            subtitle: Text(contributor.category),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ContributorDetailScreen(contributor: contributor),
              ),
            ),
          );
        },
      ),
    );
  }
}
