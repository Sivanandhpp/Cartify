import 'package:flutter/material.dart';

/// Simple spacing system for the entire application
class AppSpacing {
  AppSpacing._();

  // Basic spacing values
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;

  // Common paddings
  static const EdgeInsets paddingSmall = EdgeInsets.all(8);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24);

  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: 16);

  // Common border radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(24));

  // Spacing widgets - no need for separate file!
  static const Widget spaceSmall = SizedBox(height: small);
  static const Widget spaceMedium = SizedBox(height: medium);
  static const Widget spaceLarge = SizedBox(height: large);

  static const Widget spaceSmallW = SizedBox(width: small);
  static const Widget spaceMediumW = SizedBox(width: medium);
  static const Widget spaceLargeW = SizedBox(width: large);
}
