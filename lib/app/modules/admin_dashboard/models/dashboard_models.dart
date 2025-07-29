import 'package:flutter/material.dart';

class DashboardStats {
  final int totalProducts;
  final int totalOrders;
  final int totalUsers;
  final double totalRevenue;
  final int lowStockProducts;
  final int pendingOrders;
  final double monthlyRevenue;
  final double growthPercentage;

  DashboardStats({
    this.totalProducts = 0,
    this.totalOrders = 0,
    this.totalUsers = 0,
    this.totalRevenue = 0.0,
    this.lowStockProducts = 0,
    this.pendingOrders = 0,
    this.monthlyRevenue = 0.0,
    this.growthPercentage = 0.0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalProducts: json['totalProducts'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      lowStockProducts: json['lowStockProducts'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] ?? 0.0).toDouble(),
      growthPercentage: (json['growthPercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'totalUsers': totalUsers,
      'totalRevenue': totalRevenue,
      'lowStockProducts': lowStockProducts,
      'pendingOrders': pendingOrders,
      'monthlyRevenue': monthlyRevenue,
      'growthPercentage': growthPercentage,
    };
  }

  DashboardStats copyWith({
    int? totalProducts,
    int? totalOrders,
    int? totalUsers,
    double? totalRevenue,
    int? lowStockProducts,
    int? pendingOrders,
    double? monthlyRevenue,
    double? growthPercentage,
  }) {
    return DashboardStats(
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      totalUsers: totalUsers ?? this.totalUsers,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      growthPercentage: growthPercentage ?? this.growthPercentage,
    );
  }
}

class AdminMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isSelected;
  final Color? color;

  AdminMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isSelected = false,
    this.color,
  });

  AdminMenuItem copyWith({
    String? title,
    IconData? icon,
    String? route,
    bool? isSelected,
    Color? color,
  }) {
    return AdminMenuItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isSelected: isSelected ?? this.isSelected,
      color: color ?? this.color,
    );
  }
}
