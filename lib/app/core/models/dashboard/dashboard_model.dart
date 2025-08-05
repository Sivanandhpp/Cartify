// lib/app/core/models/dashboard/dashboard_model.dart

/// Represents the entire dashboard structure.
class DashboardModel {
  final List<DashboardSection> sections;

  DashboardModel({required this.sections});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      sections: (json['sections'] as List)
          .map((section) => DashboardSection.fromJson(section))
          .toList(),
    );
  }
}

/// Represents a single section in the dashboard.
class DashboardSection {
  final String type;
  final String? title;
  final List<dynamic> data;

  DashboardSection({required this.type, this.title, required this.data});

  factory DashboardSection.fromJson(Map<String, dynamic> json) {
    return DashboardSection(
      type: json['type'],
      title: json['title'],
      data: json['data'],
    );
  }
}
