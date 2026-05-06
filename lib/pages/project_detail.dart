import 'package:flutter/material.dart';
import 'package:term_summary/models.dart';
import 'package:term_summary/components.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({required this.project, super.key});

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
