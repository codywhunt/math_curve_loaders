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
  bool _isLight = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Curve Loaders',
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isLight ? Brightness.light : Brightness.dark,
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
              top: -260,
              left: -120,
              right: -120,
              child: IgnorePointer(
                child: Container(
                  height: 600,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        tokens.radialGlow,
                        tokens.background.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.78],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: _TopBar(
                            isLight: isLight,
                            onToggleTheme: onToggleTheme,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 64, 28, 80),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: const _HeroHeader(),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 18),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: const _CollectionRule(),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 80),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final columns = width >= 1040
                                  ? 3
                                  : width >= 720
                                  ? 2
                                  : 1;

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: tokens.border),
                                    left: BorderSide(color: tokens.border),
                                  ),
                                ),
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: columns,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0,
                                        mainAxisExtent: 320,
                                      ),
                                  itemCount: _presets.length,
                                  itemBuilder: (context, index) {
                                    final preset = _presets[index];
                                    return _RevealItem(
                                      index: index,
                                      child: _LoaderCard(
                                        preset: preset,
                                        index: index,
                                        onTap: () =>
                                            _openPresetViewer(context, preset),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1080),
                          child: const _Colophon(),
                        ),
                      ),
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
      barrierColor: Colors.black.withValues(alpha: isLight ? 0.20 : 0.74),
      transitionDuration: const Duration(milliseconds: 240),
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
          child: Transform.translate(
            offset: Offset(0, (1 - eased) * 8),
            child: child,
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isLight, required this.onToggleTheme});

  final bool isLight;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Row(
      children: [
        Text('M·C·L', style: tokens.wordmark),
        const SizedBox(width: 14),
        Container(width: 1, height: 14, color: tokens.border),
        const SizedBox(width: 14),
        Text('VOL.01', style: tokens.eyebrow),
        const Spacer(),
        _IconToggle(
          icon: isLight ? LucideIcons.moon : LucideIcons.sun,
          onTap: onToggleTheme,
        ),
      ],
    );
  }
}

class _IconToggle extends StatefulWidget {
  const _IconToggle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_IconToggle> createState() => _IconToggleState();
}

class _IconToggleState extends State<_IconToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Icon(
              widget.icon,
              size: 17,
              color: _hovered ? tokens.text : tokens.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final titleSize = isWide ? 116.0 : 64.0;

        final eyebrow = Text('MATHEMATICAL MOTION', style: tokens.eyebrow);
        final title = Text(
          'Curves drawn\nfrom formulae.',
          style: tokens.title.copyWith(fontSize: titleSize),
        );
        final body = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(
            'Nine parametric Flutter loading indicators - fully customizable. '
            'Each tunable in real time. ',
            style: tokens.body,
          ),
        );
        final visual = const _HeroVisual();

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eyebrow,
              const SizedBox(height: 22),
              title,
              const SizedBox(height: 24),
              body,
              const SizedBox(height: 40),
              Center(child: visual),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  eyebrow,
                  const SizedBox(height: 28),
                  title,
                  const SizedBox(height: 28),
                  body,
                ],
              ),
            ),
            Expanded(flex: 7, child: Center(child: visual)),
          ],
        );
      },
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return SizedBox(
      width: 280,
      height: 280,
      child: Center(
        child: MathCurveLoader.fourierFlow(
          size: 240,
          color: tokens.heroLoader,
          style: const MathCurveLoaderStyle(
            particleCount: 92,
            trailSpan: 0.46,
            strokeWidth: 2.8,
            guideOpacity: 0.05,
          ),
        ),
      ),
    );
  }
}

class _CollectionRule extends StatelessWidget {
  const _CollectionRule();

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('THE COLLECTION', style: tokens.eyebrow),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: tokens.border)),
          const SizedBox(width: 16),
          Text(
            '${_presets.length.toString().padLeft(2, '0')} SPECIMENS',
            style: tokens.eyebrow,
          ),
        ],
      ),
    );
  }
}

