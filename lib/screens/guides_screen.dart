import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/app_localizations.dart';
import '../widgets/detail_page.dart';

/// Menu item 3: "Our guides" — lists guides; tapping one shows their bio.
class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuGuides)),
      body: ListView.builder(
        itemCount: MockData.guides.length,
        itemBuilder: (context, index) {
          final guide = MockData.guides[index];
          return ListTile(
            title: Text(guide.name),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DetailPage(title: guide.name, description: guide.bio),
              ),
            ),
          );
        },
      ),
    );
  }
}
