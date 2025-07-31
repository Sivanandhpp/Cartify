import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seller_dashboard_controller.dart';

class SellerDashboardView extends GetView<SellerDashboardController> {
  const SellerDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SellerDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SellerDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
