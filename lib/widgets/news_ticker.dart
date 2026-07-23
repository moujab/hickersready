import 'package:flutter/material.dart';

import '../data/local_store.dart';
import 'marquee_banner.dart';

/// Auto-scrolling strip of upcoming hikes (menu item 5) — a news ticker —
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
    final hikes = await LocalStore.upcomingHikes;
    return (hikes..sort((a, b) => a.date.compareTo(b.date)))
        .map((h) => '⛰ ${h.trailName} — ${_formatDate(h.date)}')
        .toList();
  }

  static String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';
}
