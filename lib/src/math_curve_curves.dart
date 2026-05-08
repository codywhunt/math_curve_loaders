import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Calculates a point on a normalized 100x100 curve canvas.
///
/// The [progress] value is normalized from 0 to 1. The [detailScale] value is
/// a soft pulse, also controlled by the loader, that presets can use to breathe
/// without changing their public API.
typedef MathCurvePointBuilder = Offset Function(
    double progress, double detailScale);

/// Preset parametric curves that work well as loading animations.
///
/// Most users should prefer the named constructors on the loader widget. This
/// class stays public so custom loaders can compose the built-in curves.
class MathLoaderCurves {
  const MathLoaderCurves._();

  /// A rose curve with a soft orbiting trail.
  static MathCurvePointBuilder rose({
    int petals = 7,
    double radius = 27,
    double amplitude = 5.5,
  }) {
    assert(petals > 0);
    assert(radius > 0);
    assert(amplitude >= 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final r = radius + amplitude * detailScale * math.cos(petals * t);

      return Offset(50 + math.cos(t) * r, 50 + math.sin(t) * r);
    };
  }

  /// A Lissajous curve with independent horizontal and vertical frequencies.
  static MathCurvePointBuilder lissajous({
    double xFrequency = 3,
    double yFrequency = 2,
    double phase = math.pi / 2,
    double radius = 28,
  }) {
    assert(xFrequency > 0);
    assert(yFrequency > 0);
    assert(radius > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final pulse = 0.92 + detailScale * 0.12;

      return Offset(
        50 + math.sin(xFrequency * t + phase) * radius * pulse,
        50 + math.sin(yFrequency * t) * radius * pulse,
      );
    };
  }

  /// A cardioid that gently expands and contracts as it loops.
  static MathCurvePointBuilder cardioid({
    double radius = 17,
    double scale = 1.08,
  }) {
    assert(radius > 0);
    assert(scale > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final r = radius * (1 - math.sin(t)) * (0.88 + detailScale * 0.20);

      return Offset(50 + math.cos(t) * r * scale, 55 + math.sin(t) * r * scale);
    };
  }

