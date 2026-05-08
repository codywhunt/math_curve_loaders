import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Calculates a point on a normalized 100x100 curve canvas.
typedef MathCurvePointBuilder =
    Offset Function(double progress, double detailScale);

/// Preset parametric curves that work well as loading animations.
class MathLoaderCurves {
  const MathLoaderCurves._();

  /// A soft rose-style orbit inspired by mathematical flower curves.
  static MathCurvePointBuilder roseOrbit({
    int petals = 7,
    double baseRadius = 7,
    double detailAmplitude = 3,
    double scale = 3.9,
  }) {
    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final x =
          baseRadius * math.cos(t) -
          detailAmplitude * detailScale * math.cos(petals * t);
      final y =
          baseRadius * math.sin(t) -
          detailAmplitude * detailScale * math.sin(petals * t);

      return Offset(50 + x * scale, 50 + y * scale);
    };
  }

  /// A looping Lissajous curve with a calm figure-eight feel.
  static MathCurvePointBuilder lissajous({
    double xFrequency = 3,
    double yFrequency = 2,
    double phase = math.pi / 2,
    double radius = 28,
  }) {
    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final pulse = 0.9 + detailScale * 0.16;

      return Offset(
        50 + math.sin(xFrequency * t + phase) * radius * pulse,
        50 + math.sin(yFrequency * t) * radius * pulse,
      );
    };
  }

  /// A small cardioid that gently breathes as it loops.
  static MathCurvePointBuilder cardioid({
    double radius = 18,
    double scale = 1.05,
  }) {
    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final r = radius * (1 - math.sin(t)) * (0.86 + detailScale * 0.22);

      return Offset(50 + math.cos(t) * r * scale, 54 + math.sin(t) * r * scale);
    };
  }

  /// A Fourier-style curve with several harmonics mixed together.
  static MathCurvePointBuilder fourierFlow({
    double x1 = 17,
    double x3 = 7.5,
    double x5 = 3.2,
    double y1 = 15,
    double y2 = 8.2,
    double y4 = 4.2,
  }) {
    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final mix = 1 + detailScale * 0.16;
      final x =
          x1 * math.cos(t) +
          x3 * math.cos(3 * t + 0.6 * mix) +
          x5 * math.sin(5 * t - 0.4);
      final y =
          y1 * math.sin(t) +
          y2 * math.sin(2 * t + 0.25) -
          y4 * math.cos(4 * t - 0.5 * mix);

      return Offset(50 + x, 50 + y);
    };
  }
}

/// An animated loading indicator drawn from a parametric math curve.
class MathCurveLoader extends StatefulWidget {
  const MathCurveLoader({
    super.key,
    required this.curve,
    this.size = 96,
    this.color,
    this.particleCount = 64,
    this.trailSpan = 0.38,
    this.strokeWidth = 4.8,
    this.duration = const Duration(milliseconds: 4600),
    this.semanticLabel = 'Loading',
  }) : assert(size > 0),
       assert(particleCount > 1),
       assert(trailSpan > 0 && trailSpan <= 1),
       assert(strokeWidth > 0);

  /// The parametric curve used by the loader.
  final MathCurvePointBuilder curve;

  /// The square size of the loader.
  final double size;

  /// The loader color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Number of particles in the moving trail.
  final int particleCount;

  /// How far back the particle trail stretches around the curve.
  final double trailSpan;

  /// Width of the faint curve guide.
  final double strokeWidth;

  /// Duration for one full trip around the curve.
  final Duration duration;

  /// Accessibility label for the progress indicator.
  final String semanticLabel;

  @override
  State<MathCurveLoader> createState() => _MathCurveLoaderState();
}

class _MathCurveLoaderState extends State<MathCurveLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant MathCurveLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return Semantics(
      label: widget.semanticLabel,
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          painter: _MathCurveLoaderPainter(
            animation: _controller,
            curve: widget.curve,
            color: color,
            particleCount: widget.particleCount,
            trailSpan: widget.trailSpan,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _MathCurveLoaderPainter extends CustomPainter {
  _MathCurveLoaderPainter({
    required this.animation,
    required this.curve,
    required this.color,
    required this.particleCount,
    required this.trailSpan,
    required this.strokeWidth,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final MathCurvePointBuilder curve;
  final Color color;
  final int particleCount;
  final double trailSpan;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final scale = side / 100;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);

    Offset mapPoint(Offset point) {
      return origin + Offset(point.dx * scale, point.dy * scale);
    }

    final detailScale = _detailScale(animation.value);
    final path = Path();

    for (var index = 0; index <= 360; index++) {
      final point = mapPoint(curve(index / 360, detailScale));
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = strokeWidth * scale,
    );

    for (var index = 0; index < particleCount; index++) {
      final tailOffset = index / (particleCount - 1);
      final progress = _normalize(animation.value - tailOffset * trailSpan);
      final fade = math.pow(1 - tailOffset, 0.56).toDouble();
      final point = mapPoint(curve(progress, detailScale));

      canvas.drawCircle(
        point,
        (0.9 + fade * 2.7) * scale,
        Paint()..color = color.withValues(alpha: 0.04 + fade * 0.96),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MathCurveLoaderPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.curve != curve ||
        oldDelegate.color != color ||
        oldDelegate.particleCount != particleCount ||
        oldDelegate.trailSpan != trailSpan ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  double _detailScale(double progress) {
    final pulseAngle = progress * math.pi * 2;
    return 0.52 + ((math.sin(pulseAngle + 0.55) + 1) / 2) * 0.48;
  }

  double _normalize(double progress) => ((progress % 1) + 1) % 1;
}
