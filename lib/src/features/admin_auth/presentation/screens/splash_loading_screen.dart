import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';

class SplashLoadingScreen extends StatelessWidget with AppColors {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 72),
            const SizedBox(height: 20),
            AppText(
              text: "PetConnect Portal",
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 8),
            AppText(
              text: "Verifying secure session...",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textSecondaryColor,
            ),
            const SizedBox(height: 24),
            SpinKitThreeBounce(color: primaryColor, size: 24.0),
          ],
        ),
      ),
    );
  }
}
