import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/invitation.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for an [Invitation]. Pass an existing
/// [invitation] to edit it, or omit it to create a new one.
class InvitationFormScreen extends StatefulWidget {
  const InvitationFormScreen({super.key, this.invitation});

  final Invitation? invitation;

  @override
  State<InvitationFormScreen> createState() => _InvitationFormScreenState();
}

class _InvitationFormScreenState extends State<InvitationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _trailNameController;
  late final TextEditingController _descriptionController;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _trailNameController = TextEditingController(text: widget.invitation?.trailName ?? '');
    _descriptionController = TextEditingController(text: widget.invitation?.description ?? '');
    _date = widget.invitation?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _trailNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final invitation = Invitation(
      id: widget.invitation?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      trailName: _trailNameController.text.trim(),
      date: _date,
      description: _descriptionController.text.trim(),
    );
    await LocalStore.putInvitation(invitation);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.invitation == null ? l10n.add : l10n.edit)),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _trailNameController,
                decoration: InputDecoration(labelText: l10n.trailName),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.date),
                subtitle: Text('${_date.year}/${_date.month}/${_date.day}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l10n.description),
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
