import 'package:flutter/material.dart';

import 'contributors_banner.dart';
import 'news_ticker.dart';

/// Stacks [NewsTicker] and [ContributorsBanner] as a single AppBar-bottom
/// widget, so screens don't need to wire up both individually.
class AppBanners extends StatelessWidget implements PreferredSizeWidget {
  const AppBanners({super.key});

  static const double height = NewsTicker.height + ContributorsBanner.height;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) =>
      const Column(mainAxisSize: MainAxisSize.min, children: [NewsTicker(), ContributorsBanner()]);
}
