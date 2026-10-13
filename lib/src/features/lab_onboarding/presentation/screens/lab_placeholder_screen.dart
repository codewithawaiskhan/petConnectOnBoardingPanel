import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';

class LabPlaceholderScreen extends StatelessWidget with AppColors {
  const LabPlaceholderScreen({super.key});

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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tertiaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.biotech_rounded,
                  color: tertiaryColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                text: "Diagnostic Lab Onboarding",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text:
                    "Head office registration, laboratory branch management, and test catalog onboarding module.",
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
