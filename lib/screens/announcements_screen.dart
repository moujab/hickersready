import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../widgets/app_banners.dart';
import '../widgets/detail_page.dart';
import '../widgets/options_background.dart';
import 'announcement_form_screen.dart';

/// "Announcements" — reminders and messages broadcast to everyone who has the
/// app. All users can read them; admins can add, edit, and delete them.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late Future<List<Announcement>> _announcements;

  @override
  void initState() {
    super.initState();
    _announcements = LocalStore.announcements;
  }

  void _reload() => setState(() => _announcements = LocalStore.announcements);

  Future<void> _openForm({Announcement? announcement}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => AnnouncementFormScreen(announcement: announcement),
      ),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete(Announcement announcement) async {
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
      await LocalStore.deleteAnnouncement(announcement.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuAnnouncements), bottom: const AppBanners()),
      body: OptionsBackground(
        child: FutureBuilder<List<Announcement>>(
          future: _announcements,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final announcements = [...snapshot.data!]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (announcements.isEmpty) {
              return Center(child: Text(l10n.noAnnouncements));
            }
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return ListTile(
                    leading: const Icon(Icons.campaign),
                    title: Text(announcement.title),
                    subtitle: Text(
                      _formatDate(announcement.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            DetailPage(title: announcement.title, description: announcement.body),
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(announcement: announcement),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(announcement),
                              ),
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
        builder: (context, isAdmin, _) => isAdmin
            ? FloatingActionButton(onPressed: () => _openForm(), child: const Icon(Icons.add))
            : const SizedBox.shrink(),
      ),
    );
  }

  static String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';
}
