import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../color_tokens.dart';

class WaveProgress extends StatelessWidget {
  const WaveProgress({super.key, required this.progress});
  final double progress; // 0..1

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavePainter(progress: progress.clamp(0.0, 1.0)),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = AppColors.surfaceWhite2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fillPaint = Paint()
      ..color = AppColors.secondaryAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final path = _buildWavePath(size);
    // Base wave
    canvas.drawPath(path, basePaint);

    // Clipped blue portion based on progress
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    canvas.drawPath(path, fillPaint);
    canvas.restore();
  }

  Path _buildWavePath(Size size) {
    final path = Path();
    final amplitude = size.height * 0.35; // subtle
    final period = 24.0; // px per cycle
    final midY = size.height * 0.6;
    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 2) {
      final y = midY + amplitude * math.sin(2 * math.pi * x / period);
      path.lineTo(x, y);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
