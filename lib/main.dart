import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:term_summary/components.dart';

void main() => runApp(const MyApp());

// Disable the default scroll glow
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
      title: 'Lo Khye He Portfolio',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoGlowScrollBehavior(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
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

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // glow for images
    final imageShadow = BoxShadow(
      color: Colors.white24,
      blurRadius: 20,
      spreadRadius: 4,
    );

    return Scaffold(
      body: Center(
        // Center the content, try also with Align
        child: ConstrainedBox(
          // Constrain the width of the content
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── NAV BAR ───────────────────────────────────────
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NavButton('About', () => _scrollTo(_aboutKey)),
                        NavButton('Experience', () => _scrollTo(_expKey)),
                        NavButton('Projects', () => _scrollTo(_projKey)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.wb_sunny_outlined),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                // ─── HERO / PROFILE ────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Row(
                    children: [
                      // Intro + buttons + socials
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hi, my name is',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 20)),
                            const SizedBox(height: 8),
                            const Text('Special Participant',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            const Text(
                              'Welcome to my website. Scroll down to find out more about me.',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            Row(children: [
                              ElevatedButton(
                                onPressed: () => _scrollTo(_aboutKey),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('Check me out'),
                              ),
                              const SizedBox(width: 16),
                              EmailButton(toAddress: '', label: 'Reach me')
                            ]),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SocialItem(
                                  icon: FontAwesomeIcons.instagram,
                                  label: 'Instagram',
                                  url: 'https://www.instagram.com/k.hyeho/',
                                ),
                                SocialItem(
                                  icon: FontAwesomeIcons.linkedin,
                                  label: 'LinkedIn',
                                  url: 'https://www.linkedin.com/in/khyehe/',
                                ),
                                SocialItem(
                                  icon: FontAwesomeIcons.github,
                                  label: 'Github',
                                  url: 'github.com/LoKhyeHe',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 32),

                      // Profile image
                    ],
                  ),
                ),
                // ─── ABOUT ME ─────────────────────────────────────
                Container(key: _aboutKey),
                const StaggeredHeader('About Me', lineBefore: true),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GlowImage(
                          assetPath: 'lib/assets/about.png',
                          width: 300,
                          height: 225,
                          fit: BoxFit.cover,
                          shadow: imageShadow,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: const Text(
                          'At the age of 6, I unspooled my brother’s correction tape, resulting in the loss of one of his stationery before his exam. On that day I learned two things: the pain of a cane and how gears work.\n\n'
                          'Today, I am passionate about engineering and problem solving as an aspiring entrepreneur. I’m currently pursuing my degree in SUTD under the STEP Scholarship Programme.',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── EXPERIENCE ──────────────────────────────────────
                Container(key: _expKey),
                const StaggeredHeader('Experience', lineBefore: false),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GlowImage(
                          assetPath: 'lib/assets/experience.png',
                          width: 300,
                          height: 225,
                          fit: BoxFit.cover,
                          shadow: imageShadow,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ExperienceSection(
                              title: 'Assistant Engineer @ Temasek Polytechnic',
                              subtitle: 'Part-time | Apr 2022 – Oct 2022',
                              tasks: [
                                'Developing the software portion of an IOT Module for students to learn the process of connecting health sensors to the cloud and dashboarding.',
                                'Provide consultation services for Final Year Project students in prototyping.',
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            ExperienceSection(
                              title: 'Robotics Intern @ Weston Robot',
                              subtitle: 'Internship | Sep 2021 – Feb 2022',
                              tasks: [
                                'Developing a mobile application capable of interfacing with in-house robots for diagnostic purposes using Flutter.',
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ─── PROJECTS ────────────────────────────────────────
                Container(key: _projKey),
               const SectionHeader('Projects'),


               const ProjectCard(
               imagePath: 'lib/assets/verbasense.png',
               title: 'Verbasense',
               description: 'Smart backlight that helps students raise their hands',
               techLine: 'Python | ESP32 | Flutter | Dart',
               aspectRatio: 16/9,
               reverse: false,
             ),


             const ProjectCard(
               imagePath: 'lib/assets/capacitor.png',
               title: 'DIY Capacitor',
               description: 'Variable Capacitor Disk Style',
               techLine: 'Fusion 360 | Additive Manufacturing',
               aspectRatio: 1,   // square image
               reverse: true,    // image on right side
             ),


             const ProjectCard(
               imagePath: 'lib/assets/icecream.png',
               title: 'Battle of the Ice Cream Cup',
               description: 'Lifecycle analysis of different materials.',
               techLine: '',     // no tech line
               aspectRatio: 16/9,
               reverse: false,
             ),
               // ─── THE END ─────────────────────────────────────────
               const SectionHeader('The End'),
               const Padding(
                 padding:
                     EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                 child: Text(
                   'That’s all I have done so far… but more is coming soon.',
                   style: TextStyle(color: Colors.white70),
                   textAlign: TextAlign.center,
                 ),
               ),




                // ─── FOOTER ───────────────────────────────────────────
                const Divider(color: Colors.white54, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SocialItem(
                            icon: FontAwesomeIcons.instagram,
                            label: 'Instagram',
                            url: 'https://www.instagram.com/k.hyeho/',
                          ),
                          SizedBox(width: 16),
                          SocialItem(
                            icon: FontAwesomeIcons.github,
                            label: 'GitHub',
                            url: 'https://github.com/LoKhyeHe',
                          ),
                          SizedBox(width: 16),
                          SocialItem(
                            icon: FontAwesomeIcons.linkedin,
                            label: 'LinkedIn',
                            url: 'https://www.linkedin.com/in/khyehe/',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Have something you want to reach out to me for? Contact me @ these socials or send me an email',
                          style: TextStyle(color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
