import 'package:cartify/app/core/services/api_clean_url.dart';  // Added import for URL cleaning

class BannerModel {
  final String title;
  final String description;
  final String imageUrl;
  final String backgroundColor;
  final String? targetId;

  BannerModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    this.targetId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: ApiCleanUrl.cleanImageUrl(json['image_url']) ?? '',  // Updated to use clean URL
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      targetId: json['target_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'background_color': backgroundColor,
      'target_id': targetId,
    };
  }
}