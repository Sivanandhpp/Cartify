import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buyer_home_controller.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  const BuyerHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyerHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BuyerHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
