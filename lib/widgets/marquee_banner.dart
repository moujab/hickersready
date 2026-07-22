import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A continuously auto-scrolling strip of text — a marquee/ticker banner.
/// Fetches its own items via [itemsLoader] so it can be dropped onto any
/// screen without extra wiring.
class MarqueeBanner extends StatefulWidget {
  const MarqueeBanner({
    super.key,
    required this.itemsLoader,
    required this.backgroundColor,
    this.height = 32,
  });

  final Future<List<String>> Function() itemsLoader;
  final Color backgroundColor;
  final double height;

  @override
  State<MarqueeBanner> createState() => _MarqueeBannerState();
}

class _MarqueeBannerState extends State<MarqueeBanner> with SingleTickerProviderStateMixin {
  static const double _pixelsPerSecond = 45;
  static const String _separator = '        •        ';
  static const _textStyle = TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500);

  final ScrollController _scrollController = ScrollController();
  late final Future<List<String>> _itemsFuture = widget.itemsLoader();
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
          return SizedBox(height: widget.height);
        }

        final text = '${items.join(_separator)}$_separator';
        _segmentWidth = _measure(text);

        return Container(
          height: widget.height,
          width: double.infinity,
          color: widget.backgroundColor,
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
