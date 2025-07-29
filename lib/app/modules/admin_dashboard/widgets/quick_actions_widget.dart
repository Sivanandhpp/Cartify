import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final String title;
  final List<QuickActionData> actions;
  final bool isLoading;

  const QuickActionsWidget({
    super.key,
    this.title = 'Quick Actions',
    required this.actions,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: actions
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    QuickActionData action = entry.value;

                    List<Widget> widgets = [];
                    if (index > 0) {
                      widgets.add(
                        SizedBox(width: constraints.maxWidth > 400 ? 16 : 8),
                      );
                    }
                    widgets.add(
                      Expanded(
                        child: QuickActionCard(
                          title: action.title,
                          icon: action.icon,
                          color: action.color,
                          onTap: action.onTap,
                          isLoading: isLoading,
                        ),
                      ),
                    );
                    return widgets;
                  })
                  .expand((widgets) => widgets)
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class QuickActionData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    )
                  : Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
