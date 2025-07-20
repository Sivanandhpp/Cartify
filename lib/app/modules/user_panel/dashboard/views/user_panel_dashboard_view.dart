import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_dashboard_controller.dart';

class UserPanelDashboardView extends GetView<UserPanelDashboardController> {
  const UserPanelDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
