import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/town.dart';
import '../widgets/detail_page.dart';
import '../widgets/news_ticker.dart';
import '../widgets/options_background.dart';
import 'town_form_screen.dart';

/// Menu item 2: "Towns/villages visited" — lists visited towns; tapping one
/// shows a short description. Admins can add, edit, and delete towns.
class TownsScreen extends StatefulWidget {
  const TownsScreen({super.key});

  @override
  State<TownsScreen> createState() => _TownsScreenState();
}

class _TownsScreenState extends State<TownsScreen> {
  late Future<List<Town>> _towns;

  @override
  void initState() {
    super.initState();
    _towns = LocalStore.towns;
  }

  void _reload() => setState(() => _towns = LocalStore.towns);

  Future<void> _openForm({Town? town}) async {
    final saved = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (context) => TownFormScreen(town: town)));
    if (saved == true) _reload();
  }

  Future<void> _delete(Town town) async {
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
      await LocalStore.deleteTown(town.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuTownsVisited), bottom: const NewsTicker()),
      body: OptionsBackground(
        child: FutureBuilder<List<Town>>(
          future: _towns,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final towns = snapshot.data!;
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: towns.length,
                itemBuilder: (context, index) {
                  final town = towns[index];
                  return ListTile(
                    title: Text(town.name),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => DetailPage(title: town.name, description: town.description),
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(town: town)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(town)),
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
