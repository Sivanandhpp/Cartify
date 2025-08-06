/// Product review and rating models
///
/// This file contains all models related to product reviews and ratings,
/// including review creation, display, and aggregation functionality.

import '../catalog/catalog_models.dart';
import '../user/user_models.dart';

/// Individual product review with rating and comment
///
/// Represents a single review left by a user for a specific product,
/// including rating, comment, and metadata for display and moderation.
class ProductReview {
  /// Unique identifier for the review
  final String id;

  /// ID of the product being reviewed
  final String productId;

  /// Product information (populated in detailed responses)
  final Product? product;

  /// ID of the user who wrote the review
  final String userId;

  /// User information (populated in responses, may be limited for privacy)
  final UserProfile? user;

  /// Rating given by the user (1 to 5 stars)
  final int rating;

  /// Review title or headline (optional)
  final String? title;

  /// Review comment or detailed feedback (optional)
  final String? comment;

  /// Whether the review is verified (user purchased the product)
  final bool isVerified;

  /// Whether the review is currently visible to other users
  final bool isVisible;

  /// Number of users who found this review helpful
  final int helpfulCount;

  /// Timestamp when the review was created
  final DateTime createdAt;

  /// Timestamp when the review was last updated
  final DateTime updatedAt;

  const ProductReview({
    required this.id,
    required this.productId,
    this.product,
    required this.userId,
    this.user,
    required this.rating,
    this.title,
    this.comment,
    required this.isVerified,
    required this.isVisible,
    required this.helpfulCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
    id: json['id'] as String,
    productId: json['product_id'] as String,
    product: json['product'] != null
        ? Product.fromJson(json['product'] as Map<String, dynamic>)
        : null,
    userId: json['user_id'] as String,
    user: json['user'] != null
        ? UserProfile.fromJson(json['user'] as Map<String, dynamic>)
        : null,
    rating: json['rating'] as int,
    title: json['title'] as String?,
    comment: json['comment'] as String?,
    isVerified: json['is_verified'] as bool,
    isVisible: json['is_visible'] as bool,
    helpfulCount: json['helpful_count'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'product': product?.toJson(),
    'user_id': userId,
    'user': user?.toJson(),
    'rating': rating,
    'title': title,
    'comment': comment,
    'is_verified': isVerified,
    'is_visible': isVisible,
    'helpful_count': helpfulCount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  ProductReview copyWith({
    String? id,
    String? productId,
    Product? product,
    String? userId,
    UserProfile? user,
    int? rating,
    String? title,
    String? comment,
    bool? isVerified,
    bool? isVisible,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProductReview(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    product: product ?? this.product,
    userId: userId ?? this.userId,
    user: user ?? this.user,
    rating: rating ?? this.rating,
    title: title ?? this.title,
    comment: comment ?? this.comment,
    isVerified: isVerified ?? this.isVerified,
    isVisible: isVisible ?? this.isVisible,
    helpfulCount: helpfulCount ?? this.helpfulCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Check if the review has a title
  bool get hasTitle => title != null && title!.isNotEmpty;

  /// Check if the review has a comment
  bool get hasComment => comment != null && comment!.isNotEmpty;

  /// Check if the review has any text content
  bool get hasContent => hasTitle || hasComment;

  /// Get the display name for the reviewer (respecting privacy)
  String get reviewerDisplayName {
    if (user?.name != null && user!.name!.isNotEmpty) {
      // Show only first name and last initial for privacy
      final nameParts = user!.name!.split(' ');
      if (nameParts.length > 1) {
        return '${nameParts.first} ${nameParts.last.substring(0, 1)}.';
      }
      return nameParts.first;
    }
    return 'Anonymous User';
  }

  /// Get formatted review date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get star rating as a string (e.g., "★★★★☆")
  String get starRating {
    return '★' * rating + '☆' * (5 - rating);
  }

  /// Get rating text description
  String get ratingDescription {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Unrated';
    }
  }

  /// Get verification badge text
  String get verificationBadge =>
      isVerified ? 'Verified Purchase' : 'Unverified';

  /// Get helpful count text
  String get helpfulText {
    if (helpfulCount == 0) return 'No helpful votes yet';
    return '$helpfulCount ${helpfulCount == 1 ? 'person' : 'people'} found this helpful';
  }

  @override
  String toString() =>
      'ProductReview('
      'id: $id, '
      'productId: $productId, '
      'rating: $rating, '
      'isVerified: $isVerified, '
      'helpfulCount: $helpfulCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductReview &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          userId == other.userId &&
          rating == other.rating &&
          title == other.title &&
          comment == other.comment &&
          isVerified == other.isVerified &&
          helpfulCount == other.helpfulCount;

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    userId,
    rating,
    title,
    comment,
    isVerified,
    helpfulCount,
  );
}

/// Data transfer object for creating new product reviews
///
/// Contains all required and optional fields for submitting a product review.
class CreateReviewDto {
  /// ID of the product being reviewed
  final String productId;

  /// Rating given by the user (1 to 5 stars)
  final int rating;

  /// Review title or headline (optional)
  final String? title;

  /// Review comment or detailed feedback (optional)
  final String? comment;

  const CreateReviewDto({
    required this.productId,
    required this.rating,
    this.title,
    this.comment,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'rating': rating,
    'title': title,
    'comment': comment,
  };

  /// Create instance from JSON
  factory CreateReviewDto.fromJson(Map<String, dynamic> json) =>
      CreateReviewDto(
        productId: json['product_id'] as String,
        rating: json['rating'] as int,
        title: json['title'] as String?,
        comment: json['comment'] as String?,
      );

  /// Validate the DTO data
  bool get isValid =>
      productId.isNotEmpty &&
      rating >= 1 &&
      rating <= 5 &&
      (title == null || title!.isNotEmpty) &&
      (comment == null || comment!.isNotEmpty);

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (productId.isEmpty) errors.add('Product ID is required');
    if (rating < 1 || rating > 5) errors.add('Rating must be between 1 and 5');
    if (title != null && title!.isEmpty)
      errors.add('Title cannot be empty if provided');
    if (comment != null && comment!.isEmpty)
      errors.add('Comment cannot be empty if provided');

    return errors;
  }

  /// Check if the review has any text content
  bool get hasContent =>
      (title != null && title!.isNotEmpty) ||
      (comment != null && comment!.isNotEmpty);

  @override
  String toString() =>
      'CreateReviewDto('
      'productId: $productId, '
      'rating: $rating, '
      'hasTitle: ${title != null}, '
      'hasComment: ${comment != null})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateReviewDto &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          rating == other.rating &&
          title == other.title &&
          comment == other.comment;

  @override
  int get hashCode => Object.hash(productId, rating, title, comment);
}

/// Aggregated review statistics for a product
///
/// Contains summary information about all reviews for a product,
/// including average rating, rating distribution, and review counts.
class ReviewStatistics {
  /// ID of the product these statistics belong to
  final String productId;

  /// Total number of reviews
  final int totalReviews;

  /// Average rating (0.0 to 5.0)
  final double averageRating;

  /// Number of 5-star reviews
  final int fiveStarCount;

  /// Number of 4-star reviews
  final int fourStarCount;

  /// Number of 3-star reviews
  final int threeStarCount;

  /// Number of 2-star reviews
  final int twoStarCount;

  /// Number of 1-star reviews
  final int oneStarCount;

  /// Number of verified purchase reviews
  final int verifiedReviewsCount;

  /// Timestamp when statistics were last calculated
  final DateTime lastUpdated;

  const ReviewStatistics({
    required this.productId,
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
    required this.verifiedReviewsCount,
    required this.lastUpdated,
  });

  /// Create instance from JSON response
  factory ReviewStatistics.fromJson(Map<String, dynamic> json) =>
      ReviewStatistics(
        productId: json['product_id'] as String,
        totalReviews: json['total_reviews'] as int,
        averageRating: (json['average_rating'] as num).toDouble(),
        fiveStarCount: json['five_star_count'] as int,
        fourStarCount: json['four_star_count'] as int,
        threeStarCount: json['three_star_count'] as int,
        twoStarCount: json['two_star_count'] as int,
        oneStarCount: json['one_star_count'] as int,
        verifiedReviewsCount: json['verified_reviews_count'] as int,
        lastUpdated: DateTime.parse(json['last_updated'] as String),
      );

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'total_reviews': totalReviews,
    'average_rating': averageRating,
    'five_star_count': fiveStarCount,
    'four_star_count': fourStarCount,
    'three_star_count': threeStarCount,
    'two_star_count': twoStarCount,
    'one_star_count': oneStarCount,
    'verified_reviews_count': verifiedReviewsCount,
    'last_updated': lastUpdated.toIso8601String(),
  };

  /// Get formatted average rating (e.g., "4.2")
  String get formattedAverageRating => averageRating.toStringAsFixed(1);

  /// Get formatted total reviews text
  String get formattedReviewCount {
    if (totalReviews == 0) return 'No reviews';
    return '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}';
  }

  /// Get percentage of 5-star reviews
  double get fiveStarPercentage =>
      totalReviews > 0 ? (fiveStarCount / totalReviews) * 100 : 0.0;

  /// Get percentage of 4-star reviews
  double get fourStarPercentage =>
      totalReviews > 0 ? (fourStarCount / totalReviews) * 100 : 0.0;

  /// Get percentage of 3-star reviews
  double get threeStarPercentage =>
      totalReviews > 0 ? (threeStarCount / totalReviews) * 100 : 0.0;

  /// Get percentage of 2-star reviews
  double get twoStarPercentage =>
      totalReviews > 0 ? (twoStarCount / totalReviews) * 100 : 0.0;

  /// Get percentage of 1-star reviews
  double get oneStarPercentage =>
      totalReviews > 0 ? (oneStarCount / totalReviews) * 100 : 0.0;

  /// Get percentage of verified reviews
  double get verifiedReviewsPercentage =>
      totalReviews > 0 ? (verifiedReviewsCount / totalReviews) * 100 : 0.0;

  /// Get count for a specific star rating
  int getCountForRating(int rating) {
    switch (rating) {
      case 5:
        return fiveStarCount;
      case 4:
        return fourStarCount;
      case 3:
        return threeStarCount;
      case 2:
        return twoStarCount;
      case 1:
        return oneStarCount;
      default:
        return 0;
    }
  }

  /// Get percentage for a specific star rating
  double getPercentageForRating(int rating) {
    if (totalReviews == 0) return 0.0;
    return (getCountForRating(rating) / totalReviews) * 100;
  }

  /// Get star rating as a string (e.g., "★★★★☆")
  String get starRating {
    final fullStars = averageRating.floor();
    final hasHalfStar = averageRating - fullStars >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return '★' * fullStars + (hasHalfStar ? '☆' : '') + '☆' * emptyStars;
  }

  /// Check if the product has any reviews
  bool get hasReviews => totalReviews > 0;

  /// Check if the product has mostly positive reviews (4+ stars)
  bool get isMostlyPositive {
    if (totalReviews == 0) return false;
    final positiveReviews = fiveStarCount + fourStarCount;
    return (positiveReviews / totalReviews) >= 0.7; // 70% or more positive
  }

  /// Get the most common rating
  int get mostCommonRating {
    final counts = [
      oneStarCount,
      twoStarCount,
      threeStarCount,
      fourStarCount,
      fiveStarCount,
    ];
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    return counts.indexOf(maxCount) + 1;
  }

  @override
  String toString() =>
      'ReviewStatistics('
      'productId: $productId, '
      'totalReviews: $totalReviews, '
      'averageRating: ${formattedAverageRating}, '
      'verifiedReviews: $verifiedReviewsCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewStatistics &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          totalReviews == other.totalReviews &&
          averageRating == other.averageRating &&
          fiveStarCount == other.fiveStarCount &&
          fourStarCount == other.fourStarCount &&
          threeStarCount == other.threeStarCount &&
          twoStarCount == other.twoStarCount &&
          oneStarCount == other.oneStarCount &&
          verifiedReviewsCount == other.verifiedReviewsCount;

  @override
  int get hashCode => Object.hash(
    productId,
    totalReviews,
    averageRating,
    fiveStarCount,
    fourStarCount,
    threeStarCount,
    twoStarCount,
    oneStarCount,
    verifiedReviewsCount,
  );
}

/// Response model for paginated review lists
///
/// Contains a list of reviews with pagination information
/// for efficient loading and display of large review datasets.
class ReviewListResponse {
  /// List of reviews for the current page
  final List<ProductReview> reviews;

  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages available
  final int totalPages;

  /// Total number of reviews across all pages
  final int totalReviews;

  /// Number of reviews per page
  final int pageSize;

  /// Whether there is a next page available
  final bool hasNextPage;

  /// Whether there is a previous page available
  final bool hasPreviousPage;

  const ReviewListResponse({
    required this.reviews,
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Create instance from JSON response
  factory ReviewListResponse.fromJson(Map<String, dynamic> json) =>
      ReviewListResponse(
        reviews: (json['reviews'] as List)
            .map(
              (review) =>
                  ProductReview.fromJson(review as Map<String, dynamic>),
            )
            .toList(),
        currentPage: json['current_page'] as int,
        totalPages: json['total_pages'] as int,
        totalReviews: json['total_reviews'] as int,
        pageSize: json['page_size'] as int,
        hasNextPage: json['has_next_page'] as bool,
        hasPreviousPage: json['has_previous_page'] as bool,
      );

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() => {
    'reviews': reviews.map((review) => review.toJson()).toList(),
    'current_page': currentPage,
    'total_pages': totalPages,
    'total_reviews': totalReviews,
    'page_size': pageSize,
    'has_next_page': hasNextPage,
    'has_previous_page': hasPreviousPage,
  };

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => currentPage == totalPages;

  /// Get the start index of items on current page (1-based)
  int get startIndex => (currentPage - 1) * pageSize + 1;

  /// Get the end index of items on current page (1-based)
  int get endIndex {
    final calculated = currentPage * pageSize;
    return calculated > totalReviews ? totalReviews : calculated;
  }

  /// Get pagination info text (e.g., "Showing 1-10 of 25 reviews")
  String get paginationInfo {
    if (totalReviews == 0) return 'No reviews found';
    return 'Showing $startIndex-$endIndex of $totalReviews reviews';
  }

  @override
  String toString() =>
      'ReviewListResponse('
      'reviewCount: ${reviews.length}, '
      'currentPage: $currentPage, '
      'totalPages: $totalPages, '
      'totalReviews: $totalReviews)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewListResponse &&
          runtimeType == other.runtimeType &&
          reviews.length == other.reviews.length &&
          currentPage == other.currentPage &&
          totalPages == other.totalPages &&
          totalReviews == other.totalReviews &&
          pageSize == other.pageSize;

  @override
  int get hashCode => Object.hash(
    reviews.length,
    currentPage,
    totalPages,
    totalReviews,
    pageSize,
  );
}