class _Colophon extends StatelessWidget {
  const _Colophon();

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 36),
      child: Row(
        children: [
          Text('SET IN FRAUNCES & INTER TIGHT', style: tokens.eyebrow),
          const Spacer(),
          Text('© MATH CURVE LOADERS', style: tokens.eyebrow),
        ],
      ),
    );
  }
}

class _RevealItem extends StatelessWidget {
  const _RevealItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _LoaderCard extends StatefulWidget {
  const _LoaderCard({
    required this.preset,
    required this.index,
    required this.onTap,
  });

  final _LoaderPreset preset;
  final int index;
  final VoidCallback onTap;

  @override
  State<_LoaderCard> createState() => _LoaderCardState();
}

class _LoaderCardState extends State<_LoaderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final settings = _LoaderSettings.defaults(color: tokens.galleryLoader);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _hovered ? tokens.cardHover : Colors.transparent,
            border: Border(
              right: BorderSide(color: tokens.border),
              bottom: BorderSide(color: tokens.border),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'N°${(widget.index + 1).toString().padLeft(2, '0')}',
                    style: tokens.numeral,
                  ),
                  const Spacer(),
                  Text(widget.preset.tag, style: tokens.tag),
                ],
              ),
              Expanded(
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeOut,
                    scale: _hovered ? 1.05 : 1.0,
                    child: _buildLoader(widget.preset, settings, size: 138),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: tokens.border,
                margin: const EdgeInsets.only(bottom: 14),
              ),
              Text(widget.preset.title, style: tokens.cardTitle),
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
  _LoaderSettings? _settings;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final settings = _settings ??= _LoaderSettings.defaults(
      color: _defaultViewerColor(widget.preset, tokens),
    );

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 840;
                  final preview = _ViewerPreview(
                    preset: widget.preset,
                    settings: settings,
                  );
                  final code = _CodePanel(
                    preset: widget.preset,
                    settings: settings,
                  );
                  final controls = _ControlsPanel(
                    settings: settings,
                    onSettingsChanged: (settings) {
                      setState(() => _settings = settings);
                    },
                    onReset: () {
                      setState(() {
                        _settings = _LoaderSettings.defaults(
                          color: _defaultViewerColor(widget.preset, tokens),
                        );
                      });
                    },
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: tokens.background,
                      border: Border.all(color: tokens.border),
                    ),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 13,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: tokens.border),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      preview,
                                      Container(
                                        height: 1,
                                        color: tokens.border,
                                      ),
                                      code,
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 320, child: controls),
                            ],
                          )
                        : Column(
                            children: [
                              preview,
                              Container(height: 1, color: tokens.border),
                              code,
                              Container(height: 1, color: tokens.border),
                              controls,
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerPreview extends StatelessWidget {
  const _ViewerPreview({required this.preset, required this.settings});

  final _LoaderPreset preset;
  final _LoaderSettings settings;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(preset.tag, style: tokens.tag),
              const SizedBox(width: 14),
              Expanded(child: Container(height: 1, color: tokens.border)),
            ],
          ),
          const SizedBox(height: 14),
          Text(preset.title, style: tokens.modalTitle),
          const SizedBox(height: 18),
          _PreviewFrame(
            child: _buildLoader(preset, settings, size: settings.size),
          ),
          const SizedBox(height: 22),
          _FormulaNote(text: preset.formulaNote),
          const SizedBox(height: 12),
          Text(preset.description, style: tokens.body),
        ],
      ),
    );
  }
}

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({
    required this.settings,
    required this.onSettingsChanged,
    required this.onReset,
  });

  final _LoaderSettings settings;
  final ValueChanged<_LoaderSettings> onSettingsChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('INSPECTOR', style: tokens.sectionTitle),
              const Spacer(),
              _GhostButton(
                icon: LucideIcons.rotateCcw,
                label: 'Reset',
                onTap: onReset,
              ),
              const SizedBox(width: 10),
              _GhostButton(
                icon: LucideIcons.x,
                label: 'Close',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _ControlStack(
            children: [
              _NumberControl(
                label: 'SIZE',
                value: settings.size,
                min: 72,
                max: 220,
                divisions: 37,
                suffix: 'px',
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(size: value)),
              ),
              _NumberControl(
                label: 'DURATION',
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
                label: 'PARTICLES',
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
                label: 'TRAIL SPAN',
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
                label: 'STROKE',
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
                label: 'ANIMATE',
                value: settings.animate,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(animate: value)),
              ),
              _ToggleControl(
                label: 'REVERSE',
                value: settings.reverse,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(reverse: value)),
              ),
              _ToggleControl(
                label: 'REDUCED MOTION',
                value: settings.reducedMotion,
                onChanged: (value) =>
                    onSettingsChanged(settings.copyWith(reducedMotion: value)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodePanel extends StatefulWidget {
  const _CodePanel({required this.preset, required this.settings});

  final _LoaderPreset preset;
  final _LoaderSettings settings;

  @override
  State<_CodePanel> createState() => _CodePanelState();
}

class _CodePanelState extends State<_CodePanel> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    final snippet = _snippetFor(widget.preset, widget.settings);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('SNIPPET', style: tokens.sectionTitle),
              const Spacer(),
              _GhostButton(
                icon: _copied ? LucideIcons.check : LucideIcons.copy,
                label: _copied ? 'Copied' : 'Copy',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: snippet));
                  setState(() => _copied = true);
                  Future<void>.delayed(const Duration(milliseconds: 1400), () {
                    if (mounted) setState(() => _copied = false);
                  });
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 260),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tokens.codeBackground,
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

