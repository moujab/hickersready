import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/upcoming_hike.dart';
import '../widgets/detail_page.dart';
import '../widgets/news_ticker.dart';
import '../widgets/options_background.dart';

/// Menu item 5: "Upcoming hikes" — future hikes in chronological order;
/// tapping one shows a description of the activity. A separate entity from
/// invitations by design.
class UpcomingHikesScreen extends StatefulWidget {
  const UpcomingHikesScreen({super.key});

  @override
  State<UpcomingHikesScreen> createState() => _UpcomingHikesScreenState();
}

class _UpcomingHikesScreenState extends State<UpcomingHikesScreen> {
  late final Future<List<UpcomingHike>> _hikes = LocalStore.upcomingHikes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuUpcomingHikes), bottom: const NewsTicker()),
      body: OptionsBackground(
        child: FutureBuilder<List<UpcomingHike>>(
          future: _hikes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final hikes = [...snapshot.data!]..sort((a, b) => a.date.compareTo(b.date));
            return ListView.builder(
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
            );
          },
        ),
      ),
    );
  }
}
