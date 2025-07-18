import 'package:cartify/app/core/constants/app_constants.dart';
import 'package:cartify/app/core/constants/app_images.dart';
import 'package:cartify/app/core/constants/app_padding.dart';
import 'package:cartify/app/core/constants/app_strings.dart';
import 'package:cartify/app/core/themes/app_colors.dart';
import 'package:cartify/app/core/themes/app_text_styles.dart';
import 'package:cartify/app/core/widgets/app_spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'widgets/login_form.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Image.asset(
                    AppImages.loginBg,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Bottom form container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: AppPaddings.horizontalSmall,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppBorderRadius.primaryBorder,
                  ),
                  padding: AppPaddings.large,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSpacers.smallHeight,
                      Text(
                        AppStrings.loginWelcome,
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                      AppSpacers.smallHeight,
                      Text(
                        AppStrings.loginHelperTitle,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      AppSpacers.largeHeight,
                      LoginForm(),
                      AppSpacers.smallHeight,
                      Text(
                        AppStrings.loginTermsPolicy,
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                      AppSpacers.smallHeight,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
