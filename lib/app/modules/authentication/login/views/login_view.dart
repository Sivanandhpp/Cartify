// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
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
              top: 20,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Image.asset(
                    AppImages.loginBackground,
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
                padding: AppSpacing.paddingHorizontal,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppSpacing.radiusXlarge,
                  ),
                  padding: AppSpacing.paddingLarge,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSpacing.spaceMedium,
                      Text(
                        AppStrings.loginWelcome,
                        style: AppTextStyles.titleLarge(
                          AppColors.lightOnBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.spaceMedium,
                      Text(
                        AppStrings.loginHelperTitle,
                        style: AppTextStyles.bodyMedium(
                          AppColors.lightOnBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.spaceLarge,
                      const LoginForm(),
                      AppSpacing.spaceMedium,
                      Text(
                        AppStrings.loginTermsPolicy,
                        style: AppTextStyles.caption(AppColors.lightOnSurface),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.spaceMedium,
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
