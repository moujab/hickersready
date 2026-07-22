import 'package:flutter/material.dart';

import '../data/local_store.dart';
import 'marquee_banner.dart';

/// Auto-scrolling strip of contributor businesses (المساهمون) — meant to sit
/// below [NewsTicker] via `AppBar(bottom: ...)`.
class ContributorsBanner extends StatelessWidget implements PreferredSizeWidget {
  const ContributorsBanner({super.key});

  static const double height = 32;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) => MarqueeBanner(
    itemsLoader: _loadItems,
    backgroundColor: const Color(0xFF37474F),
    height: height,
  );

  static Future<List<String>> _loadItems() async {
    final contributors = await LocalStore.contributors;
    return contributors.map((c) => '🏪 ${c.businessName} — ${c.category}').toList();
  }
}
