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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: [
            ElevatedButton(
              onPressed: () {
                // Example action
                controller.logOut();
                
              },
              child: const Text('LOGOUT'),
            ),
            Text(
              'UserDashboardView is working',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
