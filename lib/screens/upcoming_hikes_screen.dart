import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/upcoming_hike.dart';
import '../widgets/app_banners.dart';
import '../widgets/detail_page.dart';
import '../widgets/options_background.dart';
import 'upcoming_hike_form_screen.dart';

/// Menu item 5: "Upcoming hikes" — future hikes in chronological order;
/// tapping one shows a description of the activity. A separate entity from
/// invitations by design. Admins can add, edit, and delete hikes.
class UpcomingHikesScreen extends StatefulWidget {
  const UpcomingHikesScreen({super.key});

  @override
  State<UpcomingHikesScreen> createState() => _UpcomingHikesScreenState();
}

class _UpcomingHikesScreenState extends State<UpcomingHikesScreen> {
  late Future<List<UpcomingHike>> _hikes;

  @override
  void initState() {
    super.initState();
    _hikes = LocalStore.upcomingHikes;
  }

  void _reload() => setState(() => _hikes = LocalStore.upcomingHikes);

  Future<void> _openForm({UpcomingHike? hike}) async {
    final saved = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (context) => UpcomingHikeFormScreen(hike: hike)));
    if (saved == true) _reload();
  }

  Future<void> _delete(UpcomingHike hike) async {
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
      await LocalStore.deleteUpcomingHike(hike.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuUpcomingHikes), bottom: const AppBanners()),
      body: OptionsBackground(
        child: FutureBuilder<List<UpcomingHike>>(
          future: _hikes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final hikes = [...snapshot.data!]..sort((a, b) => a.date.compareTo(b.date));
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: hikes.length,
                itemBuilder: (context, index) {
                  final hike = hikes[index];
                  return ListTile(
                    title: Text(hike.trailName),
                    subtitle: Text('${hike.date.year}/${hike.date.month}/${hike.date.day}'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => DetailPage(title: hike.trailName, description: hike.description),
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(hike: hike)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(hike)),
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
