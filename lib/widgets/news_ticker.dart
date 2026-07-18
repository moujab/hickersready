import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../data/local_store.dart';
import '../models/invitation.dart';
import '../models/upcoming_hike.dart';

/// A continuously auto-scrolling strip of upcoming hikes and invitations —
/// a news ticker / marquee — meant to sit just below a page's app bar via
/// `AppBar(bottom: NewsTicker())`. Fetches its own data so it can be
/// dropped onto any screen without extra wiring.
class NewsTicker extends StatefulWidget implements PreferredSizeWidget {
  const NewsTicker({super.key});

  static const double height = 32;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> with SingleTickerProviderStateMixin {
  static const double _pixelsPerSecond = 45;
  static const String _separator = '        •        ';
  static const _textStyle = TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500);

  final ScrollController _scrollController = ScrollController();
  late final Future<List<String>> _itemsFuture = _loadItems();
  late final Ticker _ticker;
  double _segmentWidth = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<String>> _loadItems() async {
    final results = await Future.wait([LocalStore.upcomingHikes, LocalStore.invitations]);
    final hikes = results[0] as List<UpcomingHike>;
    final invitations = results[1] as List<Invitation>;
    final entries = <MapEntry<DateTime, String>>[
      ...hikes.map((h) => MapEntry(h.date, '⛰ ${h.trailName} — ${_formatDate(h.date)}')),
      ...invitations.map((i) => MapEntry(i.date, '📣 ${i.trailName} — ${_formatDate(i.date)}')),
    ]..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((e) => e.value).toList();
  }

  String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';

  void _onTick(Duration elapsed) {
    if (_segmentWidth <= 0 || !_scrollController.hasClients) return;
    final offset = (elapsed.inMilliseconds / 1000) * _pixelsPerSecond % _segmentWidth;
    _scrollController.jumpTo(offset);
  }

  double _measure(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        final items = snapshot.data;
        if (items == null || items.isEmpty) {
          return const SizedBox(height: NewsTicker.height);
        }

        final text = '${items.join(_separator)}$_separator';
        _segmentWidth = _measure(text);

        return Container(
          height: NewsTicker.height,
          width: double.infinity,
          color: const Color(0xFF1B5E20),
          child: ClipRect(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(text, style: _textStyle)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(text, style: _textStyle)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
