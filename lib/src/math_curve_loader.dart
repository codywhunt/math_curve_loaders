import 'package:flutter/material.dart';

import 'math_curve_curves.dart';
import 'math_curve_loader_style.dart';
import 'math_curve_painter.dart';

/// An animated loading indicator drawn from a parametric math curve.
class MathCurveLoader extends StatefulWidget {
  const MathCurveLoader._({
    super.key,
    required this.curve,
    this.size = 96,
    this.color,
    this.duration = const Duration(milliseconds: 4600),
    this.style = MathCurveLoaderStyle.defaults,
    this.semanticLabel = 'Loading',
    this.excludeFromSemantics = false,
    this.animate = true,
    this.reverse = false,
    this.respectReducedMotion = true,
  })  : assert(size > 0),
        assert(duration > Duration.zero);

  /// Creates a loader from a rose curve.
  factory MathCurveLoader.rose({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    int petals = 7,
    double radius = 27,
    double amplitude = 5.5,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.rose(
        petals: petals,
        radius: radius,
        amplitude: amplitude,
      ),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a Lissajous curve.
  factory MathCurveLoader.lissajous({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double xFrequency = 3,
    double yFrequency = 2,
    double phase = 1.5707963267948966,
    double radius = 28,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.lissajous(
        xFrequency: xFrequency,
        yFrequency: yFrequency,
        phase: phase,
        radius: radius,
      ),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a cardioid.
  factory MathCurveLoader.cardioid({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double radius = 17,
    double scale = 1.08,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.cardioid(radius: radius, scale: scale),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a hypotrochoid.
  factory MathCurveLoader.hypotrochoid({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double outerRadius = 26,
    double innerRadius = 7,
    double distance = 18,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.hypotrochoid(
        outerRadius: outerRadius,
        innerRadius: innerRadius,
        distance: distance,
      ),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from an epicycloid.
  factory MathCurveLoader.epicycloid({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double outerRadius = 13,
    double innerRadius = 5.2,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.epicycloid(
        outerRadius: outerRadius,
        innerRadius: innerRadius,
      ),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a Cassini oval.
  factory MathCurveLoader.cassiniOval({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double radius = 28,
    double pinch = 0.62,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.cassiniOval(radius: radius, pinch: pinch),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a lemniscate.
  factory MathCurveLoader.lemniscate({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double width = 34,
    double height = 22,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.lemniscate(width: width, height: height),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a breathing spiral.
  factory MathCurveLoader.spiral({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double turns = 2.6,
    double radius = 31,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.spiral(turns: turns, radius: radius),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a Fourier-style harmonic flow.
  factory MathCurveLoader.fourierFlow({
    Key? key,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
    double x1 = 17,
    double x3 = 7.5,
    double x5 = 3.2,
    double y1 = 15,
    double y2 = 8.2,
    double y4 = 4.2,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: MathLoaderCurves.fourierFlow(
        x1: x1,
        x3: x3,
        x5: x5,
        y1: y1,
        y2: y2,
        y4: y4,
      ),
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// Creates a loader from a custom normalized 100x100 curve builder.
  factory MathCurveLoader.custom({
    Key? key,
    required MathCurvePointBuilder curve,
    double size = 96,
    Color? color,
    Duration duration = const Duration(milliseconds: 4600),
    MathCurveLoaderStyle style = MathCurveLoaderStyle.defaults,
    String semanticLabel = 'Loading',
    bool excludeFromSemantics = false,
    bool animate = true,
    bool reverse = false,
    bool respectReducedMotion = true,
  }) {
    return MathCurveLoader._(
      key: key,
      curve: curve,
      size: size,
      color: color,
      duration: duration,
      style: style,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      animate: animate,
      reverse: reverse,
      respectReducedMotion: respectReducedMotion,
    );
  }

  /// The parametric curve used by the loader.
  final MathCurvePointBuilder curve;

  /// The square size of the loader.
  final double size;

  /// The loader color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Duration for one full trip around the curve.
  final Duration duration;

  /// Shared visual controls for the loader.
  final MathCurveLoaderStyle style;

  /// Accessibility label for the progress indicator.
  final String semanticLabel;

  /// Whether to remove this loader from the semantics tree.
  final bool excludeFromSemantics;

  /// Whether the loader should animate.
  final bool animate;

  /// Whether the animated trail should move backward.
  final bool reverse;

  /// Whether to honor [MediaQueryData.disableAnimations].
  final bool respectReducedMotion;

  @override
  State<MathCurveLoader> createState() => _MathCurveLoaderState();
}

class _MathCurveLoaderState extends State<MathCurveLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _wasAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant MathCurveLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (_wasAnimating) {
        _controller.repeat();
      }
    }

    _syncAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final shouldAnimate = _shouldAnimate(context);
    final progress = shouldAnimate
        ? widget.reverse
            ? ReverseAnimation(_controller)
            : _controller
        : MathCurvePainter.staticAnimation(reverse: widget.reverse);

    final loader = SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(
        painter: MathCurvePainter(
          progress: progress,
          curve: widget.curve,
          color: color,
          style: widget.style,
        ),
      ),
    );

    if (widget.excludeFromSemantics) {
      return ExcludeSemantics(child: loader);
    }

    return Semantics(
      label: widget.semanticLabel,
      value: 'In progress',
      liveRegion: true,
      child: loader,
    );
  }

  void _syncAnimation() {
    final shouldAnimate = _shouldAnimate(context);
    if (shouldAnimate == _wasAnimating) {
      return;
    }

    _wasAnimating = shouldAnimate;

    if (shouldAnimate) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  bool _shouldAnimate(BuildContext context) {
    if (!widget.animate) {
      return false;
    }

    if (!widget.respectReducedMotion) {
      return true;
    }

    return !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
  }
}
