import 'package:bevco/app/core/constants/app_constants.dart';
import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/core/constants/app_padding.dart';
import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:bevco/app/core/themes/app_text_styles.dart';
import 'package:bevco/app/core/widgets/app_spacers.dart';
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
      body: SingleChildScrollView(
        child: Expanded(
          // height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppImages.loginBg, fit: BoxFit.cover),
              AppSpacers.mediumHeight,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppBorderRadius.verticalPrimaryBorder,
                ),
                padding: AppPaddings.large,
                child: Column(
                  children: [
                    AppSpacers.smallHeight,
                    Text(
                      AppStrings.loginWelcome,
                      style: AppTextStyless.title,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacers.smallHeight,
                    Text(
                      AppStrings.loginHelperTitle,
                      style: AppTextStyless.body,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacers.largeHeight,
                    const LoginForm(),
                    AppSpacers.smallHeight,
                    const Text(
                      AppStrings.loginTermsPolicy,
                      style: AppTextStyless.caption,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacers.largeHeight,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
