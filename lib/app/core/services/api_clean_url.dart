import 'package:cartify/app/core/config/app_config.dart';

/// Service for cleaning and formatting URLs from API responses
class ApiCleanUrl {
  ApiCleanUrl._();

  /// Clean and format image URLs by removing unwanted characters and building absolute URLs
  static String? cleanImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    // Remove curly braces, square brackets, and extra whitespace
    String cleanUrl = url
        .replaceAll(RegExp(r'[{}[\]]'), '') // Remove {}, []
        .trim(); // Remove leading/trailing whitespace

    if (cleanUrl.isEmpty) return null;

    // Handle comma-separated URLs (take the first one if multiple)
    if (cleanUrl.contains(',')) {
      cleanUrl = cleanUrl.split(',').first.trim();
    }

    // If it's already an absolute URL, return as-is
    if (cleanUrl.startsWith('http') || cleanUrl.startsWith('https')) {
      return cleanUrl;
    }

    // If it's a server-relative path (starts with '/'), prefix base URL
    if (cleanUrl.startsWith('/')) {
      return '${AppConfig.baseUrl}$cleanUrl';
    }

    // If it looks like a relative static path without leading slash, prefix with '/'
    if (cleanUrl.contains('static') ||
        cleanUrl.contains('category') ||
        cleanUrl.contains('image') ||
        cleanUrl.contains('product')) {
      return '${AppConfig.baseUrl}/$cleanUrl';
    }

    // For other relative paths, add base URL with leading slash
    return '${AppConfig.baseUrl}/$cleanUrl';
  }

  /// Clean a list of image URLs
  static List<String> cleanImageUrls(dynamic images) {
    if (images == null) return [];

    // Handle List of images
    if (images is List) {
      return images
          .map((e) => cleanImageUrl(e?.toString()))
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
    }

    // Handle single string URL
    if (images is String) {
      final cleanUrl = cleanImageUrl(images);
      return cleanUrl != null && cleanUrl.isNotEmpty ? [cleanUrl] : [];
    }

    // Handle Set or other collection types
    if (images is Set) {
      return images
          .map((e) => cleanImageUrl(e?.toString()))
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
    }

    return [];
  }

  /// Clean profile picture URLs (same logic as image URLs)
  static String? cleanProfilePictureUrl(String? url) {
    return cleanImageUrl(url);
  }

  /// Clean category image URLs (same logic as image URLs)
  static String? cleanCategoryImageUrl(String? url) {
    return cleanImageUrl(url);
  }
}