  /// A hypotrochoid traced by a point inside a rolling circle.
  static MathCurvePointBuilder hypotrochoid({
    double outerRadius = 28,
    double innerRadius = 7,
    double distance = 18,
  }) {
    assert(outerRadius > 0);
    assert(innerRadius > 0);
    assert(distance > 0);
    assert(outerRadius != innerRadius);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final delta = outerRadius - innerRadius;
      final ratio = delta / innerRadius;
      final d = distance * (0.92 + detailScale * 0.12);
      final x = delta * math.cos(t) + d * math.cos(ratio * t);
      final y = delta * math.sin(t) - d * math.sin(ratio * t);

      return Offset(50 + x * 0.82, 50 + y * 0.82);
    };
  }

  /// An epicycloid traced by a point outside a rolling circle.
  static MathCurvePointBuilder epicycloid({
    double outerRadius = 15.6,
    double innerRadius = 5.2,
  }) {
    assert(outerRadius > 0);
    assert(innerRadius > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final sum = outerRadius + innerRadius;
      final ratio = sum / innerRadius;
      final pulse = 0.88 + detailScale * 0.16;
      final x = sum * math.cos(t) - innerRadius * math.cos(ratio * t);
      final y = sum * math.sin(t) - innerRadius * math.sin(ratio * t);

      return Offset(50 + x * pulse, 50 + y * pulse);
    };
  }

  /// A Cassini oval with a figure-eight personality.
  static MathCurvePointBuilder cassiniOval({
    double radius = 28,
    double pinch = 0.62,
  }) {
    assert(radius > 0);
    assert(pinch > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final wave = math.sqrt((math.cos(2 * t).abs() + pinch) / (1 + pinch));
      final pulse = 0.9 + detailScale * 0.12;
      final r = radius * wave * pulse;

      return Offset(50 + math.cos(t) * r, 50 + math.sin(t) * r);
    };
  }

  /// A Bernoulli-style lemniscate.
  static MathCurvePointBuilder lemniscate({
    double width = 34,
    double height = 22,
  }) {
    assert(width > 0);
    assert(height > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final denominator = 1 + math.sin(t) * math.sin(t);
      final pulse = 0.92 + detailScale * 0.12;
      final x = width * math.cos(t) / denominator;
      final y = height * math.sin(t) * math.cos(t) / denominator;

      return Offset(50 + x * pulse, 50 + y * pulse);
    };
  }

  /// A breathing spiral that wraps in and out around the center.
  static MathCurvePointBuilder spiral({
    double turns = 3,
    double radius = 31,
  }) {
    assert(turns > 0);
    assert(radius > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2 * turns;
      final wave = 0.5 - 0.5 * math.cos(progress * math.pi * 2);
      final r = radius * (0.18 + wave * 0.82) * (0.92 + detailScale * 0.10);

      return Offset(50 + math.cos(t) * r, 50 + math.sin(t) * r);
    };
  }

  /// A Fourier-style flow made from several harmonics.
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
      final x = x1 * math.cos(t) +
          x3 * math.cos(3 * t + 0.6 * mix) +
          x5 * math.sin(5 * t - 0.4);
      final y = y1 * math.sin(t) +
          y2 * math.sin(2 * t + 0.25) -
          y4 * math.cos(4 * t - 0.5 * mix);

      return Offset(50 + x, 50 + y);
    };
  }

  /// A compact butterfly-inspired curve with wing-like lobes.
  static MathCurvePointBuilder butterfly({
    double turns = 12,
    double scale = 4.6,
    double pulse = 0.45,
    double cosWeight = 2,
    int power = 5,
  }) {
    assert(turns > 0);
    assert(scale > 0);
    assert(pulse >= 0);
    assert(cosWeight >= 0);
    assert(power > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * turns;
      final envelope = math.exp(math.cos(t)) -
          cosWeight * math.cos(4 * t) -
          math.pow(math.sin(t / 12), power).toDouble();
      final animatedScale = scale + detailScale * pulse;

      return Offset(
        50 + math.sin(t) * envelope * animatedScale,
        50 + math.cos(t) * envelope * animatedScale,
      );
    };
  }

  /// A heart-shaped wave drawn from an explicit x/y curve.
  static MathCurvePointBuilder heartWave({
    double frequency = 6.4,
    double rootSpan = 3.3,
    double amplitude = 0.9,
    double scaleX = 23.2,
    double scaleY = 24.5,
  }) {
    assert(frequency > 0);
    assert(rootSpan > 0);
    assert(amplitude >= 0);
    assert(scaleX > 0);
    assert(scaleY > 0);

    return (progress, detailScale) {
      final limit = math.sqrt(rootSpan);
      final x = -limit + progress * limit * 2;
      final safeRoot = math.max(0.0, rootSpan - x * x);
      final wave =
          amplitude * math.sqrt(safeRoot) * math.sin(frequency * math.pi * x);
      final envelope = math.pow(x.abs(), 2 / 3).toDouble();
      final y = envelope + wave;

      return Offset(
        50 + x * scaleX,
        18 + (1.75 - y) * (scaleY + detailScale * 1.5),
      );
    };
  }

  /// A four-cusped astroid curve.
  static MathCurvePointBuilder astroid({
    double radius = 32,
    double squareness = 2.6,
  }) {
    assert(radius > 0);
    assert(squareness > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final pulse = 0.9 + detailScale * 0.12;
      final x = _signedPow(math.cos(t), squareness);
      final y = _signedPow(math.sin(t), squareness);

      return Offset(50 + x * radius * pulse, 50 + y * radius * pulse);
    };
  }

  /// A superellipse that can move between diamond, ellipse, and squircle.
  static MathCurvePointBuilder superellipse({
    double width = 31,
    double height = 26,
    double exponent = 3.6,
  }) {
    assert(width > 0);
    assert(height > 0);
    assert(exponent > 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final roundness = ((exponent - 1) / 7).clamp(0.0, 1.0);
      final pulse = 0.9 + detailScale * 0.12;
      final diagonalInflation = 1 + roundness * 0.22 * _squaredSin(2 * t);
      final x = math.cos(t) * diagonalInflation;
      final y = math.sin(t) * diagonalInflation;

      return Offset(50 + x * width * pulse, 50 + y * height * pulse);
    };
  }

  /// A 2D projection of a torus-knot-like loop.
  static MathCurvePointBuilder torusKnot({
    int p = 2,
    int q = 3,
    double radius = 20,
    double tube = 8,
  }) {
    assert(p > 0);
    assert(q > 0);
    assert(radius > 0);
    assert(tube >= 0);

    return (progress, detailScale) {
      final t = progress * math.pi * 2;
      final pulse = 0.88 + detailScale * 0.16;
      final r = radius + tube * math.cos(q * t);
      final x = r * math.cos(p * t);
      final y = r * math.sin(p * t) + tube * math.sin(q * t) * 0.72;

      return Offset(50 + x * pulse, 50 + y * pulse);
    };
  }

  static double _signedPow(double value, double exponent) {
    final sign = value < 0 ? -1 : 1;
    return sign * math.pow(value.abs(), exponent).toDouble();
  }

  static double _squaredSin(double value) {
    final sine = math.sin(value);
    return sine * sine;
  }
}
