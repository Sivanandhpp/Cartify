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
            if (controller.isRevenueLoading.value) {
              return _buildChartShimmer();
            }

            if (controller.revenueData.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('No revenue data available')),
              );
            }

            // Calculate axis values
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
                      return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
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
    if (controller.revenueData.isEmpty) {
      return {'maxY': 200.0, 'interval': 50.0}; // default
    }

    // Step 1: find max revenue
    final maxRevenue = controller.revenueData
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    // Step 2: add 20% buffer
    final requiredMax = maxRevenue * 1.2;

    // Step 3: find order of magnitude
    final magnitude = pow(10, (log(requiredMax) / ln10).floor()).toDouble();

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

                  // Vertical grid lines
                  for (int i = 0; i < 10; i++)
                    Positioned(
                      left: i * 35.0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 1, color: Colors.grey[300]),
                    ),

                  // Chart area shimmer with wavy pattern
                  Positioned.fill(
                    child: CustomPaint(painter: _ChartShimmerPainter()),
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

class _ChartShimmerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Create a wavy pattern similar to chart data
    for (int i = 0; i <= 10; i++) {
      final x = (i / 10) * size.width;
      final y = size.height * (0.3 + 0.4 * (i % 3) / 2); // Create variation
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
