import 'package:flutter/material.dart';

/// Generic detail page: an app bar with [title] and a scrollable body
/// showing [description].
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
