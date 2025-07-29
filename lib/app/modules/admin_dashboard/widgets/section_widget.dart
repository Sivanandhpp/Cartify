import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  const SectionWidget({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 24),
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration:
          backgroundColor != null || borderRadius != null || boxShadow != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              boxShadow: boxShadow,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.only(
                left: padding.horizontal / 2,
                right: padding.horizontal / 2,
                bottom: 16,
              ),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

extension EdgeInsetsExtension on EdgeInsetsGeometry {
  double get horizontal {
    if (this is EdgeInsets) {
      final edgeInsets = this as EdgeInsets;
      return edgeInsets.left + edgeInsets.right;
    }
    return 32; // default value
  }
}
