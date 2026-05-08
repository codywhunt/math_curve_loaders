import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_curve_loaders_example/main.dart';

void main() {
  testWidgets('renders the example gallery', (tester) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MathCurveExampleApp());

    expect(find.text('THE COLLECTION'), findsOneWidget);
    expect(find.text('Rose'), findsOneWidget);
    expect(find.text('Fourier Flow'), findsOneWidget);
  });
}
