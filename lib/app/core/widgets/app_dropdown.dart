import 'package:flutter/material.dart';
import 'package:cartify/app/core/index.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final void Function(T?) onChanged;
  final IconData? icon;
  final bool enabled;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final double? menuMaxHeight;
  final bool isDense;

  const AppDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.icon,
    this.enabled = true,
    this.validator,
    this.prefixIcon,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.menuMaxHeight,
    this.isDense = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemBuilder(item),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: true,
      isDense: isDense,
      menuMaxHeight: menuMaxHeight ?? 300,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey500),
      iconSize: 20,
      // Add itemHeight to match text field height
      itemHeight: null, // Let it auto-size
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
            prefixIcon ??
            (icon != null
                ? Icon(
                    icon,
                    color: enabled ? AppColors.grey500 : AppColors.grey400,
                    size: 20,
                  )
                : null),
        filled: filled,
        fillColor:
            fillColor ??
            (enabled
                ? AppColors.grey100
                : AppColors.grey100), // Changed to match TextField
        // Label Style
        labelStyle: TextStyle(
          color: enabled ? AppColors.grey600 : AppColors.grey400,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        // Hint Style
        hintStyle: const TextStyle(color: AppColors.grey400, fontSize: 14),

        // Content Padding
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        // Border Styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200, width: 1),
        ),

        // Error Style
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dropdownColor: AppColors.grey100, // Changed to match TextField
      borderRadius: BorderRadius.circular(12),
    );
  }
}
