import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/admin_session.dart';
import '../data/background_audio.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_banners.dart';
import '../widgets/detail_page.dart';
import 'contributors_screen.dart';
import 'guides_screen.dart';
import 'invitations_screen.dart';
import 'settings_screen.dart';
import 'towns_screen.dart';
import 'upcoming_hikes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleAdminTap(BuildContext context, bool isAdmin) async {
    final l10n = AppLocalizations.of(context)!;
    if (isAdmin) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.adminModeOn),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.logout)),
          ],
        ),
      );
      if (confirmed == true) AdminSession.instance.logout();
      return;
    }

    final pinController = TextEditingController();
    var showError = false;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.adminLogin),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.pin,
              errorText: showError ? l10n.incorrectPin : null,
            ),
            onSubmitted: (_) async {
              final dialogContext = context;
              if (await AdminSession.instance.tryLogin(pinController.text)) {
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              } else {
                setState(() => showError = true);
              }
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
            TextButton(
              onPressed: () async {
                final dialogContext = context;
                if (await AdminSession.instance.tryLogin(pinController.text)) {
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                } else {
                  setState(() => showError = true);
                }
              },
              child: Text(l10n.adminLogin),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: const AppBanners(),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: AdminSession.instance.isAdmin,
            builder: (context, isAdmin, _) => IconButton(
              icon: Icon(isAdmin ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined),
              onPressed: () => _handleAdminTap(context, isAdmin),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: BackgroundAudio.instance.playing,
            builder: (context, playing, _) => IconButton(
              icon: Icon(playing ? Icons.volume_up : Icons.volume_off),
              onPressed: BackgroundAudio.instance.toggle,
            ),
          ),
        ],
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + AppBanners.height + 16,
          ),
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
            _MenuCard(
              icon: Icons.groups,
              label: l10n.menuWhoAreWe,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => DetailPage(
                    title: l10n.menuWhoAreWe,
                    description: l10n.whoAreWeDescription,
                  ),
                ),
              ),
            ),
            _MenuCard(
              icon: Icons.settings,
              label: l10n.menuSettings,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const SettingsScreen()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Text(l10n.groupName, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.data?.version;
                        final year = DateTime.now().year;
                        return Text(
                          version == null ? '$year' : 'v$version · $year',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                        );
                      },
                    ),
                  ],
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
