import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'math_curve_curves.dart';
import 'math_curve_loader_style.dart';

class MathCurvePainter extends CustomPainter {
  MathCurvePainter({
    required this.progress,
    required this.curve,
    required this.color,
    required this.style,
  }) : super(repaint: progress);

  static const _pathSamples = 420;
  static const _staticProgress = 0.18;

  final Animation<double> progress;
  final MathCurvePointBuilder curve;
  final Color color;
  final MathCurveLoaderStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final scale = side / 100;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);
    final value = progress.value;
    final detailScale = _detailScale(value);

    Offset mapPoint(Offset point) {
      return origin + Offset(point.dx * scale, point.dy * scale);
    }

    final path = Path();
    for (var index = 0; index <= _pathSamples; index++) {
      final point = mapPoint(curve(index / _pathSamples, detailScale));
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: style.guideOpacity)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = style.strokeWidth * scale,
    );

    for (var index = 0; index < style.particleCount; index++) {
      final tailOffset = index / (style.particleCount - 1);
      final trailProgress = _normalize(value - tailOffset * style.trailSpan);
      final fade = math.pow(1 - tailOffset, 0.56).toDouble();
      final point = mapPoint(curve(trailProgress, detailScale));
      final opacity = _lerp(
        style.minParticleOpacity,
        style.maxParticleOpacity,
        fade,
      );
      final radius = _lerp(
        style.minParticleRadius,
        style.maxParticleRadius,
        fade,
      );

      canvas.drawCircle(
        point,
        radius * scale,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MathCurvePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.curve != curve ||
        oldDelegate.color != color ||
        oldDelegate.style != style;
  }

  static double _staticValue(bool reverse) =>
      reverse ? 1 - _staticProgress : _staticProgress;

  static Animation<double> staticAnimation({required bool reverse}) {
    return AlwaysStoppedAnimation<double>(_staticValue(reverse));
  }

  double _detailScale(double progress) {
    final pulseAngle = progress * math.pi * 2;
    return 0.52 + ((math.sin(pulseAngle + 0.55) + 1) / 2) * 0.48;
  }

  double _lerp(double begin, double end, double t) => begin + (end - begin) * t;

  double _normalize(double progress) => ((progress % 1) + 1) % 1;
}
