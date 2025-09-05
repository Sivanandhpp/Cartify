import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cartify/app/core/index.dart';

import '../../controllers/seller_home_controller.dart';

class ChartSectionWidget extends StatelessWidget {
  final SellerHomeController controller;

  const ChartSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '₹${controller.monthlyRevenue.value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: Colors.green[600], size: 16),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        '${controller.monthlyGrowth.value.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Obx(() {
            // Show loading shimmer while data is being fetched or chart is being generated
            if (controller.isLoading ||
                controller.isRevenueLoading.value ||
                !controller.isDataFresh) {
              return _buildChartShimmer();
            }

            // Show no data message only when data is loaded but chart data is empty
            if (controller.revenueData.isEmpty && controller.isDataFresh) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No revenue data available',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start selling to see your revenue chart',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Calculate axis values safely
            final axisValues = _calculateYAxisValues();
            final maxY = axisValues['maxY']!;
            final interval = axisValues['interval']!;

            return SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[200]!, strokeWidth: 2);
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatYAxisLabel(value),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 1,
                  maxX: 10,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.revenueData.map((data) {
                        return FlSpot(data.day.toDouble(), data.amount);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.primary,
                        ],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Last 10 days performance',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Calculates Y-axis values with dynamic scaling based on revenue magnitude
  Map<String, double> _calculateYAxisValues() {
    try {
      if (controller.revenueData.isEmpty) {
        return {'maxY': 200.0, 'interval': 50.0}; // default
      }

      // Step 1: find max revenue
      final maxRevenue = controller.revenueData
          .map((e) => e.amount)
          .reduce((a, b) => a > b ? a : b);

      // Handle case where maxRevenue is 0 or negative
      if (maxRevenue <= 0) {
        return {'maxY': 200.0, 'interval': 50.0}; // default for zero revenue
      }

      // Step 2: add 20% buffer
      final requiredMax = maxRevenue * 1.2;

      // Step 3: find order of magnitude safely
      final logValue = log(requiredMax) / ln10;
      if (logValue.isNaN || logValue.isInfinite) {
        return {'maxY': 200.0, 'interval': 50.0}; // fallback
      }

      final magnitude = pow(10, logValue.floor()).toDouble();

      // Step 4: choose a "nice" step (1, 2, or 5 × magnitude)
      double niceStep;
      if (requiredMax / magnitude <= 1) {
        niceStep = 1 * magnitude;
      } else if (requiredMax / magnitude <= 2) {
        niceStep = 2 * magnitude;
      } else if (requiredMax / magnitude <= 5) {
        niceStep = 5 * magnitude;
      } else {
        niceStep = 10 * magnitude;
      }

      // Step 5: compute maxY (rounded up to nearest niceStep)
      final maxY = ((requiredMax / niceStep).ceil() * niceStep);

      // Step 6: interval for 5 labels
      final interval = maxY / 4;

      return {'maxY': maxY.toDouble(), 'interval': interval.toDouble()};
    } catch (e) {
      // Fallback to default values if any calculation fails
      return {'maxY': 200.0, 'interval': 50.0};
    }
  }

  /// Formats Y-axis labels appropriately based on value magnitude
  String _formatYAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toInt()}K';
    } else {
      return value.toInt().toString();
    }
  }

  Widget _buildChartShimmer() {
    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            // Grid lines shimmer
            Expanded(
              child: Stack(
                children: [
                  // Horizontal grid lines
                  for (int i = 0; i < 5; i++)
                    Positioned(
                      top: i * 40.0,
                      left: 0,
                      right: 0,
                      child: Container(height: 1, color: Colors.grey[300]),
                    ),
                ],
              ),
            ),

            // Bottom axis labels shimmer
            Container(
              height: 30,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  10,
                  (index) =>
                      Container(width: 20, height: 12, color: Colors.grey[300]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
