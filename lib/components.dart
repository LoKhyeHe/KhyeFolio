import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:term_summary/models.dart';
import 'package:term_summary/pages/project_detail.dart';

// ── DESIGN TOKENS ─────────────────────────────────────────────────────────────
const kBg      = Color(0xFF060810);
const kSurface = Color(0xFF0C111A);
const kCard    = Color(0xFF101724);
const kBorder  = Color(0xFF1B2740);
const kCyan    = Color(0xFF00CCFF);
const kPurple  = Color(0xFF8B5CF6);

// ── ASSET IMAGE WITH PLACEHOLDER FALLBACK ─────────────────────────────────────
// Falls back to a neutral placeholder when an asset hasn't been added yet,
// instead of Flutter's default red error box.
Widget assetImageOrPlaceholder(
  String assetPath, {
  BoxFit fit = BoxFit.cover,
  Alignment alignment = Alignment.center,
}) {
  return Image.asset(
    assetPath,
    fit: fit,
    alignment: alignment,
    errorBuilder: (context, error, stackTrace) => Container(
      color: kCard,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colors.white24, size: 32),
    ),
  );
}

// ── BLUR-BACKED IMAGE ─────────────────────────────────────────────────────────
// Shows the full image uncropped (contain), letterboxed over a blurred,
// dimmed copy of itself — so any aspect ratio looks intentional.
class BlurBackedImage extends StatelessWidget {
  final String assetPath;
  final EdgeInsets padding;

  const BlurBackedImage({
    required this.assetPath,
    this.padding = const EdgeInsets.all(10),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: assetImageOrPlaceholder(assetPath),
        ),
        Container(color: kBg.withValues(alpha: 0.55)),
        Padding(
          padding: padding,
          child: assetImageOrPlaceholder(assetPath, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

// ── TIMELINE IMAGE STRIP ──────────────────────────────────────────────────────
// One or more images in a fixed-height strip; each is blur-backed so nothing
// ever gets awkwardly cropped.
class TimelineImageStrip extends StatelessWidget {
  final List<String> paths;
  final double height;

  const TimelineImageStrip({
    required this.paths,
    this.height = 216,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Row(
          children: [
            for (int i = 0; i < paths.length; i++) ...[
              if (i > 0) const SizedBox(width: 2),
              Expanded(child: BlurBackedImage(assetPath: paths[i])),
            ],
          ],
        ),
      ),
    );
  }
}

// ── GLASS NAV ─────────────────────────────────────────────────────────────────

class GlassNav extends StatefulWidget {
  final VoidCallback onAbout;
  final VoidCallback onExperience;
  final VoidCallback onEducation;
  final VoidCallback onProjects;

  const GlassNav({
    required this.onAbout,
    required this.onExperience,
    required this.onEducation,
    required this.onProjects,
    super.key,
  });

  @override
  State<GlassNav> createState() => _GlassNavState();
}

class _GlassNavState extends State<GlassNav> {
  String? _hovered;

  Widget _link(String label, VoidCallback onTap) {
    final hot = _hovered == label;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = label),
      onExit: (_) => setState(() => _hovered = null),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: hot ? Colors.white : Colors.white54,
                  fontSize: 13,
                  fontWeight: hot ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 1.5,
                width: hot ? 18.0 : 0.0,
                decoration: BoxDecoration(
                  color: kCyan,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: kBg.withValues(alpha: 0.72),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'KH',
                          style: TextStyle(
                            color: kCyan,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: kPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Links
                  Row(
                    children: [
                      _link('About', widget.onAbout),
                      _link('Experience', widget.onExperience),
                      _link('Education', widget.onEducation),
                      _link('Projects', widget.onProjects),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── PULSING GLOW IMAGE ────────────────────────────────────────────────────────

class PulsingGlowImage extends StatefulWidget {
  final String assetPath;
  final double size;

  const PulsingGlowImage({
    required this.assetPath,
    required this.size,
    super.key,
  });

  @override
  State<PulsingGlowImage> createState() => _PulsingGlowImageState();
}

class _PulsingGlowImageState extends State<PulsingGlowImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final v = _ctrl.value;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kCyan.withValues(alpha: 0.12 + v * 0.18),
                blurRadius: 40 + v * 24,
                spreadRadius: v * 6,
              ),
              BoxShadow(
                color: kPurple.withValues(alpha: 0.06 + v * 0.09),
                blurRadius: 60 + v * 30,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(kCyan, kPurple, v)!,
                  Color.lerp(kPurple, kCyan, v)!,
                ],
              ),
            ),
            child: child!,
          ),
        );
      },
      child: ClipOval(
        child: Image.asset(
          widget.assetPath,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ── GRADIENT ACCENT BAR ───────────────────────────────────────────────────────

class GradientBar extends StatelessWidget {
  final double width;
  const GradientBar({this.width = 64, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kCyan, kPurple]),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ── SECTION LABEL ─────────────────────────────────────────────────────────────

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: kCyan,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 3.5,
      ),
    );
  }
}

// ── STAT BLOCK ────────────────────────────────────────────────────────────────

class StatBlock extends StatelessWidget {
  final String value;
  final String label;

