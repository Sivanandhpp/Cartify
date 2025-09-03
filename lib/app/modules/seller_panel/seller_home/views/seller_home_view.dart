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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Stats Cards Section
            SliverToBoxAdapter(
              child: StatsSectionWidget(controller: controller),
            ),

            // Revenue Chart Section
            SliverToBoxAdapter(
              child: ChartSectionWidget(controller: controller),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: ActionsSectionWidget(controller: controller),
            ),

            // Recent Activity Section
            SliverToBoxAdapter(
              child: ActivitySectionWidget(controller: controller),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
