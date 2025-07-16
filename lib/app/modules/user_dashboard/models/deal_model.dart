import 'package:flutter/material.dart';

class DealModel {
  final String title;
  final String subtitle;
  final Color color;
  final String? imageUrl; // Optional image for deals like 'boAt'

  DealModel({
    required this.title,
    required this.subtitle,
    required this.color,
    this.imageUrl,
  });
}
