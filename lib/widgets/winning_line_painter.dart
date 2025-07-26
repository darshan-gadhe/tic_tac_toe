import 'package:flutter/material.dart';

class WinningLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double progress; // Animation progress from 0.0 to 1.0
  final Paint linePaint;

  WinningLinePainter({
    required this.start,
    required this.end,
    required this.progress,
    required Color color,
  }) : linePaint = Paint()
    ..color = color
    ..strokeWidth = 10.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // Interpolate the end point of the line based on the animation progress.
    final currentEnd = Offset.lerp(start, end, progress);
    if (currentEnd != null) {
      canvas.drawLine(start, currentEnd, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repaint whenever the progress changes.
    return true;
  }
}