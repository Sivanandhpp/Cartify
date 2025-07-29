import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/admin_sidebar.dart';
import 'pages/dashboard_overview_page.dart';
import 'pages/products_management_page.dart';
import 'pages/orders_management_page.dart';
import 'pages/customers_management_page.dart';
import 'pages/analytics_page.dart';
import 'pages/settings_page.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: AdminSidebar(
        menuItems: controller.menuItems,
        selectedIndex: controller.selectedIndex.value,
        onItemSelected: (index) {
          controller.selectMenuItem(index);
          Navigator.of(context).pop(); // Close drawer after selection
        },
        onLogout: controller.logOut,
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              // Top App Bar with menu toggle
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 600 ? 24 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.black87,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _getPageTitle(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_rounded,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Page Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                            child: child,
                          ),
                        );
                      },
                  child: _getSelectedPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (controller.selectedIndex.value) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Products';
      case 2:
        return 'Orders';
      case 3:
        return 'Customers';
      case 4:
        return 'Analytics';
      case 5:
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }

  Widget _getSelectedPage() {
    switch (controller.selectedIndex.value) {
      case 0:
        return const DashboardOverviewPage();
      case 1:
        return const ProductsManagementPage();
      case 2:
        return const OrdersManagementPage();
      case 3:
        return const CustomersManagementPage();
      case 4:
        return const AnalyticsPage();
      case 5:
        return const SettingsPage();
      default:
        return const DashboardOverviewPage();
    }
  }
}
