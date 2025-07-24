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
  static const EdgeInsets paddingSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(large);

  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: medium);

  // Common margins
  static const EdgeInsets marginSmall = EdgeInsets.all(small);
  static const EdgeInsets marginMedium = EdgeInsets.all(medium);
  static const EdgeInsets marginLarge = EdgeInsets.all(large);

  static const EdgeInsets marginHorizontal = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets marginVertical = EdgeInsets.symmetric(vertical: medium);
  
  // Common border radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(large));
  static const BorderRadius radiusXlarge = BorderRadius.all(Radius.circular(xlarge));

  // Spacing widgets - no need for separate file!
  static const Widget spaceSmall = SizedBox(height: small);
  static const Widget spaceMedium = SizedBox(height: medium);
  static const Widget spaceLarge = SizedBox(height: large);

  static const Widget spaceSmallW = SizedBox(width: small);
  static const Widget spaceMediumW = SizedBox(width: medium);
  static const Widget spaceLargeW = SizedBox(width: large);
}
