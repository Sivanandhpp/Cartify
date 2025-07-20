import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/index.dart';

class OtpDigitField extends StatelessWidget {
  const OtpDigitField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.keyboardNode,
    required this.isFilled,
    required this.onChanged,
    required this.onBackspace,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode keyboardNode;
  final bool isFilled;
  final bool autoFocus;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: keyboardNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          onBackspace();
        }
      },
      child: Container(
        width: 65,
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          showCursor: false,
          autofocus: autoFocus,
          enableInteractiveSelection: false,
          maxLength: 1,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: isFilled ? AppColors.primary : Colors.white,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.radiusSmall,
              borderSide: BorderSide(
                color: isFilled ? AppColors.primary : const Color(0xFFFFFFFF),
              ),
            ),
          ),
          style: AppTextStyles.titleLarge(AppColors.lightBackground),
          onChanged: onChanged,
          validator: (value) => (value?.isEmpty ?? true) ? '' : null,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }
}




