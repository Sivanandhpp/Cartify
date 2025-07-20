import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_profile_controller.dart';

class UserPanelProfileView extends GetView<UserPanelProfileController> {
  const UserPanelProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