class _ControlStack extends StatelessWidget {
  const _ControlStack({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 24),
          children[index],
        ],
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(label, style: tokens.controlLabel)),
            Text('$display$suffix', style: tokens.monoValue),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 16,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              activeTrackColor: tokens.text,
              inactiveTrackColor: tokens.border,
              thumbColor: tokens.text,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
              overlayShape: SliderComponentShape.noOverlay,
              overlayColor: Colors.transparent,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('COLOR', style: tokens.controlLabel),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 10,
          children: [
            for (final swatch in _swatches)
              GestureDetector(
                onTap: () => onChanged(swatch.color),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: swatch.color,
                      border: Border.all(
                        color: selected == swatch.color
                            ? tokens.text
                            : tokens.border,
                        width: selected == swatch.color ? 1.6 : 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
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

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(child: Text(label, style: tokens.controlLabel)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 16,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: value
                      ? tokens.text
                      : tokens.text.withValues(alpha: 0.15),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value
                          ? tokens.background
                          : tokens.text.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: tokens.borderStrong, width: 1)),
      ),
      child: Text(text, style: tokens.formula),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 340),
      decoration: BoxDecoration(
        color: tokens.preview,
        border: Border.all(color: tokens.border),
      ),
      child: Center(child: child),
    );
  }
}

class _GhostButton extends StatefulWidget {
  const _GhostButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = _TokensScope.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? tokens.text : tokens.borderStrong,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 12, color: tokens.text),
              const SizedBox(width: 7),
              Text(widget.label, style: tokens.pillText),
            ],
          ),
        ),
      ),
    );
  }
}

