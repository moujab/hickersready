import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for an [Announcement] (a reminder or message sent
/// to everyone who has the app). Pass an existing [announcement] to edit it,
/// or omit it to create a new one.
class AnnouncementFormScreen extends StatefulWidget {
  const AnnouncementFormScreen({super.key, this.announcement});

  final Announcement? announcement;

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement?.title ?? '');
    _bodyController = TextEditingController(text: widget.announcement?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final announcement = Announcement(
      id: widget.announcement?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      createdAt: widget.announcement?.createdAt ?? DateTime.now(),
    );
    await LocalStore.putAnnouncement(announcement);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.announcement == null ? l10n.sendAnnouncement : l10n.edit),
      ),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.announcementTitle),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: l10n.announcementBody),
                maxLines: 6,
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: Text(l10n.save)),
            ],
          ),
        ),
      ),
    );
  }
}
