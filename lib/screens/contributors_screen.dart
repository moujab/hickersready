import 'package:flutter/material.dart';

import '../data/admin_session.dart';
import '../data/local_store.dart';
import '../l10n/app_localizations.dart';
import '../models/contributor.dart';
import '../widgets/app_banners.dart';
import '../widgets/options_background.dart';
import 'contributor_detail_screen.dart';
import 'contributor_form_screen.dart';

/// Menu item 4: "Contributors" — local businesses advertising their
/// products. v1 uses mock/admin-managed data; the model is shaped for a
/// future self-serve submission + moderation flow. Admins can add, edit, and
/// delete contributors.
class ContributorsScreen extends StatefulWidget {
  const ContributorsScreen({super.key});

  @override
  State<ContributorsScreen> createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  late Future<List<Contributor>> _contributors;

  @override
  void initState() {
    super.initState();
    _contributors = LocalStore.contributors;
  }

  void _reload() => setState(() => _contributors = LocalStore.contributors);

  Future<void> _openForm({Contributor? contributor}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (context) => ContributorFormScreen(contributor: contributor)),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete(Contributor contributor) async {
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
      await LocalStore.deleteContributor(contributor.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuContributors), bottom: const AppBanners()),
      body: OptionsBackground(
        child: FutureBuilder<List<Contributor>>(
          future: _contributors,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final contributors = snapshot.data!;
            return ValueListenableBuilder<bool>(
              valueListenable: AdminSession.instance.isAdmin,
              builder: (context, isAdmin, _) => ListView.builder(
                itemCount: contributors.length,
                itemBuilder: (context, index) {
                  final contributor = contributors[index];
                  return ListTile(
                    title: Text(contributor.businessName),
                    subtitle: Text(contributor.category),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => ContributorDetailScreen(contributor: contributor),
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(contributor: contributor),
                              ),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(contributor)),
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
