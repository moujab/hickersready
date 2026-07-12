import 'package:flutter/material.dart';

/// Shared background for every screen reached from the home menu (the
/// "options" screens): a centered watermark of the group logo behind the
/// screen's normal content. The home screen keeps its own photo background
/// and does not use this.
class OptionsBackground extends StatelessWidget {
  const OptionsBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade200,
                Colors.green.shade50,
                Colors.lightBlue.shade50,
              ],
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: 0.22,
            child: Image.asset(
              'assets/images/logo_watermark.png',
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.contain,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
