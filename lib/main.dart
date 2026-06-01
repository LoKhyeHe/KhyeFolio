import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:term_summary/components.dart';
import 'package:term_summary/models.dart';

void main() => runApp(const MyApp());

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lo Khye He',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoGlowScrollBehavior(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBg,
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _aboutKey = GlobalKey();
  final _expKey = GlobalKey();
  final _projKey = GlobalKey();
  late Future<List<Project>> _projectsFuture;

  static const _experiences = [
    ExperienceEntry(
      title: 'Freelance @ MakeIT',
      subtitle: 'Jan 2026  ·  Current',
      imagePath: 'lib/assets/makeit_logo.png',
      tasks: [
        'Educate community patrons of all ages through hands-on workshops in 3D printing and laser cutting.',
        'Maintain makerspace operations, equipment readiness, and safe workflows for daily public use.',
      ],
      isCurrent: true,
    ),
    ExperienceEntry(
      title: 'Assistant Engineer @ Temasek Polytechnic',
      subtitle: 'Part-time  ·  Apr 2022 – Oct 2022',
      imagePath: 'lib/assets/temasek_poly.jpg',
      tasks: [
        'Developed the software portion of an IoT module for students to learn connecting health sensors to the cloud and building dashboards.',
        'Provided consultation for Final Year Project students in prototyping.',
      ],
    ),
    ExperienceEntry(
      title: 'Robotics Engineer @ Weston Robot',
      subtitle: 'Engineering Role  ·  Sep 2021 – Feb 2022',
      imagePath: 'lib/assets/weston_robot_alt.jpg',
      imageAlignmentY: -0.5,
      tasks: [
        'Built a Flutter mobile application for interfacing with in-house robots for diagnostic purposes.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _projectsFuture = _loadProjects();
  }

  Future<List<Project>> _loadProjects() async {
    final raw = await rootBundle.loadString('lib/assets/projects.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['projects'] as List)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────────
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHero(context, size),
                _buildAbout(context),
                _buildExperience(context),
                _buildProjects(context),
                _buildFooter(context),
              ],
            ),
          ),

          // ── Sticky glassmorphism nav ─────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassNav(
              onAbout: () => _scrollTo(_aboutKey),
              onExperience: () => _scrollTo(_expKey),
              onProjects: () => _scrollTo(_projKey),
            ),
          ),
        ],
      ),
    );
  }

  // ── HERO ───────────────────────────────────────────────────────────────────

  Widget _buildHero(BuildContext context, Size size) {
    final isNarrow = size.width < 980;
    final horizontalPad = isNarrow ? 24.0 : 56.0;

    return SizedBox(
      height: isNarrow ? null : size.height,
      child: Stack(
        children: [
          // Background gradient orbs
          Positioned.fill(child: _HeroBackground(size: size)),

          // Main content row
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(horizontalPad, 110, horizontalPad, 56),
                child: isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroText(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left: text
                          Expanded(
                            flex: 1,
                            child: _buildHeroText(),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Bouncing scroll indicator
          if (!isNarrow)
            const Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(child: _BouncingArrow()),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // Name
        const Text(
          'Lo\nKhye He.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 78,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: -2.5,
          ),
        ),
        const SizedBox(height: 22),

        // Animated role text
        Row(
          children: [
            Container(
              width: 26,
              height: 2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kCyan, kPurple],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 12),
            DefaultTextStyle(
              style: const TextStyle(
                color: kCyan,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Builder',
                      speed: const Duration(milliseconds: 75)),
                  TypewriterAnimatedText('Maker & Entrepreneur',
                      speed: const Duration(milliseconds: 75)),
                  TypewriterAnimatedText('SUTD STEP Scholar',
                      speed: const Duration(milliseconds: 75)),
                ],
                repeatForever: true,
                pause: const Duration(milliseconds: 2200),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // Bio
        const Text(
          'Engineering solutions that matter.\nCurrently at SUTD under the STEP Scholarship Programme.',
          style: TextStyle(
              color: Colors.white38,
              fontSize: 15,
              height: 1.8,
              letterSpacing: 0.2),
        ),
        const SizedBox(height: 40),

        // CTA buttons
        Row(
          children: [
            PortfolioButton(
              label: 'View Work',
              filled: true,
              onTap: () => _scrollTo(_projKey),
            ),
            const SizedBox(width: 14),
            EmailButton(
                toAddress: 'khyehe_lo@mymail.sutd.edu.sg', label: 'Contact'),
          ],
        ),
        const SizedBox(height: 40),

        // Socials
        const Row(
          children: [
            SocialItem(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              url: 'https://github.com/LoKhyeHe',
            ),
            SizedBox(width: 8),
            SocialItem(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              url: 'https://www.linkedin.com/in/khyehe/',
            ),
            SizedBox(width: 8),
            SocialItem(
              icon: FontAwesomeIcons.instagram,
              label: 'Instagram',
              url: 'https://www.instagram.com/k.hyeho/',
            ),
          ],
        ),
      ],
    );
  }

  // ── ABOUT ──────────────────────────────────────────────────────────────────

  Widget _buildAbout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 980;
    final horizontalPad = isNarrow ? 24.0 : 56.0;

    const imageShadow = BoxShadow(
      color: Color(0x2200CCFF),
      blurRadius: 56,
      spreadRadius: 4,
    );

    return Container(
      color: kSurface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPad, vertical: isNarrow ? 72 : 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Anchor for scroll-to
                SizedBox(key: _aboutKey, height: 0),

                const SectionLabel('01  /  ABOUT'),
                const SizedBox(height: 14),
                const Text('About Me', style: _h2),
                const SizedBox(height: 56),

                isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GlowImage(
                              assetPath: 'lib/assets/about.png',
                              width: 320,
                              height: 240,
                              fit: BoxFit.cover,
                              shadow: imageShadow,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _aboutTextContent(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Expanded(
                            flex: 1,
                            child: GlowImage(
                              assetPath: 'lib/assets/about.png',
                              width: 320,
                              height: 240,
                              fit: BoxFit.cover,
                              shadow: imageShadow,
                            ),
                          ),
                          const SizedBox(width: 72),

                          // Text + stats
                          Expanded(
                            flex: 2,
                            child: _aboutTextContent(),
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

  // ── EXPERIENCE ─────────────────────────────────────────────────────────────

  Widget _buildExperience(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 980;
    final horizontalPad = isNarrow ? 24.0 : 56.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPad, vertical: isNarrow ? 72 : 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(key: _expKey, height: 0),
              const SectionLabel('02  /  EXPERIENCE'),
              const SizedBox(height: 14),
              const Text('Experience', style: _h2),
              const SizedBox(height: 56),
              ExperienceTimeline(entries: _experiences),
            ],
          ),
        ),
      ),
    );
  }

  // ── PROJECTS ───────────────────────────────────────────────────────────────

  Widget _buildProjects(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 980;
    final horizontalPad = isNarrow ? 24.0 : 56.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header on the kSurface band
        Container(
          color: kSurface,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPad, isNarrow ? 72 : 100, horizontalPad, 56),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(key: _projKey, height: 0),
                    const SectionLabel('03  /  PROJECTS'),
                    const SizedBox(height: 14),
                    const Text('Projects', style: _h2),
                    const SizedBox(height: 10),
                    const Text(
                      'Things I\'ve built.',
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 14,
                          letterSpacing: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Full-scroll project items
        FutureBuilder<List<Project>>(
          future: _projectsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(72),
                  child:
                      CircularProgressIndicator(color: kCyan, strokeWidth: 2),
                ),
              );
            }
            return ProjectsFullScrollView(
              projects: snapshot.data!,
              scrollController: _scroll,
            );
          },
        ),
      ],
    );
  }

  // ── FOOTER ─────────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 980;
    final horizontalPad = isNarrow ? 24.0 : 56.0;

    return Container(
      color: kSurface,
      child: Column(
        children: [
          // Divider with gradient
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  kCyan,
                  kPurple,
                  Colors.transparent
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 52, horizontal: horizontalPad),
            child: Column(
              children: [
                // Logo
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'KH',
                        style: TextStyle(
                          color: kCyan,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: kPurple,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Social icons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialItem(
                      icon: FontAwesomeIcons.github,
                      label: 'GitHub',
                      url: 'https://github.com/LoKhyeHe',
                    ),
                    SizedBox(width: 12),
                    SocialItem(
                      icon: FontAwesomeIcons.linkedin,
                      label: 'LinkedIn',
                      url: 'https://www.linkedin.com/in/khyehe/',
                    ),
                    SizedBox(width: 12),
                    SocialItem(
                      icon: FontAwesomeIcons.instagram,
                      label: 'Instagram',
                      url: 'https://www.instagram.com/k.hyeho/',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  '© 2024 Lo Khye He  ·  Built with Flutter',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.18),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'At the age of 6, I unspooled my brother\'s correction tape, '
          'resulting in the loss of one of his stationery before his exam. '
          'On that day I learned two things: the pain of a cane and how gears work.\n\n'
          'Today, I am passionate about engineering and problem solving as an '
          'aspiring entrepreneur. I\'m currently pursuing my degree in SUTD '
          'under the STEP Scholarship Programme.',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 15,
            height: 1.9,
          ),
        ),
        const SizedBox(height: 52),
        const Wrap(
          spacing: 40,
          runSpacing: 24,
          children: [
            StatBlock(value: '5', label: 'Projects'),
            StatBlock(value: '3', label: 'Engineering'),
            StatBlock(value: 'STEP', label: 'Scholar'),
          ],
        ),
      ],
    );
  }
}

