import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_cart_controller.dart';

class UserPanelCartView extends GetView<UserPanelCartController> {
  const UserPanelCartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelCartView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelCartView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
