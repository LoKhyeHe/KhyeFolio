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
  final List<String> galleryImages;

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
    required this.galleryImages,
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
      galleryImages: json['galleryImages'] == null
          ? const []
          : List<String>.from(json['galleryImages'] as List),
    );
  }
}

class ExperienceEntry {
  final String title;
  final String subtitle;
  final List<String> tasks;
  final String imagePath;
  final bool isCurrent;

  const ExperienceEntry({
    required this.title,
    required this.subtitle,
    required this.tasks,
    required this.imagePath,
    this.isCurrent = false,
  });
}
