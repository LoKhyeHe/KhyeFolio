import 'package:flutter/material.dart';
import 'package:term_summary/models.dart';
import 'package:term_summary/components.dart';

class ExperienceDetailPage extends StatelessWidget {
  final ExperienceEntry entry;
  final String sectionLabel;

  const ExperienceDetailPage({
    required this.entry,
    this.sectionLabel = 'Experience',
    super.key,
  });

  String _captionFor(String entryId, String imagePath, int index) {
    if (entryId == 'seven') {
      if (index == 0) return 'SEVEN Portfolio Workshop poster.';
      return 'Running the workshop session at SUTD.';
    }
    if (entryId == 'national-service') {
      if (index == 0) return 'Promotion ceremony with a fellow officer.';
      return 'With course mates during National Service.';
    }
    if (entryId == 'weston-robot') {
      if (index == 0) {
        return 'Flutter diagnostic app running on phone and tablet.';
      }
      if (index == 1) return 'With the team and the Unitree robot dog.';
      if (index == 2) return 'Field-testing the UGV with the diagnostic app.';
      return 'Operating the UGV with a remote control and tablet.';
    }
    if (entryId == 'sutd') {
      return 'With the FabLab team at SUTD.';
    }
    if (entryId == 'temasek-polytechnic') {
      return 'Graduation day at Temasek Polytechnic.';
    }
    if (entryId == 'healthcare-engineering-centre') {
      return 'Team photo at the Healthcare Engineering Centre.';
    }
    return '${entry.title} — image ${index + 1}.';
  }

  @override
  Widget build(BuildContext context) {
    final heroImage = entry.imagePaths.isNotEmpty ? entry.imagePaths.first : '';
    final gallery =
        entry.galleryImages.isNotEmpty ? entry.galleryImages : entry.imagePaths;

    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP BAR ──────────────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$sectionLabel / ${entry.title}',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // ── HERO IMAGE ───────────────────────────────────────────────────
            if (heroImage.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 340,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    BlurBackedImage(
                      assetPath: heroImage,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.4, 1.0],
                          colors: [Colors.transparent, kBg],
                        ),
                      ),
                    ),
                    if (entry.isCurrent)
                      const Positioned(
                        top: 20,
                        right: 24,
                        child: _CurrentBadge(),
                      ),
                  ],
                ),
              ),

            // ── CONTENT ──────────────────────────────────────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        entry.subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (entry.tasks.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Divider(color: Colors.white.withValues(alpha: 0.10)),
                        const SizedBox(height: 32),
                        DetailSection(
                          label: 'HIGHLIGHTS',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entry.tasks
                                .map(
                                  (t) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.check_circle_outline,
                                            color: Colors.cyanAccent, size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            t,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15,
                                                height: 1.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                      if (gallery.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        DetailSection(
                          label: 'GALLERY',
                          child: GalleryGrid(
                            title: entry.title,
                            images: gallery,
                            captionFor: (path, index) =>
                                _captionFor(entry.id, path, index),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kCyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCyan.withValues(alpha: 0.6)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: kCyan, size: 8),
          SizedBox(width: 6),
          Text(
            'Current',
            style: TextStyle(
              color: kCyan,
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
