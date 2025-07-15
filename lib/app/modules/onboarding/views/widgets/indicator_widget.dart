import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int current, count;
  const Indicator({super.key, required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: i == current ? AppColors.primary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
