import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_wishlist_controller.dart';

class UserPanelWishlistView extends GetView<UserPanelWishlistController> {
  const UserPanelWishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelWishlistView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelWishlistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
