/// Visual controls shared by every math curve loader preset.
///
/// The package intentionally keeps mathematical details in the preset
/// constructors and common visual details here, so app code stays readable.
class MathCurveLoaderStyle {
  /// Creates a style for math curve loaders.
  const MathCurveLoaderStyle({
    this.particleCount = 64,
    this.trailSpan = 0.38,
    this.strokeWidth = 4.8,
    this.guideOpacity = 0.10,
    this.minParticleOpacity = 0.04,
    this.maxParticleOpacity = 1.0,
    this.minParticleRadius = 0.9,
    this.maxParticleRadius = 3.6,
  })  : assert(particleCount > 1),
        assert(trailSpan > 0 && trailSpan <= 1),
        assert(strokeWidth > 0),
        assert(guideOpacity >= 0 && guideOpacity <= 1),
        assert(minParticleOpacity >= 0 && minParticleOpacity <= 1),
        assert(maxParticleOpacity >= 0 && maxParticleOpacity <= 1),
        assert(minParticleOpacity <= maxParticleOpacity),
        assert(minParticleRadius > 0),
        assert(maxParticleRadius > 0),
        assert(minParticleRadius <= maxParticleRadius);

  /// Default style tuned for small and medium loading indicators.
  static const defaults = MathCurveLoaderStyle();

  /// Number of particles in the animated trail.
  final int particleCount;

  /// How far back the particle trail stretches around the curve.
  final double trailSpan;

  /// Width of the faint curve guide, measured on the normalized 100x100 canvas.
  final double strokeWidth;

  /// Opacity of the faint guide path.
  final double guideOpacity;

  /// Opacity of the oldest particle in the trail.
  final double minParticleOpacity;

  /// Opacity of the leading particle in the trail.
  final double maxParticleOpacity;

  /// Radius of the oldest particle, measured on the normalized 100x100 canvas.
  final double minParticleRadius;

  /// Radius of the leading particle, measured on the normalized 100x100 canvas.
  final double maxParticleRadius;

  /// Creates a copy with selected fields changed.
  MathCurveLoaderStyle copyWith({
    int? particleCount,
    double? trailSpan,
    double? strokeWidth,
    double? guideOpacity,
    double? minParticleOpacity,
    double? maxParticleOpacity,
    double? minParticleRadius,
    double? maxParticleRadius,
  }) {
    return MathCurveLoaderStyle(
      particleCount: particleCount ?? this.particleCount,
      trailSpan: trailSpan ?? this.trailSpan,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      guideOpacity: guideOpacity ?? this.guideOpacity,
      minParticleOpacity: minParticleOpacity ?? this.minParticleOpacity,
      maxParticleOpacity: maxParticleOpacity ?? this.maxParticleOpacity,
      minParticleRadius: minParticleRadius ?? this.minParticleRadius,
      maxParticleRadius: maxParticleRadius ?? this.maxParticleRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MathCurveLoaderStyle &&
            other.particleCount == particleCount &&
            other.trailSpan == trailSpan &&
            other.strokeWidth == strokeWidth &&
            other.guideOpacity == guideOpacity &&
            other.minParticleOpacity == minParticleOpacity &&
            other.maxParticleOpacity == maxParticleOpacity &&
            other.minParticleRadius == minParticleRadius &&
            other.maxParticleRadius == maxParticleRadius;
  }

  @override
  int get hashCode => Object.hash(
        particleCount,
        trailSpan,
        strokeWidth,
        guideOpacity,
        minParticleOpacity,
        maxParticleOpacity,
        minParticleRadius,
        maxParticleRadius,
      );
}
