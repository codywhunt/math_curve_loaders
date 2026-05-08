# Math Curve Loaders

Animated Flutter loading indicators drawn from parametric mathematical curves.

Live demo playground: https://codywhunt.github.io/math_curve_loaders/

`math_curve_loaders` gives you lightweight, dependency-free loaders with a
simple widget API and a small catalog of curve families: rose curves, Lissajous
curves, cardioids, hypotrochoids, epicycloids, Cassini ovals, lemniscates,
spirals, Fourier-style flows, butterflies, heart waves, astroids,
superellipses, torus-knot projections, and custom paths.

## Features

- Named constructors for fourteen curated mathematical loader presets.
- A `MathCurveLoader.custom` escape hatch for your own normalized curve builder,
  including open paths.
- Theme-aware color defaults using `ColorScheme.primary`.
- Shared visual controls through `MathCurveLoaderStyle`.
- Reduced-motion support through `MediaQuery.disableAnimations`.
- Progress semantics by default, with an opt-out for decorative loaders.
- No runtime dependencies beyond Flutter.

## Getting started

Add the package to your app:

```sh
flutter pub add math_curve_loaders
```

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

For open paths, set `closedPath` to `false` so the trail sweeps back and forth
instead of wrapping from the end of the path back to the beginning:

```dart
MathCurveLoader.custom(
  closedPath: false,
  curve: (progress, detailScale) {
    final x = 18 + progress * 64;
    final y = 50 + math.sin(progress * math.pi * 3) * 18;
    return Offset(x, y);
  },
)
```

You can also layer multiple custom loaders with `Stack` to draw more complex
marks, such as a faint static guide underneath a moving trail:

```dart
Stack(
  alignment: Alignment.center,
  children: [
    MathCurveLoader.custom(
      curve: logoOutline,
      animate: false,
      style: const MathCurveLoaderStyle(guideOpacity: 0.12),
    ),
    MathCurveLoader.custom(curve: logoOutline),
  ],
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
- `MathCurveLoader.butterfly`
- `MathCurveLoader.heartWave`
- `MathCurveLoader.astroid`
- `MathCurveLoader.superellipse`
- `MathCurveLoader.torusKnot`

## Inspiration

This package is a clean-room Flutter implementation inspired by the idea of
mathematical curve loading animations by PAIDAX01.
