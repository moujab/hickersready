import 'package:flutter/material.dart';

import '../models/contributor.dart';

/// Business profile page for a contributor: description, category, contact,
/// and a product photo gallery.
class ContributorDetailScreen extends StatelessWidget {
  const ContributorDetailScreen({super.key, required this.contributor});

  final Contributor contributor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contributor.businessName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Chip(label: Text(contributor.category)),
            const SizedBox(height: 12),
            Text(contributor.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Text(contributor.contactPhone),
              ],
            ),
            if (contributor.productImageUrls.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: contributor.productImageUrls.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(contributor.productImageUrls[index], width: 100, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
