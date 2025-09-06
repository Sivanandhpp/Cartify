import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
/// Model class representing a menu item in the profile
class ProfileMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

/// Widget for displaying a section of menu items
class ProfileMenuSectionWidget extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileMenuSectionWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 12),
        _buildMenuItems(),
      ],
    );
  }

  /// Builds the section title
  Widget _buildSectionTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  /// Builds the menu items container
  Widget _buildMenuItems() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) => _buildMenuItem(item)).toList(),
      ),
    );
  }

  /// Builds individual menu item
  Widget _buildMenuItem(ProfileMenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildMenuIcon(item.icon),
            const SizedBox(width: 16),
            Expanded(child: _buildMenuContent(item)),
            _buildArrowIcon(),
          ],
        ),
      ),
    );
  }

  /// Builds the menu item icon
  Widget _buildMenuIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }

  /// Builds the menu item content (title and subtitle)
  Widget _buildMenuContent(ProfileMenuItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  /// Builds the arrow icon
  Widget _buildArrowIcon() {
    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: AppColors.grey.withOpacity(0.5),
    );
  }
}