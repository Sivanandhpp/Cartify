import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_panel_categories_controller.dart';

class UserPanelCategoriesView extends GetView<UserPanelCategoriesController> {
  const UserPanelCategoriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPanelCategoriesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserPanelCategoriesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