// ── SHARED TEXT STYLES ────────────────────────────────────────────────────────

const _h2 = TextStyle(
  color: Colors.white,
  fontSize: 52,
  fontWeight: FontWeight.w800,
  height: 1.08,
  letterSpacing: -1.5,
);

// ── PRIVATE PAGE-LEVEL WIDGETS ────────────────────────────────────────────────

class _HeroBackground extends StatelessWidget {
  final Size size;
  const _HeroBackground({required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: kBg),

        // Cyan orb: top-right
        Positioned(
          top: -size.height * 0.28,
          right: -size.width * 0.06,
          child: Container(
            width: size.height * 0.95,
            height: size.height * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [kCyan.withValues(alpha: 0.11), Colors.transparent],
              ),
            ),
          ),
        ),

        // Purple orb: bottom-left
        Positioned(
          bottom: -size.height * 0.38,
          left: -size.width * 0.10,
          child: Container(
            width: size.height * 1.05,
            height: size.height * 1.05,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [kPurple.withValues(alpha: 0.09), Colors.transparent],
              ),
            ),
          ),
        ),

        // Subtle dot-grid texture using a tiny repeating pattern overlay
        Positioned.fill(
          child: Opacity(
            opacity: 0.025,
            child: CustomPaint(painter: _DotGridPainter()),
          ),
        ),
      ],
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 32.0;
    final paint = Paint()..color = Colors.white;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}

class _BouncingArrow extends StatefulWidget {
  const _BouncingArrow();

  @override
  State<_BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<_BouncingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.0, end: 9.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SCROLL',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 9,
                letterSpacing: 3.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withValues(alpha: 0.2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
