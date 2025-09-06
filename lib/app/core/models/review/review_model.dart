// lib/app/core/models/review/review_model.dart

import 'package:cartify/app/core/models/user/user_model.dart';

/// Represents a product review.
class ReviewModel {
  final String id;
  final int rating;
  final String? comment;
  final UserModel user;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    required this.user,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      user: UserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
