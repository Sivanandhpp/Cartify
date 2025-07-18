import 'package:flutter/material.dart';

/// Collection of reusable spacing widgets for consistent layout
class AppSpacers {
  AppSpacers._();

  // Horizontal spacing
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w20 = SizedBox(width: 20);
  static const Widget w24 = SizedBox(width: 24);
  static const Widget w32 = SizedBox(width: 32);
  static const Widget w40 = SizedBox(width: 40);
  static const Widget w48 = SizedBox(width: 48);
  static const Widget w56 = SizedBox(width: 56);
  static const Widget w64 = SizedBox(width: 64);

  // Vertical spacing
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h40 = SizedBox(height: 40);
  static const Widget h48 = SizedBox(height: 48);
  static const Widget h56 = SizedBox(height: 56);
  static const Widget h64 = SizedBox(height: 64);
  static const Widget h80 = SizedBox(height: 80);
  static const Widget h96 = SizedBox(height: 96);

  // Custom spacing
  static Widget width(double width) => SizedBox(width: width);
  static Widget height(double height) => SizedBox(height: height);
  static Widget square(double size) => SizedBox(width: size, height: size);

  // Expanded spacers for flex layouts
  static const Widget expandedH = Expanded(child: SizedBox());
  static const Widget expandedV = Expanded(child: SizedBox());

  // Flexible spacers
  static Widget flexibleH({int flex = 1}) =>
      Flexible(flex: flex, child: const SizedBox());
  static Widget flexibleV({int flex = 1}) =>
      Flexible(flex: flex, child: const SizedBox());

  // Common layout helpers
  static Widget divider({double? height, Color? color, double? thickness}) =>
      Divider(height: height, color: color, thickness: thickness);

  static Widget verticalDivider({
    double? width,
    Color? color,
    double? thickness,
  }) => VerticalDivider(width: width, color: color, thickness: thickness);

  // Page padding
  static const EdgeInsets pagePadding = EdgeInsets.all(16);
  static const EdgeInsets pageHorizontalPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets pageVerticalPadding = EdgeInsets.symmetric(
    vertical: 16,
  );

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(20);

  // List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets listItemPaddingSmall = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  // Input padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );
}
