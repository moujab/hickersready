import 'package:flutter/material.dart';

import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/contributor.dart';
import '../widgets/options_background.dart';

/// Admin-only add/edit form for a [Contributor]. Pass an existing
/// [contributor] to edit it, or omit it to create a new one.
class ContributorFormScreen extends StatefulWidget {
  const ContributorFormScreen({super.key, this.contributor});

  final Contributor? contributor;

  @override
  State<ContributorFormScreen> createState() => _ContributorFormScreenState();
}

class _ContributorFormScreenState extends State<ContributorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _businessNameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contactPhoneController;
  late final TextEditingController _productImageUrlsController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(text: widget.contributor?.businessName ?? '');
    _categoryController = TextEditingController(text: widget.contributor?.category ?? '');
    _descriptionController = TextEditingController(text: widget.contributor?.description ?? '');
    _contactPhoneController = TextEditingController(text: widget.contributor?.contactPhone ?? '');
    _productImageUrlsController = TextEditingController(
      text: widget.contributor?.productImageUrls.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _contactPhoneController.dispose();
    _productImageUrlsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final imageUrls = _productImageUrlsController.text
        .split(',')
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
    final contributor = Contributor(
      id: widget.contributor?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      businessName: _businessNameController.text.trim(),
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),
      productImageUrls: imageUrls,
    );
    await LocalStore.putContributor(contributor);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.contributor == null ? l10n.add : l10n.edit)),
      body: OptionsBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(labelText: l10n.businessName),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: l10n.category),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l10n.description),
                maxLines: 6,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactPhoneController,
                decoration: InputDecoration(labelText: l10n.contactPhone),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _productImageUrlsController,
                decoration: InputDecoration(labelText: l10n.productImageUrls),
                maxLines: 3,
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
