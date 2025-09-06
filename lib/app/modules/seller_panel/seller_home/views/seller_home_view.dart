import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_home_controller.dart';
import 'widgets/stats_section_widget.dart';
import 'widgets/chart_section_widget.dart';
import 'widgets/actions_section_widget.dart';
import 'widgets/activity_section_widget.dart';

class SellerHomeView extends GetView<SellerHomeController> {
  const SellerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Stats Cards Section
                StatsSectionWidget(controller: controller),
                
                // Chart Section
                ChartSectionWidget(controller: controller),
                
                // Quick Actions Section
                ActionsSectionWidget(controller: controller),
                
                // Recent Activity Section
                ActivitySectionWidget(controller: controller),
                
                // Bottom padding
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}