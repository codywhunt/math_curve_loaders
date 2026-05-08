import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_curve_loaders/math_curve_loaders.dart';
import 'package:math_curve_loaders/src/math_curve_painter.dart';

void main() {
  group('MathCurveLoader presets', () {
    final presets = <String, Widget Function()>{
      'rose': () => MathCurveLoader.rose(),
      'lissajous': () => MathCurveLoader.lissajous(),
      'cardioid': () => MathCurveLoader.cardioid(),
      'hypotrochoid': () => MathCurveLoader.hypotrochoid(),
      'epicycloid': () => MathCurveLoader.epicycloid(),
      'cassiniOval': () => MathCurveLoader.cassiniOval(),
      'lemniscate': () => MathCurveLoader.lemniscate(),
      'spiral': () => MathCurveLoader.spiral(),
      'fourierFlow': () => MathCurveLoader.fourierFlow(),
    };

    for (final entry in presets.entries) {
      testWidgets('renders ${entry.key}', (tester) async {
        await tester.pumpWidget(_TestApp(child: entry.value()));

        expect(find.byType(MathCurveLoader), findsOneWidget);
        expect(_loaderCustomPaintFinder, findsOneWidget);
      });
    }
  });

  testWidgets('renders a custom curve builder', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: MathCurveLoader.custom(
          curve: (progress, detailScale) {
            final t = progress * math.pi * 2;
            final r = 20 + detailScale * 4;
            return Offset(50 + math.cos(t) * r, 50 + math.sin(t * 2) * r);
          },
        ),
      ),
    );

    expect(find.byType(MathCurveLoader), findsOneWidget);
    expect(_loaderCustomPaintFinder, findsOneWidget);
  });

  testWidgets('uses a static painter animation when reduced motion is enabled',
      (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        disableAnimations: true,
        child: MathCurveLoader.rose(),
      ),
    );

    final customPaint = tester.widget<CustomPaint>(_loaderCustomPaintFinder);
    final painter = customPaint.painter as MathCurvePainter;

    expect(painter.progress, isA<AlwaysStoppedAnimation<double>>());
  });

  testWidgets('exposes progress semantics by default', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        _TestApp(child: MathCurveLoader.rose(semanticLabel: 'Loading curves')),
      );

      final semanticsNode = tester.getSemantics(
        find.bySemanticsLabel('Loading curves'),
      );

      expect(semanticsNode.label, 'Loading curves');
      expect(semanticsNode.value, 'In progress');
      expect(semanticsNode.flagsCollection.isLiveRegion, isTrue);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('can be excluded from semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        _TestApp(
          child: MathCurveLoader.rose(
            semanticLabel: 'Decorative loading curves',
            excludeFromSemantics: true,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Decorative loading curves'), findsNothing);
    } finally {
      semantics.dispose();
    }
  });

  test('style validates its public ranges', () {
    expect(
      () => MathCurveLoaderStyle(particleCount: 1),
      throwsAssertionError,
    );
    expect(
      () => MathCurveLoaderStyle(trailSpan: 1.2),
      throwsAssertionError,
    );
    expect(
      () => MathCurveLoaderStyle(
          minParticleOpacity: 0.8, maxParticleOpacity: 0.4),
      throwsAssertionError,
    );
    expect(
      () => MathCurveLoaderStyle(minParticleRadius: 4, maxParticleRadius: 3),
      throwsAssertionError,
    );
  });

  test('default preset curves stay finite and near the normalized canvas', () {
    final curves = <String, MathCurvePointBuilder>{
      'rose': MathLoaderCurves.rose(),
      'lissajous': MathLoaderCurves.lissajous(),
      'cardioid': MathLoaderCurves.cardioid(),
      'hypotrochoid': MathLoaderCurves.hypotrochoid(),
      'epicycloid': MathLoaderCurves.epicycloid(),
      'cassiniOval': MathLoaderCurves.cassiniOval(),
      'lemniscate': MathLoaderCurves.lemniscate(),
      'spiral': MathLoaderCurves.spiral(),
      'fourierFlow': MathLoaderCurves.fourierFlow(),
    };

    for (final entry in curves.entries) {
      for (var sample = 0; sample <= 100; sample++) {
        final point = entry.value(sample / 100, 1);

        expect(point.dx.isFinite, isTrue, reason: '${entry.key} x is finite');
        expect(point.dy.isFinite, isTrue, reason: '${entry.key} y is finite');
        expect(point.dx, inInclusiveRange(-5, 105),
            reason: '${entry.key} x bounds');
        expect(point.dy, inInclusiveRange(-5, 105),
            reason: '${entry.key} y bounds');
      }
    }
  });

  test('default preset curves close smoothly at the animation seam', () {
    final curves = <String, MathCurvePointBuilder>{
      'rose': MathLoaderCurves.rose(),
      'lissajous': MathLoaderCurves.lissajous(),
      'cardioid': MathLoaderCurves.cardioid(),
      'hypotrochoid': MathLoaderCurves.hypotrochoid(),
      'epicycloid': MathLoaderCurves.epicycloid(),
      'cassiniOval': MathLoaderCurves.cassiniOval(),
      'lemniscate': MathLoaderCurves.lemniscate(),
      'spiral': MathLoaderCurves.spiral(),
      'fourierFlow': MathLoaderCurves.fourierFlow(),
    };

    for (final entry in curves.entries) {
      final start = entry.value(0, 1);
      final end = entry.value(1, 1);

      expect((start - end).distance, lessThan(0.001),
          reason: '${entry.key} seam distance');
    }
  });
}

final _loaderCustomPaintFinder = find.descendant(
  of: find.byType(MathCurveLoader),
  matching: find.byType(CustomPaint),
);

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.child,
    this.disableAnimations = false,
  });

  final Widget child;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Center(child: child),
      ),
    );
  }
}
