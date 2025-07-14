import 'package:bevco/app/modules/user_dashboard/views/widgets/category_widget.dart';
import 'package:bevco/app/modules/user_dashboard/views/widgets/header_widget.dart';
import 'package:bevco/app/modules/user_dashboard/views/widgets/hot_deals_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_dashboard_controller.dart';
import 'package:bevco/app/modules/user_dashboard/views/widgets/offer_widget.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(),
                SizedBox(height: 10),
                CategoryWidget(),
                SizedBox(height: 20),
                OfferWidget(),
                SizedBox(height: 20),
                HotDealsWidget(),
                SizedBox(height: 20),
               
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar:  NavigationWidget(),
    
    );
  }
}
