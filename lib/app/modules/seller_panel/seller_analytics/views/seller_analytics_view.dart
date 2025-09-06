import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seller_analytics_controller.dart';

class SellerAnalyticsView extends GetView<SellerAnalyticsController> {
  const SellerAnalyticsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SellerAnalyticsView',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SellerAnalyticsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
