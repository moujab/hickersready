import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/announcement.dart';

/// Notification bell shown in the home app bar for every logged-in user.
/// Loads the active announcements, shows their count as a badge, and opens a
/// list of the reminders when tapped.
class AnnouncementsBell extends StatefulWidget {
  const AnnouncementsBell({super.key});

  @override
  State<AnnouncementsBell> createState() => _AnnouncementsBellState();
}

class _AnnouncementsBellState extends State<AnnouncementsBell> {
  List<Announcement> _active = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final all = await LocalStore.announcements;
      if (!mounted) return;
      setState(() => _active = all.where((a) => a.active).toList());
    } catch (_) {
      // A failed load just leaves the bell empty; no need to interrupt the
      // user with an error on the home screen.
    }
  }

  void _openList() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.announcementsTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: _active.isEmpty
              ? Text(l10n.noAnnouncements)
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _active.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final a = _active[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(a.message),
                        const SizedBox(height: 4),
                        Text(
                          '${a.createdAt.year}/${a.createdAt.month}/${a.createdAt.day}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    );
                  },
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _active.length;
    final bell = IconButton(
      icon: const Icon(Icons.notifications_outlined),
      onPressed: _openList,
    );
    if (count == 0) return bell;
    return Badge.count(count: count, child: bell);
  }
}
