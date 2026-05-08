import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_curve_loaders/math_curve_loaders.dart';

void main() {
  testWidgets('renders a math curve loader', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: MathCurveLoader(curve: MathLoaderCurves.roseOrbit()),
        ),
      ),
    );

    expect(find.byType(MathCurveLoader), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(MathCurveLoader),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });
}