  const StatBlock({required this.value, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: kCyan,
            fontSize: 38,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── PORTFOLIO BUTTON ──────────────────────────────────────────────────────────

class PortfolioButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const PortfolioButton({
    required this.label,
    required this.onTap,
    this.filled = false,
    super.key,
  });

  @override
  State<PortfolioButton> createState() => _PortfolioButtonState();
}

class _PortfolioButtonState extends State<PortfolioButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered ? Colors.white : kCyan)
                : (_hovered ? kCyan.withValues(alpha: 0.10) : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kCyan, width: 1.5),
            boxShadow: widget.filled && _hovered
                ? [BoxShadow(color: kCyan.withValues(alpha: 0.3), blurRadius: 20)]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.filled
                  ? Colors.black
                  : (_hovered ? kCyan : Colors.white70),
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ── GLOW IMAGE ────────────────────────────────────────────────────────────────

class GlowImage extends StatelessWidget {
  final String assetPath;
  final double width, height;
  final BoxFit fit;
  final BoxShadow shadow;

  const GlowImage({
    required this.assetPath,
    required this.width,
    required this.height,
    required this.shadow,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext c) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [shadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child:
              Image.asset(assetPath, width: width, height: height, fit: fit),
        ),
      );
}

// ── STATUS BADGE ──────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final done = status == 'completed';
    final improving = status == 'improving';
    final color = done
        ? const Color(0xFF22C55E)
        : (improving ? const Color(0xFF06B6D4) : const Color(0xFFF97316));
    final text = done ? 'Completed' : (improving ? 'Improving' : 'Ongoing');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── TECH CHIP ─────────────────────────────────────────────────────────────────

class TechChip extends StatelessWidget {
  final String label;
  const TechChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kCyan.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kCyan.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kCyan,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── SOCIAL ITEM ───────────────────────────────────────────────────────────────

class SocialItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const SocialItem({
    required this.icon,
    required this.label,
    required this.url,
    super.key,
  });

  @override
  State<SocialItem> createState() => _SocialItemState();
}

class _SocialItemState extends State<SocialItem> {
  bool _hovered = false;

  Future<void> _openLink() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _openLink,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered ? kCyan.withValues(alpha: 0.12) : Colors.transparent,
            border: Border.all(
              color: _hovered ? kCyan.withValues(alpha: 0.5) : Colors.white12,
            ),
          ),
          child: FaIcon(
            widget.icon,
            color: _hovered ? kCyan : Colors.white54,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ── EMAIL BUTTON ──────────────────────────────────────────────────────────────

class EmailButton extends StatelessWidget {
  final String toAddress;
  final String label;
  final Color accentColor;

  const EmailButton({
    required this.toAddress,
    required this.label,
    this.accentColor = kCyan,
    super.key,
  });

  void _openEmailDialog(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => Dialog(
        backgroundColor: kCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send me a message',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                _field(subjectCtrl, 'Subject', accentColor),
                const SizedBox(height: 14),
                _field(bodyCtrl, 'Message', accentColor, maxLines: 5),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white38)),
                    ),
                    const SizedBox(width: 12),
                    PortfolioButton(
                      label: 'Send',
                      filled: true,
                      onTap: () async {
                        if (toAddress.trim().isEmpty) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email address is not configured yet.'),
                            ),
                          );
                          Navigator.pop(context);
                          return;
                        }
                        final mailto =
                            'mailto:$toAddress?subject=${Uri.encodeComponent(subjectCtrl.text)}&body=${Uri.encodeComponent(bodyCtrl.text)}';
                        await launchUrl(Uri.parse(mailto));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, Color accent,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: kBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioButton(
      label: label,
      filled: false,
      onTap: () => _openEmailDialog(context),
    );
  }
}

// ── EXPERIENCE TIMELINE ───────────────────────────────────────────────────────

