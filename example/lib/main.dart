import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:math_curve_loaders/math_curve_loaders.dart';

void main() {
  runApp(const MathCurveExampleApp());
}

class MathCurveExampleApp extends StatefulWidget {
  const MathCurveExampleApp({super.key});

  @override
  State<MathCurveExampleApp> createState() => _MathCurveExampleAppState();
}

class _MathCurveExampleAppState extends State<MathCurveExampleApp> {
  bool _isLight = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Curve Loaders',
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isLight ? Brightness.light : Brightness.dark,
        fontFamily: 'SF Pro Display',
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: Material(
        type: MaterialType.transparency,
        child: _GalleryPage(
          isLight: _isLight,
          onToggleTheme: () => setState(() => _isLight = !_isLight),
        ),
      ),
    );
  }
}

class _GalleryPage extends StatelessWidget {
  const _GalleryPage({required this.isLight, required this.onToggleTheme});

  final bool isLight;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final tokens = _Tokens.fromBrightness(isLight);

    return _TokensScope(
      tokens: tokens,
      child: ColoredBox(
        color: tokens.background,
        child: Stack(
          children: [
            Positioned(
              top: -220,
              left: -80,
              right: -80,
              child: IgnorePointer(
                child: Container(
                  height: 520,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        tokens.radialGlow,
                        tokens.background.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.72],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: _HeroHeader(
                            isLight: isLight,
                            onToggleTheme: onToggleTheme,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.crossAxisExtent;
                        final columns = width >= 1040
                            ? 3
                            : width >= 720
                            ? 2
                            : 1;

                        return SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                mainAxisExtent: 292,
                              ),
                          itemCount: _presets.length,
                          itemBuilder: (context, index) {
                            final preset = _presets[index];
                            return _LoaderCard(
                              preset: preset,
                              onTap: () => _openPresetViewer(context, preset),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPresetViewer(BuildContext context, _LoaderPreset preset) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close loader preview',
      barrierColor: Colors.black.withValues(alpha: isLight ? 0.24 : 0.74),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: _TokensScope(
            tokens: _Tokens.fromBrightness(isLight),
            child: _PresetViewer(preset: preset),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final eased = Curves.easeOutCubic.transform(animation.value);
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(scale: 0.96 + eased * 0.04, child: child),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.isLight, required this.onToggleTheme});

  final bool isLight;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _PillButton(
              icon: isLight ? LucideIcons.moon : LucideIcons.sun,
              label: isLight ? 'Dark' : 'Light',
              onTap: onToggleTheme,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('MATHEMATICAL CURVE MOTION', style: tokens.eyebrow),
        const SizedBox(height: 10),
        Text(
          'A Gallery of Mathematical Loading Animations',
          style: tokens.title,
        ),
        const SizedBox(height: 12),
        Text(
          'Browse every preset, open a focused preview, tune the shared style, '
          'and copy a Flutter snippet that mirrors the current settings.',
          style: tokens.body,
        ),
      ],
    );
  }
}

class _LoaderCard extends StatefulWidget {
  const _LoaderCard({required this.preset, required this.onTap});

  final _LoaderPreset preset;
  final VoidCallback onTap;

  @override
  State<_LoaderCard> createState() => _LoaderCardState();
}

class _LoaderCardState extends State<_LoaderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final settings = _LoaderSettings.defaults(color: widget.preset.color);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: tokens.panel,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered ? tokens.borderStrong : tokens.border,
            ),
            boxShadow: [
              BoxShadow(
                color: tokens.shadow,
                blurRadius: _hovered ? 48 : 36,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PreviewFrame(
                  child: _buildLoader(widget.preset, settings, size: 116),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(widget.preset.title, style: tokens.cardTitle),
                  ),
                  Text(widget.preset.tag, style: tokens.tag),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.preset.description,
                style: tokens.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetViewer extends StatefulWidget {
  const _PresetViewer({required this.preset});

  final _LoaderPreset preset;

  @override
  State<_PresetViewer> createState() => _PresetViewerState();
}

class _PresetViewerState extends State<_PresetViewer> {
  late _LoaderSettings _settings = _LoaderSettings.defaults(
    color: widget.preset.color,
  );

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 820;
                final preview = _ViewerPreview(
                  preset: widget.preset,
                  settings: _settings,
                  onSettingsChanged: (settings) {
                    setState(() => _settings = settings);
                  },
                  onReset: () {
                    setState(() {
                      _settings = _LoaderSettings.defaults(
                        color: widget.preset.color,
                      );
                    });
                  },
                );
                final code = _CodePanel(
                  preset: widget.preset,
                  settings: _settings,
                );

                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadow,
                        blurRadius: 64,
                        offset: const Offset(0, 30),
                      ),
                    ],
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 11, child: preview),
                            const SizedBox(width: 14),
                            Expanded(flex: 9, child: code),
                          ],
                        )
                      : Column(
                          children: [preview, const SizedBox(height: 14), code],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerPreview extends StatelessWidget {
  const _ViewerPreview({
    required this.preset,
    required this.settings,
    required this.onSettingsChanged,
    required this.onReset,
  });

  final _LoaderPreset preset;
  final _LoaderSettings settings;
  final ValueChanged<_LoaderSettings> onSettingsChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewFrame(
            large: true,
            child: _buildLoader(preset, settings, size: settings.size),
          ),
          const SizedBox(height: 16),
          Text(preset.tag, style: tokens.eyebrow),
          const SizedBox(height: 8),
          Text(preset.title, style: tokens.modalTitle),
          const SizedBox(height: 10),
          Text(preset.description, style: tokens.body),
          const SizedBox(height: 18),
          _SectionHeader(
            title: 'Controls',
            action: _PillButton(
              icon: LucideIcons.rotateCcw,
              label: 'Reset',
              onTap: onReset,
            ),
          ),
          const SizedBox(height: 10),
          _ResponsiveControls(
            children: [
              _NumberControl(
                label: 'Size',
                value: settings.size,
                min: 72,
                max: 220,
                divisions: 37,
                suffix: 'px',
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(size: value)),
              ),
              _NumberControl(
                label: 'Duration',
                value: settings.durationMs.toDouble(),
                min: 1200,
                max: 7200,
                divisions: 30,
                suffix: 'ms',
                onChanged: (value) => onSettingsChanged(
                  settings.copyWith(durationMs: value.round()),
                ),
              ),
              _NumberControl(
                label: 'Particles',
                value: settings.particleCount.toDouble(),
                min: 16,
                max: 120,
                divisions: 26,
                suffix: '',
                onChanged: (value) => onSettingsChanged(
                  settings.copyWith(particleCount: value.round()),
                ),
              ),
              _NumberControl(
                label: 'Trail span',
                value: settings.trailSpan,
                min: 0.12,
                max: 0.90,
                divisions: 39,
                suffix: '',
                precision: 2,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(trailSpan: value)),
              ),
              _NumberControl(
                label: 'Stroke',
                value: settings.strokeWidth,
                min: 1,
                max: 9,
                divisions: 32,
                suffix: '',
                precision: 1,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(strokeWidth: value)),
              ),
              _ColorControl(
                selected: settings.color,
                onChanged: (color) =>
                    onSettingsChanged(settings.copyWith(color: color)),
              ),
              _ToggleControl(
                label: 'Animate',
                value: settings.animate,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(animate: value)),
              ),
              _ToggleControl(
                label: 'Reverse',
                value: settings.reverse,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(reverse: value)),
              ),
              _ToggleControl(
                label: 'Reduced motion',
                value: settings.reducedMotion,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(reducedMotion: value)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SectionHeader(title: 'Formula'),
          const SizedBox(height: 10),
          _FormulaNote(text: preset.formulaNote),
        ],
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.preset, required this.settings});

  final _LoaderPreset preset;
  final _LoaderSettings settings;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final snippet = _snippetFor(preset, settings);

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Code', style: tokens.eyebrow)),
              _PillButton(
                icon: LucideIcons.copy,
                label: 'Copy',
                onTap: () => Clipboard.setData(ClipboardData(text: snippet)),
              ),
              const SizedBox(width: 8),
              _PillButton(
                icon: LucideIcons.x,
                label: 'Close',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 360),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.codeBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: tokens.border),
            ),
            child: SingleChildScrollView(
              child: SelectableText(snippet, style: tokens.code),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveControls extends StatelessWidget {
  const _ResponsiveControls({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 2 : 1;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final child in children)
              SizedBox(
                width: (constraints.maxWidth - (columns - 1) * 10) / columns,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class _NumberControl extends StatelessWidget {
  const _NumberControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
    this.precision = 0,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final int precision;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final display = precision == 0
        ? value.round().toString()
        : value.toStringAsFixed(precision);

    return _ControlShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: tokens.controlLabel)),
              Text('$display$suffix', style: tokens.monoValue),
            ],
          ),
          const SizedBox(height: 8),
          Material(
            type: MaterialType.transparency,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: tokens.text,
                inactiveTrackColor: tokens.borderStrong,
                thumbColor: tokens.text,
                overlayColor: tokens.text.withValues(alpha: 0.08),
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorControl extends StatelessWidget {
  const _ColorControl({required this.selected, required this.onChanged});

  final Color selected;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return _ControlShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: tokens.controlLabel),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final color in _swatches)
                GestureDetector(
                  onTap: () => onChanged(color.color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.color,
                      border: Border.all(
                        color: selected == color.color
                            ? tokens.text
                            : tokens.borderStrong,
                        width: selected == color.color ? 2 : 1,
                      ),
                      boxShadow: [
                        if (selected == color.color)
                          BoxShadow(
                            color: color.color.withValues(alpha: 0.30),
                            blurRadius: 14,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleControl extends StatelessWidget {
  const _ToggleControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return _ControlShell(
      child: Row(
        children: [
          Expanded(child: Text(label, style: tokens.controlLabel)),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 46,
              height: 26,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: value ? tokens.text : tokens.borderStrong,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? tokens.background : tokens.panel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlShell extends StatelessWidget {
  const _ControlShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.control,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Row(
      children: [
        Expanded(child: Text(title, style: tokens.sectionTitle)),
        ?action,
      ],
    );
  }
}

class _FormulaNote extends StatelessWidget {
  const _FormulaNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.control,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border),
      ),
      child: Text(text, style: tokens.formula),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.child, this.large = false});

  final Widget child;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: large ? 318 : 178),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(large ? 16 : 14),
        color: tokens.preview,
        gradient: RadialGradient(
          colors: [tokens.previewGlow, tokens.preview],
          stops: const [0, 0.72],
        ),
      ),
      child: Center(child: child),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.border),
      ),
      child: child,
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: tokens.pill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: tokens.borderStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: tokens.text),
            const SizedBox(width: 7),
            Text(label, style: tokens.pillText),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoader(
  _LoaderPreset preset,
  _LoaderSettings settings, {
  double? size,
}) {
  final style = MathCurveLoaderStyle(
    particleCount: settings.particleCount,
    trailSpan: settings.trailSpan,
    strokeWidth: settings.strokeWidth,
  );
  final loaderSize = size ?? settings.size;

  Widget loader;
  switch (preset.id) {
    case 'rose':
      loader = MathCurveLoader.rose(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'lissajous':
      loader = MathCurveLoader.lissajous(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'cardioid':
      loader = MathCurveLoader.cardioid(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'hypotrochoid':
      loader = MathCurveLoader.hypotrochoid(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'epicycloid':
      loader = MathCurveLoader.epicycloid(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'cassiniOval':
      loader = MathCurveLoader.cassiniOval(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'lemniscate':
      loader = MathCurveLoader.lemniscate(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'spiral':
      loader = MathCurveLoader.spiral(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    case 'fourierFlow':
      loader = MathCurveLoader.fourierFlow(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
    default:
      loader = MathCurveLoader.rose(
        size: loaderSize,
        color: settings.color,
        duration: Duration(milliseconds: settings.durationMs),
        style: style,
        animate: settings.animate,
        reverse: settings.reverse,
      );
  }

  return MediaQuery(
    data: MediaQueryData(disableAnimations: settings.reducedMotion),
    child: loader,
  );
}

String _snippetFor(_LoaderPreset preset, _LoaderSettings settings) {
  final colorName = _colorName(settings.color);
  return '''
MathCurveLoader.${preset.id == 'cassiniOval' ? 'cassiniOval' : preset.id}(
  size: ${settings.size.round()},
  color: $colorName,
  duration: const Duration(milliseconds: ${settings.durationMs}),
  style: const MathCurveLoaderStyle(
    particleCount: ${settings.particleCount},
    trailSpan: ${settings.trailSpan.toStringAsFixed(2)},
    strokeWidth: ${settings.strokeWidth.toStringAsFixed(1)},
  ),
  animate: ${settings.animate},
  reverse: ${settings.reverse},
)''';
}

String _colorName(Color color) {
  final swatch = _swatches.firstWhere(
    (swatch) => swatch.color == color,
    orElse: () => _swatches.first,
  );
  return swatch.code;
}

class _LoaderSettings {
  const _LoaderSettings({
    required this.size,
    required this.durationMs,
    required this.color,
    required this.particleCount,
    required this.trailSpan,
    required this.strokeWidth,
    required this.animate,
    required this.reverse,
    required this.reducedMotion,
  });

  factory _LoaderSettings.defaults({required Color color}) {
    return _LoaderSettings(
      size: 148,
      durationMs: 4600,
      color: color,
      particleCount: 64,
      trailSpan: 0.38,
      strokeWidth: 4.8,
      animate: true,
      reverse: false,
      reducedMotion: false,
    );
  }

  final double size;
  final int durationMs;
  final Color color;
  final int particleCount;
  final double trailSpan;
  final double strokeWidth;
  final bool animate;
  final bool reverse;
  final bool reducedMotion;

  _LoaderSettings copyWith({
    double? size,
    int? durationMs,
    Color? color,
    int? particleCount,
    double? trailSpan,
    double? strokeWidth,
    bool? animate,
    bool? reverse,
    bool? reducedMotion,
  }) {
    return _LoaderSettings(
      size: size ?? this.size,
      durationMs: durationMs ?? this.durationMs,
      color: color ?? this.color,
      particleCount: particleCount ?? this.particleCount,
      trailSpan: trailSpan ?? this.trailSpan,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      animate: animate ?? this.animate,
      reverse: reverse ?? this.reverse,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }
}

class _LoaderPreset {
  const _LoaderPreset({
    required this.id,
    required this.title,
    required this.tag,
    required this.description,
    required this.formulaNote,
    required this.color,
  });

  final String id;
  final String title;
  final String tag;
  final String description;
  final String formulaNote;
  final Color color;
}

class _Swatch {
  const _Swatch(this.name, this.color, this.code);

  final String name;
  final Color color;
  final String code;
}

const _swatches = [
  _Swatch('White', Color(0xFFFFFFFF), 'const Color(0xFFFFFFFF)'),
  _Swatch('Cyan', Color(0xFF67E8F9), 'const Color(0xFF67E8F9)'),
  _Swatch('Amber', Color(0xFFF8C56B), 'const Color(0xFFF8C56B)'),
  _Swatch('Rose', Color(0xFFFF7A90), 'const Color(0xFFFF7A90)'),
  _Swatch('Lime', Color(0xFFA7F46A), 'const Color(0xFFA7F46A)'),
  _Swatch('Violet', Color(0xFFC4A5FF), 'const Color(0xFFC4A5FF)'),
];

const _presets = [
  _LoaderPreset(
    id: 'rose',
    title: 'Rose',
    tag: 'POLAR',
    description: 'A floral orbit with a soft breathing radius.',
    formulaNote: 'A rose-style polar curve modulates radius with cos(k t).',
    color: Color(0xFFFFFFFF),
  ),
  _LoaderPreset(
    id: 'lissajous',
    title: 'Lissajous',
    tag: 'HARMONIC',
    description: 'Balanced sine waves weave a calm figure-eight motion.',
    formulaNote: 'Independent x/y sine frequencies create the crossing path.',
    color: Color(0xFF67E8F9),
  ),
  _LoaderPreset(
    id: 'cardioid',
    title: 'Cardioid',
    tag: 'HEART',
    description: 'A compact polar curve that folds inward as it loops.',
    formulaNote: 'A cardioid uses radius proportional to 1 - sin(t).',
    color: Color(0xFFFF7A90),
  ),
  _LoaderPreset(
    id: 'hypotrochoid',
    title: 'Hypotrochoid',
    tag: 'ROLLING',
    description: 'A spirograph-like path traced from inside a rolling circle.',
    formulaNote: 'A point inside a rolling circle creates lobed inner motion.',
    color: Color(0xFFF8C56B),
  ),
  _LoaderPreset(
    id: 'epicycloid',
    title: 'Epicycloid',
    tag: 'CUSPS',
    description: 'A brighter outer rolling curve with crisp petal turns.',
    formulaNote: 'A point outside a rolling circle traces the outer lobes.',
    color: Color(0xFFA7F46A),
  ),
  _LoaderPreset(
    id: 'cassiniOval',
    title: 'Cassini Oval',
    tag: 'OVAL',
    description: 'A pinched oval with a quiet figure-eight temperament.',
    formulaNote:
        'Cassini-style paths balance two focal distances into an oval.',
    color: Color(0xFFC4A5FF),
  ),
  _LoaderPreset(
    id: 'lemniscate',
    title: 'Lemniscate',
    tag: 'INFINITY',
    description: 'A restrained infinity curve with a glassy central crossing.',
    formulaNote: 'A Bernoulli-style lemniscate folds around the center point.',
    color: Color(0xFFFFFFFF),
  ),
  _LoaderPreset(
    id: 'spiral',
    title: 'Spiral',
    tag: 'RADIAL',
    description: 'A breathing radial wrap that contracts and unfurls.',
    formulaNote: 'A radial wave increases and decreases while the angle turns.',
    color: Color(0xFF67E8F9),
  ),
  _LoaderPreset(
    id: 'fourierFlow',
    title: 'Fourier Flow',
    tag: 'SERIES',
    description: 'Layered harmonics drift into an organic closed path.',
    formulaNote: 'Several sine and cosine harmonics combine into one loop.',
    color: Color(0xFFF8C56B),
  ),
];

class _TokensScope extends InheritedWidget {
  const _TokensScope({required this.tokens, required super.child});

  final _Tokens tokens;

  static _Tokens of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TokensScope>()!.tokens;
  }

  @override
  bool updateShouldNotify(_TokensScope oldWidget) => tokens != oldWidget.tokens;
}

class _Tokens {
  const _Tokens({
    required this.background,
    required this.panel,
    required this.control,
    required this.preview,
    required this.previewGlow,
    required this.radialGlow,
    required this.pill,
    required this.codeBackground,
    required this.border,
    required this.borderStrong,
    required this.shadow,
    required this.text,
    required this.muted,
    required this.title,
    required this.modalTitle,
    required this.cardTitle,
    required this.body,
    required this.caption,
    required this.eyebrow,
    required this.tag,
    required this.sectionTitle,
    required this.controlLabel,
    required this.monoValue,
    required this.pillText,
    required this.code,
    required this.formula,
  });

  factory _Tokens.fromBrightness(bool isLight) {
    final background = isLight ? const Color(0xFFF5F3EE) : Colors.black;
    final text = isLight ? const Color(0xFF171717) : Colors.white;
    final muted = isLight
        ? const Color(0xFF6C6861)
        : Colors.white.withValues(alpha: 0.62);
    final border = isLight
        ? const Color(0xFF171717).withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.08);
    final borderStrong = isLight
        ? const Color(0xFF171717).withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.18);

    return _Tokens(
      background: background,
      panel: isLight
          ? Colors.white.withValues(alpha: 0.72)
          : const Color(0xFF050505).withValues(alpha: 0.96),
      control: isLight
          ? const Color(0xFFEEEAE2).withValues(alpha: 0.78)
          : Colors.white.withValues(alpha: 0.028),
      preview: isLight
          ? const Color(0xFFEDE8DF).withValues(alpha: 0.82)
          : Colors.white.withValues(alpha: 0.012),
      previewGlow: isLight
          ? Colors.white.withValues(alpha: 0.70)
          : Colors.white.withValues(alpha: 0.058),
      radialGlow: isLight
          ? Colors.white.withValues(alpha: 0.64)
          : Colors.white.withValues(alpha: 0.065),
      pill: isLight
          ? Colors.white.withValues(alpha: 0.66)
          : Colors.white.withValues(alpha: 0.045),
      codeBackground: isLight
          ? const Color(0xFFF9F7F2)
          : const Color(0xFF020202),
      border: border,
      borderStrong: borderStrong,
      shadow: isLight
          ? const Color(0xFF8A8175).withValues(alpha: 0.16)
          : Colors.black.withValues(alpha: 0.42),
      text: text,
      muted: muted,
      title: TextStyle(
        color: text,
        fontSize: 42,
        height: 1.06,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      modalTitle: TextStyle(
        color: text,
        fontSize: 28,
        height: 1.08,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      cardTitle: TextStyle(
        color: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      body: TextStyle(
        color: muted,
        fontSize: 13,
        height: 1.55,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      caption: TextStyle(
        color: muted,
        fontSize: 12,
        height: 1.45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      eyebrow: TextStyle(
        color: muted,
        fontSize: 11,
        height: 1,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
      ),
      tag: TextStyle(
        color: muted,
        fontSize: 10,
        height: 1,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.3,
      ),
      sectionTitle: TextStyle(
        color: text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      controlLabel: TextStyle(
        color: muted,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      monoValue: TextStyle(
        color: text,
        fontSize: 11,
        fontFamily: 'SF Mono',
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      pillText: TextStyle(
        color: text,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      code: TextStyle(
        color: text,
        fontSize: 11,
        height: 1.58,
        fontFamily: 'SF Mono',
        letterSpacing: 0,
      ),
      formula: TextStyle(
        color: text.withValues(alpha: 0.86),
        fontSize: 12,
        height: 1.5,
        fontFamily: 'SF Mono',
        letterSpacing: 0,
      ),
    );
  }

  final Color background;
  final Color panel;
  final Color control;
  final Color preview;
  final Color previewGlow;
  final Color radialGlow;
  final Color pill;
  final Color codeBackground;
  final Color border;
  final Color borderStrong;
  final Color shadow;
  final Color text;
  final Color muted;
  final TextStyle title;
  final TextStyle modalTitle;
  final TextStyle cardTitle;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle eyebrow;
  final TextStyle tag;
  final TextStyle sectionTitle;
  final TextStyle controlLabel;
  final TextStyle monoValue;
  final TextStyle pillText;
  final TextStyle code;
  final TextStyle formula;
}
