import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for an [Announcement]. Pass an existing
/// [announcement] to edit it, or omit it to create a new one.
class AnnouncementFormScreen extends StatefulWidget {
  const AnnouncementFormScreen({super.key, this.announcement});

  final Announcement? announcement;

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late bool _active;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement?.title ?? '');
    _messageController = TextEditingController(text: widget.announcement?.message ?? '');
    _active = widget.announcement?.active ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final announcement = Announcement(
      id: widget.announcement?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      message: _messageController.text.trim(),
      // Preserve the original creation time when editing so ordering is stable.
      createdAt: widget.announcement?.createdAt ?? DateTime.now(),
      active: _active,
    );
    await LocalStore.putAnnouncement(announcement);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.announcement == null ? l10n.add : l10n.edit)),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.announcementTitleField),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: l10n.announcementMessageField),
                maxLines: 6,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.announcementActiveField),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
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
