class TagModel {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? validFrom;
  final DateTime? validUpto;

  TagModel({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.validFrom,
    this.validUpto,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from']) : null,
      validUpto: json['valid_upto'] != null ? DateTime.parse(json['valid_upto']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'valid_from': validFrom?.toIso8601String(),
      'valid_upto': validUpto?.toIso8601String(),
    };
  }
}