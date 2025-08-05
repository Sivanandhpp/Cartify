// lib/app/core/services/review/review_service.dart

import 'package:cartify/app/core/models/review/create_review_dto.dart';
import 'package:cartify/app/core/models/review/review_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for reading and submitting product reviews.
class ReviewService {
  final ApiClient _apiClient;

  ReviewService(this._apiClient);

  /// Retrieves all reviews for a specific product.
  Future<List<ReviewModel>> getReviewsForProduct(String productId) async {
    try {
      final response = await _apiClient.dio.get('/reviews/product/$productId');
      return (response.data as List)
          .map((review) => ReviewModel.fromJson(review))
          .toList();
    } on DioException catch (e) {
      print('Error getting reviews: ${e.response?.data}');
      return [];
    }
  }

  /// Submits a new review for a product.
  Future<ReviewModel?> createReview(CreateReviewDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/reviews',
        data: dto.toJson(),
      );
      return ReviewModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error creating review: ${e.response?.data}');
      return null;
    }
  }
}
