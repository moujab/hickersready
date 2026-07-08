import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'contributors_screen.dart';
import 'guides_screen.dart';
import 'invitations_screen.dart';
import 'towns_screen.dart';
import 'upcoming_hikes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.hiking),
            title: Text(l10n.menuTrailsDone),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const InvitationsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(l10n.menuTownsVisited),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const TownsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: Text(l10n.menuGuides),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const GuidesScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: Text(l10n.menuContributors),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const ContributorsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(l10n.menuUpcomingHikes),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => const UpcomingHikesScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
