import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_home_controller.dart';

class UserPanelHomeView extends GetView<UserPanelHomeController> {
  const UserPanelHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
