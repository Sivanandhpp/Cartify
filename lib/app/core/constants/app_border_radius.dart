import 'package:flutter/material.dart';

/// Standard border radius values used throughout the application
class AppBorderRadius {
  AppBorderRadius._();

  // Circular border radius
  static const BorderRadius circular4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius circular6 = BorderRadius.all(Radius.circular(6));
  static const BorderRadius circular8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius circular12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius circular16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius circular20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius circular24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius circular32 = BorderRadius.all(Radius.circular(32));

  // Common component radius
  static const BorderRadius button = circular24;
  static const BorderRadius card = circular12;
  static const BorderRadius input = circular8;
  static const BorderRadius dialog = circular16;
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );
  static const BorderRadius topSheet = BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  // Specific corner radius
  static const BorderRadius topLeft8 = BorderRadius.only(
    topLeft: Radius.circular(8),
  );
  static const BorderRadius topRight8 = BorderRadius.only(
    topRight: Radius.circular(8),
  );
  static const BorderRadius bottomLeft8 = BorderRadius.only(
    bottomLeft: Radius.circular(8),
  );
  static const BorderRadius bottomRight8 = BorderRadius.only(
    bottomRight: Radius.circular(8),
  );

  static const BorderRadius topLeft12 = BorderRadius.only(
    topLeft: Radius.circular(12),
  );
  static const BorderRadius topRight12 = BorderRadius.only(
    topRight: Radius.circular(12),
  );
  static const BorderRadius bottomLeft12 = BorderRadius.only(
    bottomLeft: Radius.circular(12),
  );
  static const BorderRadius bottomRight12 = BorderRadius.only(
    bottomRight: Radius.circular(12),
  );

  // Top and bottom combinations
  static const BorderRadius top8 = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(8),
  );
  static const BorderRadius top12 = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
  );
  static const BorderRadius top16 = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );
  static const BorderRadius top20 = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  static const BorderRadius bottom8 = BorderRadius.only(
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
  static const BorderRadius bottom12 = BorderRadius.only(
    bottomLeft: Radius.circular(12),
    bottomRight: Radius.circular(12),
  );
  static const BorderRadius bottom16 = BorderRadius.only(
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );
  static const BorderRadius bottom20 = BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  // Left and right combinations
  static const BorderRadius left8 = BorderRadius.only(
    topLeft: Radius.circular(8),
    bottomLeft: Radius.circular(8),
  );
  static const BorderRadius left12 = BorderRadius.only(
    topLeft: Radius.circular(12),
    bottomLeft: Radius.circular(12),
  );

  static const BorderRadius right8 = BorderRadius.only(
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
  static const BorderRadius right12 = BorderRadius.only(
    topRight: Radius.circular(12),
    bottomRight: Radius.circular(12),
  );

  // Special shapes
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius none = BorderRadius.zero;
}
