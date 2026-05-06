class Project {
  final String id;
  final String title;
  final String status; // 'completed' | 'ongoing'
  final String shortDesc;
  final String fullDesc;
  final String imagePath;
  final List<String> techStack;
  final List<String> awards;
  final List<String> features;

  const Project({
    required this.id,
    required this.title,
    required this.status,
    required this.shortDesc,
    required this.fullDesc,
    required this.imagePath,
    required this.techStack,
    required this.awards,
    required this.features,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      shortDesc: json['shortDesc'] as String,
      fullDesc: json['fullDesc'] as String,
      imagePath: json['imagePath'] as String,
      techStack: List<String>.from(json['techStack'] as List),
      awards: List<String>.from(json['awards'] as List),
      features: List<String>.from(json['features'] as List),
    );
  }

  factory Project.fromDb(Map<String, dynamic> json) {
    List<String> toStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return const [];
    }

    return Project(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      status: (json['status'] ?? 'ongoing').toString(),
      shortDesc: (json['short_desc'] ?? '').toString(),
      fullDesc: (json['full_desc'] ?? '').toString(),
      imagePath: (json['image_path'] ?? '').toString(),
      techStack: toStringList(json['tech_stack']),
      awards: toStringList(json['awards']),
      features: toStringList(json['features']),
    );
  }
}

class ExperienceEntry {
  final String title;
  final String subtitle;
  final List<String> tasks;
  final bool isCurrent;

  const ExperienceEntry({
    required this.title,
    required this.subtitle,
    required this.tasks,
    this.isCurrent = false,
  });
}
