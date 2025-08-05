// lib/app/core/models/review/create_review_dto.dart

/// DTO for creating a new product review.
class CreateReviewDto {
  final String productId;
  final int rating;
  final String? comment;

  CreateReviewDto({
    required this.productId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'rating': rating,
    };
    if (comment != null) {
      data['comment'] = comment;
    }
    return data;
  }
}
