import 'package:flutter/material.dart';
import 'package:term_summary/models.dart';
import 'package:term_summary/components.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({required this.project, super.key});

  void _openGallery(BuildContext context, int initialIndex) {
    final images = project.galleryImages.isNotEmpty
        ? project.galleryImages
        : [project.imagePath];
    final captions = List<String>.generate(
      images.length,
      (i) => _captionFor(project.id, images[i], i),
    );
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.90),
      builder: (_) => _GalleryLightbox(
        title: project.title,
        images: images,
        captions: captions,
        initialIndex: initialIndex,
      ),
    );
  }

  String _captionFor(String projectId, String imagePath, int index) {
    if (projectId == 'pulsepath') {
      if (index == 0) return 'Final concept poster and product positioning.';
      if (imagePath.contains('team')) return 'Team showcase and demo setup at presentation.';
      return 'PulsePath prototype iteration and field test snapshot.';
    }
    if (projectId == 'wbgt-solar-panel') {
      if (index == 0) return 'Primary WBGT project cover image.';
      return 'WBGT prototype photo from development and outdoor testing.';
    }
    return 'Project image ${index + 1}.';
  }

  @override
  Widget build(BuildContext context) {
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
                      'Projects / ${project.title}',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // ── HERO IMAGE ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 380,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(project.imagePath, fit: BoxFit.cover),
                  // gradient fade to black at the bottom
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
                  // status badge overlay top-right
                  Positioned(
                    top: 20,
                    right: 24,
                    child: StatusBadge(project.status),
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
                      // Title
                      Text(
                        project.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Short desc (lead)
                      Text(
                        project.shortDesc,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),
                      Divider(color: Colors.white.withValues(alpha: 0.10)),
                      const SizedBox(height: 32),

                      // Full description — split on double newline into paragraphs
                      ...project.fullDesc.split('\n\n').map(
                        (para) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            para,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                              height: 1.75,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tech stack
                      _DetailSection(
                        label: 'TECH STACK',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.techStack
                              .map((t) => TechChip(t))
                              .toList(),
                        ),
                      ),

                      // Awards
                      if (project.awards.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        _DetailSection(
                          label: 'AWARDS',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: project.awards
                                .map(
                                  (a) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.emoji_events,
                                            color: Colors.amber, size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            a,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15),
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

                      // Features / highlights
                      if (project.features.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        _DetailSection(
                          label: 'HIGHLIGHTS',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: project.features
                                .map(
                                  (f) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.cyanAccent,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            f,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15),
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

                      const SizedBox(height: 32),
                      _DetailSection(
                        label: 'GALLERY',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kCard.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final images = project.galleryImages.isNotEmpty
                                  ? project.galleryImages
                                  : [project.imagePath];
                              final isNarrow = constraints.maxWidth < 700;
                              final cardWidth = isNarrow
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 16) / 2;
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: List.generate(images.length, (index) {
                                  final big = index == 0;
                                  final height = big ? 240.0 : 180.0;
                                  return GestureDetector(
                                    onTap: () => _openGallery(context, index),
                                    child: Container(
                                      width: big && !isNarrow
                                          ? constraints.maxWidth
                                          : cardWidth,
                                      height: height,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.15),
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(images[index], fit: BoxFit.cover),
                                          Positioned.fill(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black.withValues(alpha: 0.55),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 12,
                                            right: 12,
                                            bottom: 10,
                                            child: Text(
                                              _captionFor(project.id, images[index], index),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ),
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

class _GalleryLightbox extends StatefulWidget {
  final String title;
  final List<String> images;
  final List<String> captions;
  final int initialIndex;

  const _GalleryLightbox({
    required this.title,
    required this.images,
    required this.captions,
    required this.initialIndex,
  });

  @override
  State<_GalleryLightbox> createState() => _GalleryLightboxState();
}

class _GalleryLightboxState extends State<_GalleryLightbox> {
  late final PageController _pageController;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 760),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 32,
              spreadRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 10, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.title}  ·  Gallery',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(widget.images[i], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  if (widget.images.length > 1) ...[
                    Positioned(
                      left: 12,
                      child: _galleryArrow(
                        icon: Icons.chevron_left,
                        onTap: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      child: _galleryArrow(
                        icon: Icons.chevron_right,
                        onTap: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.captions[_index],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 78,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                    );
                    setState(() => _index = i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: i == _index ? kCyan : Colors.white24,
                        width: i == _index ? 1.8 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        widget.images[i],
                        width: 100,
                        height: 62,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryArrow({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white70, size: 28),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}
