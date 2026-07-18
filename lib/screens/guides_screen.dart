import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/guide.dart';
import '../widgets/detail_page.dart';
import '../widgets/news_ticker.dart';
import '../widgets/options_background.dart';
import 'guide_form_screen.dart';

/// Menu item 3: "Our guides" — lists guides; tapping one shows their bio.
/// Admins can add, edit, and delete guides.
class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  late Future<List<Guide>> _guides;

  @override
  void initState() {
    super.initState();
    _guides = LocalStore.guides;
  }

  void _reload() => setState(() => _guides = LocalStore.guides);

  Future<void> _openForm({Guide? guide}) async {
    final saved = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (context) => GuideFormScreen(guide: guide)));
    if (saved == true) _reload();
  }

  Future<void> _delete(Guide guide) async {
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
      await LocalStore.deleteGuide(guide.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuGuides), bottom: const NewsTicker()),
      body: OptionsBackground(
        child: FutureBuilder<List<Guide>>(
          future: _guides,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final guides = snapshot.data!;
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: guides.length,
                itemBuilder: (context, index) {
                  final guide = guides[index];
                  return ListTile(
                    title: Text(guide.name),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => DetailPage(title: guide.name, description: guide.bio),
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(guide: guide)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(guide)),
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
