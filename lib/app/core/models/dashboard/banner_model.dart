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
      imageUrl: json['image_url'] ?? '',
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      targetId: json['target_id'],
    );
  }
}