Color _defaultViewerColor(_LoaderPreset preset, _Tokens tokens) {
  if (preset.color == _paperColor &&
      tokens.background.computeLuminance() > 0.5) {
    return _inkColor;
  }

  return preset.color;
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
MathCurveLoader.${preset.id}(
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
      size: 168,
      durationMs: 4600,
      color: color,
      particleCount: 64,
      trailSpan: 0.38,
      strokeWidth: 4.0,
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

const _inkColor = Color(0xFF141210);
const _paperColor = Color(0xFFF4F1EA);

const _swatches = [
  _Swatch('Paper', _paperColor, 'const Color(0xFFF4F1EA)'),
  _Swatch('Ink', _inkColor, 'const Color(0xFF141210)'),
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
    color: _paperColor,
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
    formulaNote: 'A cardioid uses radius proportional to 1 − sin(t).',
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
    color: _paperColor,
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
    required this.preview,
    required this.codeBackground,
    required this.cardHover,
    required this.radialGlow,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.muted,
    required this.heroLoader,
    required this.galleryLoader,
    required this.wordmark,
    required this.title,
    required this.modalTitle,
    required this.cardTitle,
    required this.body,
    required this.eyebrow,
    required this.tag,
    required this.numeral,
    required this.sectionTitle,
    required this.controlLabel,
    required this.monoValue,
    required this.pillText,
    required this.code,
    required this.formula,
  });

  factory _Tokens.fromBrightness(bool isLight) {
    final background = isLight
        ? const Color(0xFFF6F2E7)
        : const Color(0xFF0A0A0A);
    final text = isLight ? const Color(0xFF141210) : const Color(0xFFF4F1EA);
    final muted = isLight
        ? const Color(0xFF6E6A60)
        : const Color(0xFFF4F1EA).withValues(alpha: 0.55);
    final border = isLight
        ? const Color(0xFF141210).withValues(alpha: 0.10)
        : const Color(0xFFF4F1EA).withValues(alpha: 0.10);
    final borderStrong = isLight
        ? const Color(0xFF141210).withValues(alpha: 0.34)
        : const Color(0xFFF4F1EA).withValues(alpha: 0.32);
    final preview = isLight ? const Color(0xFFEFEADD) : const Color(0xFF050505);
    final cardHover = isLight
        ? const Color(0xFF141210).withValues(alpha: 0.025)
        : const Color(0xFFF4F1EA).withValues(alpha: 0.025);
    final radialGlow = isLight
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.55)
        : const Color(0xFFF4F1EA).withValues(alpha: 0.04);

    return _Tokens(
      background: background,
      preview: preview,
      codeBackground: isLight
          ? const Color(0xFFEFEADD)
          : const Color(0xFF030303),
      cardHover: cardHover,
      radialGlow: radialGlow,
      border: border,
      borderStrong: borderStrong,
      text: text,
      muted: muted,
      heroLoader: text,
      galleryLoader: text,
      wordmark: TextStyle(
        fontFamily: 'InterTight',
        color: text,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
        height: 1,
      ),
      title: TextStyle(
        fontFamily: 'Fraunces',
        color: text,
        fontSize: 116,
        height: 0.94,
        fontWeight: FontWeight.w400,
        letterSpacing: -2.6,
      ),
      modalTitle: TextStyle(
        fontFamily: 'Fraunces',
        color: text,
        fontSize: 38,
        height: 1.04,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.6,
      ),
      cardTitle: TextStyle(
        fontFamily: 'Fraunces',
        color: text,
        fontSize: 22,
        height: 1.05,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
      body: TextStyle(
        fontFamily: 'InterTight',
        color: muted,
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
      ),
      eyebrow: TextStyle(
        fontFamily: 'InterTight',
        color: muted,
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.6,
        height: 1,
      ),
      tag: TextStyle(
        fontFamily: 'InterTight',
        color: muted,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.8,
        height: 1,
      ),
      numeral: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: muted,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      sectionTitle: TextStyle(
        fontFamily: 'InterTight',
        color: text,
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
        height: 1,
      ),
      controlLabel: TextStyle(
        fontFamily: 'InterTight',
        color: muted,
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
      ),
      monoValue: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: text,
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
      ),
      pillText: TextStyle(
        fontFamily: 'InterTight',
        color: text,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      code: TextStyle(
        fontFamily: 'JetBrainsMono',
        color: text,
        fontSize: 11.5,
        height: 1.7,
      ),
      formula: TextStyle(
        fontFamily: 'Fraunces',
        color: muted,
        fontSize: 15,
        height: 1.5,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  final Color background;
  final Color preview;
  final Color codeBackground;
  final Color cardHover;
  final Color radialGlow;
  final Color border;
  final Color borderStrong;
  final Color text;
  final Color muted;
  final Color heroLoader;
  final Color galleryLoader;
  final TextStyle wordmark;
  final TextStyle title;
  final TextStyle modalTitle;
  final TextStyle cardTitle;
  final TextStyle body;
  final TextStyle eyebrow;
  final TextStyle tag;
  final TextStyle numeral;
  final TextStyle sectionTitle;
  final TextStyle controlLabel;
  final TextStyle monoValue;
  final TextStyle pillText;
  final TextStyle code;
  final TextStyle formula;
}
