import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buyer_offers_controller.dart';

class BuyerOffersView extends GetView<BuyerOffersController> {
  const BuyerOffersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyerOffersView', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BuyerOffersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
