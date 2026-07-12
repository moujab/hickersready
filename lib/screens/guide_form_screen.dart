import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/guide.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for a [Guide]. Pass an existing [guide] to edit
/// it, or omit it to create a new one.
class GuideFormScreen extends StatefulWidget {
  const GuideFormScreen({super.key, this.guide});

  final Guide? guide;

  @override
  State<GuideFormScreen> createState() => _GuideFormScreenState();
}

class _GuideFormScreenState extends State<GuideFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guide?.name ?? '');
    _bioController = TextEditingController(text: widget.guide?.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final guide = Guide(
      id: widget.guide?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
    );
    await LocalStore.putGuide(guide);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.guide == null ? l10n.add : l10n.edit)),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.guideName),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: l10n.bio),
                maxLines: 6,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
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
