import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_dashboard_controller.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
