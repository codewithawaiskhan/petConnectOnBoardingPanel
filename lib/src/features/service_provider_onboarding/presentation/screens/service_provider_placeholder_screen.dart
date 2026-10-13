import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';

class ServiceProviderPlaceholderScreen extends StatelessWidget with AppColors {
  const ServiceProviderPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 48),
              const SizedBox(height: 20),
              AppText(
                text: "Service Provider Onboarding",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text:
                    "Grooming, training, boarding, and nursing service provider onboarding module is ready for feature development.",
                fontSize: 14,
                color: textSecondaryColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
