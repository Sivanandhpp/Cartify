import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cartify/app/core/index.dart';

import '../../controllers/seller_home_controller.dart';

class StatsSectionWidget extends StatelessWidget {
  final SellerHomeController controller;

  const StatsSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting and user info
                      Text(
                        controller.greetingMessage,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          controller.userName.value.isNotEmpty
                              ? 'Welcome back, ${controller.userName.value}!'
                              : 'Welcome back!',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      // Today's date
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  // Profile Button
                  GestureDetector(
                    onTap: controller.navigateToProfile,
                    child: Obx(
                      () => controller.profileImageUrl.value.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: AppImage.network(
                                url: controller.profileImageUrl.value,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Obx(() {
              // Use proper loading state from controller
              final isStatsLoading = controller.isLoading.value;

              if (isStatsLoading) {
                return _buildStatsShimmer();
              }

              return Row(
                children: [
                  _buildQuickStat(
                    'Today\'s Sales',
                    '₹${controller.todayRevenue.value.toStringAsFixed(0)}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  _buildQuickStat(
                    'Active Orders',
                    controller.pendingOrders.value.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  _buildQuickStat(
                    'Low Stock',
                    controller.lowStockProducts.value.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          _buildStatShimmerItem(),
          Container(height: 40, width: 1, color: Colors.grey[300]),
          _buildStatShimmerItem(),
          Container(height: 40, width: 1, color: Colors.grey[300]),
          _buildStatShimmerItem(),
        ],
      ),
    );
  }

  Widget _buildStatShimmerItem() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon placeholder
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              // Value placeholder
              Container(
                width: 40,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Label placeholder
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
