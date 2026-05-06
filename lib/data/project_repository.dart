import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:term_summary/models.dart';

class ProjectRepository {
  Future<List<Project>> loadProjects() async {
    try {
      final rows = await Supabase.instance.client
          .from('projects')
          .select()
          .eq('is_published', true)
          .order('sort_order', ascending: true);
      return rows
          .map<Project>((row) => Project.fromDb(row))
          .toList();
    } catch (_) {
      return _loadLocalProjects();
    }
  }

  Future<List<Project>> _loadLocalProjects() async {
    final raw = await rootBundle.loadString('lib/assets/projects.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['projects'] as List)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
