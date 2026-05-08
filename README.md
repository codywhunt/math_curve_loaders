# Math Curve Loaders

Animated Flutter loading indicators drawn from parametric mathematical curves.

`math_curve_loaders` gives you lightweight, dependency-free loaders with a
simple widget API and a small catalog of curve families: rose curves, Lissajous
curves, cardioids, hypotrochoids, epicycloids, Cassini ovals, lemniscates,
spirals, and Fourier-style flows.

## Features

- Named constructors for nine curated mathematical loader presets.
- A `MathCurveLoader.custom` escape hatch for your own normalized curve builder.
- Theme-aware color defaults using `ColorScheme.primary`.
- Shared visual controls through `MathCurveLoaderStyle`.
- Reduced-motion support through `MediaQuery.disableAnimations`.
- Progress semantics by default, with an opt-out for decorative loaders.
- No runtime dependencies beyond Flutter.

## Getting started

Add the package to your app:

```yaml
dependencies:
  math_curve_loaders:
    git:
      url: https://github.com/codywhunt/math_curve_loaders.git
```

The repository is private while the package is being prepared for pub.dev.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:math_curve_loaders/math_curve_loaders.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MathCurveLoader.rose(
        size: 96,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
```

Customize the shared visual style:

```dart
MathCurveLoader.lissajous(
  size: 112,
  duration: const Duration(milliseconds: 3600),
  style: const MathCurveLoaderStyle(
    particleCount: 80,
    trailSpan: 0.44,
    strokeWidth: 4,
    guideOpacity: 0.08,
  ),
)
```

Bring your own curve when you want a custom motion signature:

```dart
import 'dart:math' as math;

MathCurveLoader.custom(
  curve: (progress, detailScale) {
    final angle = progress * math.pi * 2;
    final radius = 24 + detailScale * 5;
    return Offset(
      50 + math.cos(angle) * radius,
      50 + math.sin(angle * 2) * radius * 0.6,
    );
  },
)
```

## Presets

- `MathCurveLoader.rose`
- `MathCurveLoader.lissajous`
- `MathCurveLoader.cardioid`
- `MathCurveLoader.hypotrochoid`
- `MathCurveLoader.epicycloid`
- `MathCurveLoader.cassiniOval`
- `MathCurveLoader.lemniscate`
- `MathCurveLoader.spiral`
- `MathCurveLoader.fourierFlow`

## Inspiration

This package is a clean-room Flutter implementation inspired by the idea of
mathematical curve loading animations. It does not copy code or assets from the
reference gallery.
