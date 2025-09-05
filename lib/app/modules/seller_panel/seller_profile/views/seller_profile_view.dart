import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seller_profile_controller.dart';

class SellerProfileView extends GetView<SellerProfileController> {
  const SellerProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SellerProfileView',
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
          'SellerProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
