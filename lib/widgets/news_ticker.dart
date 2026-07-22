import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../models/invitation.dart';
import '../models/upcoming_hike.dart';
import 'marquee_banner.dart';

/// Auto-scrolling strip of upcoming hikes and invitations — a news ticker —
/// meant to sit just below a page's app bar via `AppBar(bottom: NewsTicker())`.
class NewsTicker extends StatelessWidget implements PreferredSizeWidget {
  const NewsTicker({super.key});

  static const double height = 32;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) => MarqueeBanner(
    itemsLoader: _loadItems,
    backgroundColor: const Color(0xFF1B5E20),
    height: height,
  );

  static Future<List<String>> _loadItems() async {
    final results = await Future.wait([LocalStore.upcomingHikes, LocalStore.invitations]);
    final hikes = results[0] as List<UpcomingHike>;
    final invitations = results[1] as List<Invitation>;
    final entries = <MapEntry<DateTime, String>>[
      ...hikes.map((h) => MapEntry(h.date, '⛰ ${h.trailName} — ${_formatDate(h.date)}')),
      ...invitations.map((i) => MapEntry(i.date, '📣 ${i.trailName} — ${_formatDate(i.date)}')),
    ]..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((e) => e.value).toList();
  }

  static String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';
}
