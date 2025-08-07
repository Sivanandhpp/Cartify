import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buyer_categories_controller.dart';

class BuyerCategoriesView extends GetView<BuyerCategoriesController> {
  const BuyerCategoriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyerCategoriesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BuyerCategoriesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
