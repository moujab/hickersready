// One-off tool: turns the Walk & Discover logo into square launcher-icon
// sources. It drops the "WALK AND DISCOVER GROUP" wordmark at the bottom,
// trims the surrounding transparency, and centres the mountain+trail emblem
// on a square canvas.
//
// Run with: dart run tool/make_icon.dart
// Outputs:
//   assets/icon/app_icon.png            (1024x1024, white bg — legacy icon)
//   assets/icon/app_icon_foreground.png (1024x1024, transparent, padded for
//                                        Android adaptive-icon safe zone)
import 'dart:io';
import 'package:image/image.dart';

const int size = 1024;

void main() {
  final src = decodePng(File('assets/images/logo_watermark.png').readAsBytesSync())!;
  stdout.writeln('source: ${src.width}x${src.height}');

  // Keep only the top ~68% of the logo (the emblem); the rest is the wordmark.
  final emblemHeight = (src.height * 0.68).round();
  final emblem = copyCrop(src, x: 0, y: 0, width: src.width, height: emblemHeight);

  // Trim transparent/near-white margins so the emblem fills the canvas.
  final box = _contentBounds(emblem);
  final cropped = copyCrop(emblem,
      x: box[0], y: box[1], width: box[2] - box[0] + 1, height: box[3] - box[1] + 1);
  stdout.writeln('emblem trimmed to: ${cropped.width}x${cropped.height}');

  // --- Foreground (transparent, ~72% of the canvas for the adaptive safe zone).
  _writeCentered(cropped, 'assets/icon/app_icon_foreground.png',
      scale: 0.72, background: null);

  // --- Legacy icon (white background, emblem a touch larger).
  _writeCentered(cropped, 'assets/icon/app_icon.png',
      scale: 0.86, background: ColorRgb8(255, 255, 255));

  stdout.writeln('done');
}

/// Bounding box [minX, minY, maxX, maxY] of pixels that are neither
/// transparent nor near-white.
List<int> _contentBounds(Image img) {
  int minX = img.width, minY = img.height, maxX = 0, maxY = 0;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      final p = img.getPixel(x, y);
      final a = p.a;
      final nearWhite = p.r > 245 && p.g > 245 && p.b > 245;
      if (a > 16 && !nearWhite) {
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
  }
  return [minX, minY, maxX, maxY];
}

void _writeCentered(Image content, String path,
    {required double scale, Color? background}) {
  final canvas = Image(width: size, height: size, numChannels: 4);
  if (background != null) {
    fill(canvas, color: background);
  }
  final target = (size * scale).round();
  final ratio = content.width / content.height;
  int w, h;
  if (ratio >= 1) {
    w = target;
    h = (target / ratio).round();
  } else {
    h = target;
    w = (target * ratio).round();
  }
  final resized = copyResize(content, width: w, height: h, interpolation: Interpolation.cubic);
  compositeImage(canvas, resized,
      dstX: (size - w) ~/ 2, dstY: (size - h) ~/ 2);
  File(path).writeAsBytesSync(encodePng(canvas));
  stdout.writeln('wrote $path (${w}x$h emblem)');
}
