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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          // Scrim over the photo keeps the app bar title and cards readable
          // regardless of how bright the underlying image is.
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.45), Colors.black.withValues(alpha: 0.15)],
            ),
          ),
          child: ListView(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight + 16),
          children: [
            _MenuCard(
              icon: Icons.hiking,
              label: l10n.menuTrailsDone,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const InvitationsScreen()),
              ),
            ),
            _MenuCard(
              icon: Icons.location_city,
              label: l10n.menuTownsVisited,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const TownsScreen()),
              ),
            ),
            _MenuCard(
              icon: Icons.person_pin,
              label: l10n.menuGuides,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const GuidesScreen()),
              ),
            ),
            _MenuCard(
              icon: Icons.storefront,
              label: l10n.menuContributors,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const ContributorsScreen()),
              ),
            ),
            _MenuCard(
              icon: Icons.event,
              label: l10n.menuUpcomingHikes,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const UpcomingHikesScreen()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  l10n.groupName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.white.withValues(alpha: 0.92),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
