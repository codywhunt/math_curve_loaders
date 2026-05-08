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
}
