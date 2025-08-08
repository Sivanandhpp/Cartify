import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seller_home_controller.dart';

class SellerHomeView extends GetView<SellerHomeController> {
  const SellerHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SellerHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SellerHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
