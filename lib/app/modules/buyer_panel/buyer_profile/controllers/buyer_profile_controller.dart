// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/buyer_edit_profile_view.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/widgets/profile_menu_section.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller managing buyer profile logic and state
class BuyerProfileController extends GetxController {
  // Dependencies
  final AuthenticationService _authService = Get.find<AuthenticationService>();
  final UserService _userService = Get.find<UserService>();

  // Reactive state
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // Computed getters for UI display
  String get displayName => user.value?.name ?? 'User';
  String get displayEmail => user.value?.email ?? 'No email';
  String get displayPhoneNumber => user.value?.phoneNumber ?? 'No phone';
  String get displayProfilePhoto => user.value?.profilePhotoUrl ?? '';
  bool get hasProfilePhoto => user.value?.profilePhotoUrl?.isNotEmpty == true;
  bool get hasCompleteProfile =>
      user.value?.name?.isNotEmpty == true &&
      user.value?.email?.isNotEmpty == true;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Loads user profile data from service
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final userProfile = await _userService.getUserProfile();
      user.value = userProfile;
      LogService.info('Profile loaded successfully');
    } catch (e) {
      LogService.error('Failed to load profile: $e');
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to load profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes profile data
  Future<void> refreshProfile() async {
    LogService.info('Refreshing profile');
    await loadUserProfile();
  }

  /// Returns account menu items
  List<ProfileMenuItem> getAccountMenuItems() {
    return [
      ProfileMenuItem(
        title: 'My Orders',
        subtitle: 'View your order history',
        icon: Icons.shopping_bag,
        onTap: navigateToOrders,
      ),
      ProfileMenuItem(
        title: 'Addresses',
        subtitle: 'Manage delivery addresses',
        icon: Icons.location_on,
        onTap: navigateToAddresses,
      ),
      ProfileMenuItem(
        title: 'Payment Methods',
        subtitle: 'Manage cards and wallets',
        icon: Icons.payment,
        onTap: navigateToPaymentMethods,
      ),
    ];
  }

  /// Returns preferences menu items
  List<ProfileMenuItem> getPreferencesMenuItems() {
    return [
      ProfileMenuItem(
        title: 'Notifications',
        subtitle: 'Manage notification settings',
        icon: Icons.notifications,
        onTap: navigateToNotifications,
      ),
      ProfileMenuItem(
        title: 'Language',
        subtitle: 'Change app language',
        icon: Icons.language,
        onTap: navigateToLanguage,
      ),
      ProfileMenuItem(
        title: 'Theme',
        subtitle: 'Switch between light and dark',
        icon: Icons.palette,
        onTap: navigateToTheme,
      ),
    ];
  }

  /// Returns support menu items
  List<ProfileMenuItem> getSupportMenuItems() {
    return [
      ProfileMenuItem(
        title: 'Help Center',
        subtitle: 'Get help and support',
        icon: Icons.help,
        onTap: navigateToHelp,
      ),
      ProfileMenuItem(
        title: 'Contact Us',
        subtitle: 'Reach out to customer support',
        icon: Icons.contact_support,
        onTap: navigateToContact,
      ),
      ProfileMenuItem(
        title: 'About',
        subtitle: 'App version and legal info',
        icon: Icons.info,
        onTap: navigateToAbout,
      ),
    ];
  }

  // Navigation methods
  void navigateToOrders() {
    LogService.info('Navigating to orders');
Get.toNamed(Routes.BUYER_ORDERS_VIEW);    
    // Get.toNamed(Routes.ORDERS);
  }

  void navigateToAddresses() {
    Get.toNamed(Routes.BUYER_ADDRESS_VIEW);
  }

  void navigateToPaymentMethods() {
    LogService.info('Navigating to payment methods');
    NotificationService.showInfo(
      title: 'Payment Methods',
      message: 'Opening payment methods...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.PAYMENT_METHODS);
  }

  void navigateToNotifications() {
    LogService.info('Navigating to notifications');
    NotificationService.showInfo(
      title: 'Notifications',
      message: 'Opening notification settings...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.NOTIFICATIONS);
  }

  void navigateToLanguage() {
    LogService.info('Navigating to language settings');
    NotificationService.showInfo(
      title: 'Language',
      message: 'Opening language settings...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.LANGUAGE);
  }

  void navigateToTheme() {
    LogService.info('Navigating to theme settings');
    NotificationService.showInfo(
      title: 'Theme',
      message: 'Opening theme settings...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.THEME);
  }

  void navigateToHelp() {
    LogService.info('Navigating to help center');
    NotificationService.showInfo(
      title: 'Help Center',
      message: 'Opening help center...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.HELP);
  }

  void navigateToContact() {
    LogService.info('Navigating to contact support');
    NotificationService.showInfo(
      title: 'Contact Us',
      message: 'Opening contact options...',
    );
    // TODO: Implement navigation
    // Get.toNamed(Routes.CONTACT);
  }

  void navigateToAbout() {
    LogService.info('Navigating to about page');
    NotificationService.showInfo(title: 'About', message: 'Version 1.0.0');
    // TODO: Implement navigation
    // Get.toNamed(Routes.ABOUT);
  }

  /// Handles profile editing
  void editProfile() {
LogService.info('Opening edit profile page');
  Get.to(() => const BuyerEditProfileView());  }

  /// Shows logout confirmation dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Handles user logout
  Future<void> logout() async {
    try {
      LogService.info('User logging out');
      await _authService.logout();
    } catch (e) {
      LogService.error('Logout failed: $e');
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to logout',
      );
    }
  }
}
