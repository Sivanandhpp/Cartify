import 'package:flutter/material.dart';

/// Standard padding values used throughout the application
class AppPaddings {
  AppPaddings._();

  // Horizontal paddings
  static const EdgeInsets horizontal4 = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets horizontal8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets horizontal24 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets horizontal32 = EdgeInsets.symmetric(horizontal: 32);

  // Vertical paddings
  static const EdgeInsets vertical4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets vertical8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets vertical32 = EdgeInsets.symmetric(vertical: 32);

  // All sides paddings
  static const EdgeInsets all4 = EdgeInsets.all(4);
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all12 = EdgeInsets.all(12);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);
  static const EdgeInsets all32 = EdgeInsets.all(32);

  // Custom paddings
  static const EdgeInsets page = EdgeInsets.all(16);
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets pageVertical = EdgeInsets.symmetric(vertical: 16);

  static const EdgeInsets card = EdgeInsets.all(12);
  static const EdgeInsets cardLarge = EdgeInsets.all(20);

  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets listItemSmall = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );
  static const EdgeInsets buttonSmall = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  static const EdgeInsets input = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets inputContent = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  // Screen safe area paddings
  static const EdgeInsets safeTop = EdgeInsets.only(
    top: 44,
  ); // Status bar height
  static const EdgeInsets safeBottom = EdgeInsets.only(
    bottom: 34,
  ); // Home indicator

  // Custom spacing combinations
  static const EdgeInsets topBottom16 = EdgeInsets.only(top: 16, bottom: 16);
  static const EdgeInsets leftRight16 = EdgeInsets.only(left: 16, right: 16);

  // Form paddings
  static const EdgeInsets formField = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets formContainer = EdgeInsets.all(20);

  // Dialog paddings
  static const EdgeInsets dialog = EdgeInsets.all(24);
  static const EdgeInsets dialogContent = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  // App bar paddings
  static const EdgeInsets appBar = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets appBarAction = EdgeInsets.symmetric(horizontal: 8);
}

