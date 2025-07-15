import 'package:bevco/app/modules/user_dashboard/controllers/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({super.key});
  final UserDashboardController controller =
      Get.find<UserDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kozhikode Work',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'UL Technology Solutions, UL Cyberpark, UL Cy...',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.logout),
            ),
            onTap: () {
              controller.logOut();
            },
          ),
        ],
      ),
    );
  }
}
