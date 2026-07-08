import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/app_localizations.dart';
import '../widgets/detail_page.dart';

/// Menu item 5: "Upcoming hikes" — future hikes in chronological order;
/// tapping one shows a description of the activity. A separate entity from
/// invitations by design.
class UpcomingHikesScreen extends StatelessWidget {
  const UpcomingHikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hikes = [...MockData.upcomingHikes]..sort((a, b) => a.date.compareTo(b.date));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuUpcomingHikes)),
      body: ListView.builder(
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
          );
        },
      ),
    );
  }
}
