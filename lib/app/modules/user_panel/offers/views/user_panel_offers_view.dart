import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_offers_controller.dart';

class UserPanelOffersView extends GetView<UserPanelOffersController> {
  const UserPanelOffersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelOffersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelOffersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