class ExperienceTimeline extends StatelessWidget {
  final List<ExperienceEntry> entries;
  const ExperienceTimeline({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        entries.length,
        (i) => _TimelineItem(entry: entries[i], isLast: i == entries.length - 1),
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final ExperienceEntry entry;
  final bool isLast;
  const _TimelineItem({required this.entry, required this.isLast});

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.entry.isCurrent ? kCyan : Colors.white30;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spine
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      boxShadow: widget.entry.isCurrent
                          ? [BoxShadow(color: kCyan.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)]
                          : [],
                    ),
                  ),
                  if (!widget.isLast)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.12),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Content card
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 28),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: _hovered
                      ? kCard
                      : kCard.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _hovered
                        ? kBorder
                        : kBorder.withValues(alpha: 0.45),
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: kCyan.withValues(alpha: 0.06),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.entry.imagePaths.isNotEmpty) ...[
                      TimelineImageStrip(paths: widget.entry.imagePaths),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      widget.entry.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.entry.subtitle,
                      style: const TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 0.3),
                    ),
                    if (widget.entry.tasks.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ...widget.entry.tasks.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: kCyan.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── FULL-PAGE SCROLL PROJECTS ─────────────────────────────────────────────────

class ProjectsFullScrollView extends StatelessWidget {
  final List<Project> projects;
  final ScrollController scrollController;

  const ProjectsFullScrollView({
    required this.projects,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        projects.length,
        (i) => ProjectScrollItem(
          project: projects[i],
          index: i,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class ProjectScrollItem extends StatefulWidget {
  final Project project;
  final int index;
  final ScrollController scrollController;

  const ProjectScrollItem({
    required this.project,
    required this.index,
    required this.scrollController,
    super.key,
  });

  @override
  State<ProjectScrollItem> createState() => _ProjectScrollItemState();
}

class _ProjectScrollItemState extends State<ProjectScrollItem> {
  final _key = GlobalKey();
  double _progress = 0.0;
  bool get _fromLeft => widget.index.isEven;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (!mounted) return;
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final screenH = MediaQuery.of(context).size.height;
    final top = box.localToGlobal(Offset.zero).dy;
    final h = box.size.height;
    final p = ((screenH - top) / (screenH + h)).clamp(0.0, 1.0);
    if ((p - _progress).abs() > 0.0008) setState(() => _progress = p);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    final slideRaw = ((_progress - 0.10) / 0.35).clamp(0.0, 1.0);
    final curved = Curves.easeOut.transform(slideRaw);
    final slideX = _fromLeft ? -300.0 * (1 - curved) : 300.0 * (1 - curved);
    final opacity = curved;
    final parallax = (_progress - 0.5) * 80;
    final imgScale = 1.05 + (0.08 * _progress).clamp(0.0, 0.08);
    final numStr = widget.index < 9 ? '0${widget.index + 1}' : '${widget.index + 1}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentW = (constraints.maxWidth * 0.40).clamp(260.0, 480.0);
        return ClipRect(
          child: SizedBox(
            key: _key,
            height: screenH * 0.88,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image with parallax + zoom
                Positioned(
                  top: -50 + parallax,
                  bottom: -50 - parallax,
                  left: 0,
                  right: 0,
                  child: Transform.scale(
                    scale: imgScale,
                    child: assetImageOrPlaceholder(widget.project.imagePath),
                  ),
                ),

                // Gradient: dark on text side, image shows on other
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: _fromLeft ? Alignment.centerLeft : Alignment.centerRight,
                      end: _fromLeft ? Alignment.centerRight : Alignment.centerLeft,
                      stops: const [0.0, 0.40, 0.68, 1.0],
                      colors: [
                        kBg.withValues(alpha: 0.96),
                        kBg.withValues(alpha: 0.80),
                        kBg.withValues(alpha: 0.20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Sliding content
                Positioned(
                  left: _fromLeft ? 56 : null,
                  right: _fromLeft ? null : 56,
                  top: 0,
                  bottom: 0,
                  width: contentW,
                  child: Transform.translate(
                    offset: Offset(slideX, 0),
                    child: Opacity(
                      opacity: opacity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              _fromLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Text(
                              numStr,
                              style: TextStyle(
                                color: kCyan.withValues(alpha: 0.12),
                                fontSize: 100,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            StatusBadge(widget.project.status),
                            const SizedBox(height: 16),
                            Text(
                              widget.project.title,
                              textAlign: _fromLeft ? TextAlign.left : TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.project.shortDesc,
                              textAlign: _fromLeft ? TextAlign.left : TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              alignment: _fromLeft ? WrapAlignment.start : WrapAlignment.end,
                              children: widget.project.techStack
                                  .take(3)
                                  .map((t) => TechChip(t))
                                  .toList(),
                            ),
                            const SizedBox(height: 28),
                            _ScrollViewButton(project: widget.project, alignRight: !_fromLeft),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ScrollViewButton extends StatefulWidget {
  final Project project;
  final bool alignRight;
  const _ScrollViewButton({required this.project, required this.alignRight});

  @override
  State<_ScrollViewButton> createState() => _ScrollViewButtonState();
}

class _ScrollViewButtonState extends State<_ScrollViewButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProjectDetailPage(project: widget.project),
            transitionsBuilder: (_, a, __, child) =>
                FadeTransition(opacity: a, child: child),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? kCyan : Colors.white24,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
            color: _hovered ? kCyan.withValues(alpha: 0.10) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.alignRight) ...[
                Icon(Icons.arrow_back, size: 13,
                    color: _hovered ? kCyan : Colors.white54),
                const SizedBox(width: 8),
              ],
              Text(
                'View Project',
                style: TextStyle(
                  color: _hovered ? kCyan : Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              if (!widget.alignRight) ...[
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 13,
                    color: _hovered ? kCyan : Colors.white54),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
