import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buyer_wishlist_controller.dart';

class BuyerWishlistView extends GetView<BuyerWishlistController> {
  const BuyerWishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyerWishlistView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BuyerWishlistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
