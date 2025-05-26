import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;


/// Staggered Header
class StaggeredHeader extends StatelessWidget {
  final String title;
  /// if true, the *short* line will be on the left; otherwise on the right
  final bool lineBefore;

  const StaggeredHeader(
    this.title, {
    this.lineBefore = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // decide which side is short vs. long
    final beforeFlex = lineBefore ? 1 : 15;
    final afterFlex  = lineBefore ? 15 : 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // short or long line segment before text
          Expanded(
            flex: beforeFlex,
            child: const Divider(color: Colors.white54, thickness: 1),
          ),
          const SizedBox(width: 8),

          // the title itself
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),
          // the other line segment after text
          Expanded(
            flex: afterFlex,
            child: const Divider(color: Colors.white54, thickness: 1),
          ),
        ],
      ),
    );
  }
}

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
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext c) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [shadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(assetPath, width: width, height: height, fit: fit),
        ),
      );
}
/// A little experience card: title, subtitle, and a list of bullet tasks.
class ExperienceSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tasks;

  const ExperienceSection({
    required this.title,
    required this.subtitle,
    required this.tasks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white54),
        ),
        const SizedBox(height: 8),
        if (tasks.isNotEmpty) ...[
          const Text(
            'My tasks include:',
            style: TextStyle(color: Colors.white70),
          ),
          for (var t in tasks) 
            Text('• $t', style: const TextStyle(color: Colors.white70)),
        ],
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  /// Path to your asset in pubspec.yaml
  final String imagePath;

  /// Bold title above description
  final String title;

  /// The subtitle / one-line description
  final String description;

  /// A single line of tech, e.g. "Flutter | Dart"
  final String techLine;

  /// Aspect ratio to use for the image portion (16/9, 1, etc).
  final double aspectRatio;

  /// If true, image goes on the right, text on the left.
  final bool reverse;

  const ProjectCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.techLine,
    required this.aspectRatio,
    required this.reverse,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext c) {
    final imageShadow = const BoxShadow(
      color: Colors.white24,
      blurRadius: 40,
      spreadRadius: 8,
    );

    // Only the image alignment toggles:
    final imageAlignment =
        reverse ? Alignment.centerRight : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IMAGE (2/3)
          Expanded(
            flex: 2,
            child: Align(
              alignment: imageAlignment,
              child: SizedBox(
                height: 300,
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [imageShadow],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // TEXT (1/3) — unchanged alignment (always left)
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // always start
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(description, style: const TextStyle(color: Colors.white70)),
                    if (techLine.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(techLine, style: const TextStyle(color: Colors.white54)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(children: [
          const Expanded(child: Divider(color: Colors.white54, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          const Expanded(child: Divider(color: Colors.white54, thickness: 1)),
        ]),
      );
}

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const NavButton(this.label, this.onTap, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext c) =>
      TextButton(onPressed: onTap, child: Text(label, style: const TextStyle(color: Colors.white)));
}



class SocialItem extends StatelessWidget {
  /// The FontAwesome icon to display.
  final IconData icon;
  /// The label underneath the icon.
  final String label;
  /// The URL to open when the user taps this item.
  final String url;

  const SocialItem({
    required this.icon,
    required this.label,
    required this.url,
    Key? key,
  }) : super(key: key);

  void _launch() {
    // Opens in a new browser tab
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launch,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}


/// A button that opens a small subject+body dialog and then
/// launches the user’s mail client via a mailto: link.
class EmailButton extends StatelessWidget {
  /// The email address to send to.
  final String toAddress;
  /// The button’s label.
  final String label;
  /// Accent color for outlines / buttons.
  final Color accentColor;

  const EmailButton({
    required this.toAddress,
    required this.label,
    this.accentColor = Colors.cyanAccent,
    Key? key,
  }) : super(key: key);

  void _openEmailDialog(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54, // dim the background
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send me an email',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: subjectCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final subject = Uri.encodeComponent(subjectCtrl.text);
                        final body = Uri.encodeComponent(bodyCtrl.text);
                        final mailto = 'mailto:$toAddress'
                            '?subject=$subject&body=$body';
                        html.window.open(mailto, '_self');
                        Navigator.of(context).pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Text('Send', style: TextStyle(color: Colors.black)),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _openEmailDialog(context),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: accentColor),
        foregroundColor: accentColor,
      ),
      child: Text(label),
    );
  }
}
