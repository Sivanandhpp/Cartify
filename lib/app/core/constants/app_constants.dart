// core/constants/app_durations.dart
import 'package:flutter/material.dart';

class AppDurations {
  static const otpSnackbar = Duration(seconds: 3);
  static const animation = Duration(milliseconds: 300);
}

// Login View Validation
class AppRegex {
  static final phone = RegExp(r'^[6-9]\d{9}$');
}

class AppBorderRadius {
  static final BorderRadius primaryBorder = BorderRadius.circular(40.0);
  static final BorderRadius secondaryBorder = BorderRadius.circular(20.0);
  static const BorderRadius verticalPrimaryBorder = BorderRadius.vertical(
    top: Radius.circular(40),
  );
}
// class AppConstants {
//   static const double padding = 16.0;
//   static const double cornerRadius = 20.0;
//   static const Duration animationDuration = Duration(milliseconds: 300);
// }
// class AppConstants {
//   static const String placeholderImage = 'https://via.placeholder.com/150';
//   static const String boatLogo = 'https://via.placeholder.com/80x40/000000/FFFFFF?text=boAt';
//   static const String electronicsImage = 'https://via.placeholder.com/150/CCCCCC/333333?text=Electronics';
//   static const String homeKitchenImage = 'https://via.placeholder.com/150/FFCCCC/333333?text=Home+Kitchen';
// }