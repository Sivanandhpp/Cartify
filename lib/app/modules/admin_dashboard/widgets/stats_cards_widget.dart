import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class StatsCardsWidget extends StatelessWidget {
  final List<StatsCardData> cards;
  final bool isLoading;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;

  const StatsCardsWidget({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.4,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        int responsiveColumnCount = crossAxisCount;
        if (constraints.maxWidth > 800) {
          responsiveColumnCount = 4;
        } else if (constraints.maxWidth > 600) {
          responsiveColumnCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: responsiveColumnCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return DashboardCard(
              title: card.title,
              value: card.value,
              icon: card.icon,
              color: card.color,
              subtitle: card.subtitle,
              onTap: card.onTap,
              isLoading: isLoading,
            );
          },
        );
      },
    );
  }
}

class StatsCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatsCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });
}
