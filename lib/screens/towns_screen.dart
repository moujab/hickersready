import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../widgets/detail_page.dart';

/// Menu item 2: "Towns/villages visited" — lists visited towns; tapping one
/// shows a short description.
class TownsScreen extends StatelessWidget {
  const TownsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuTownsVisited)),
      body: ListView.builder(
        itemCount: LocalStore.towns.length,
        itemBuilder: (context, index) {
          final town = LocalStore.towns[index];
          return ListTile(
            title: Text(town.name),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DetailPage(title: town.name, description: town.description),
              ),
            ),
          );
        },
      ),
    );
  }
}
