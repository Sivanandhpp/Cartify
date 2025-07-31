import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/ios_tab_bar.dart';

class TabBarController extends GetxController {
  final selectedIndex = 0.obs;
  final scrollController = ScrollController();

  // Current event (can be null when no events)
  final Rx<EventData?> currentEvent = Rx<EventData?>(null);

  // Tab items for seller dashboard
  List<TabBarItem> get tabItems => [
    TabBarItem(
      icon: Icons.home_outlined,
      label: 'Home',
      isSelected: selectedIndex.value == 0,
      onTap: () => selectTab(0),
    ),
    TabBarItem(
      icon: Icons.shopping_bag_outlined,
      label: 'Orders',
      isSelected: selectedIndex.value == 1,
      onTap: () => selectTab(1),
    ),
    TabBarItem(
      icon: Icons.inventory_2_outlined,
      label: 'Products',
      isSelected: selectedIndex.value == 2,
      onTap: () => selectTab(2),
    ),
    TabBarItem(
      icon: Icons.add_box_outlined,
      label: 'Add Product',
      isSelected: selectedIndex.value == 3,
      onTap: () => selectTab(3),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Simulate an active event (remove this in production)
    _simulateEvent();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void selectTab(int index) {
    selectedIndex.value = index;
  }

  void setEvent(EventData? event) {
    currentEvent.value = event;
  }

  void clearEvent() {
    currentEvent.value = null;
  }

  // Simulate an event for demonstration
  void _simulateEvent() {
    // Example: New order notification
    setEvent(
      EventData(
        title: 'New Order Received',
        subtitle: 'Order #1234 - ₹1,299',
        icon: Icons.notifications_active,
        color: Colors.orange,
      ),
    );

    // Auto-clear after 10 seconds (for demo)
    Future.delayed(const Duration(seconds: 10), () {
      clearEvent();
    });
  }

  // Method to trigger new events
  void showNewOrderEvent(String orderId, String amount) {
    setEvent(
      EventData(
        title: 'New Order Received',
        subtitle: 'Order #$orderId - $amount',
        icon: Icons.shopping_bag,
        color: Colors.green,
      ),
    );
  }

  void showProductLowStockEvent(String productName) {
    setEvent(
      EventData(
        title: 'Low Stock Alert',
        subtitle: '$productName is running low',
        icon: Icons.warning,
        color: Colors.orange,
      ),
    );
  }

  void showPaymentReceivedEvent(String amount) {
    setEvent(
      EventData(
        title: 'Payment Received',
        subtitle: 'Amount: $amount',
        icon: Icons.payment,
        color: Colors.blue,
      ),
    );
  }
}
