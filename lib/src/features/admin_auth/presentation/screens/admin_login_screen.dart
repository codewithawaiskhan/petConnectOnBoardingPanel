import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../providers/admin_auth_provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> with AppColors {
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final provider = context.read<AdminAuthProvider>();
    provider.loginAdmin(
      identifier: _identifierController.text,
      password: _passwordController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminAuthProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 64)),
                  const SizedBox(height: 20),
                  Center(
                    child: AppText(
                      text: "PetConnect Onboarding Portal",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: AppText(
                      text: "Sign in to access your Onboarding Portal",
                      fontSize: 13,
                      color: textSecondaryColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _identifierController,
                    title: "Email",
                    hintText: "Please enter your email address",
                    isIcon: true,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    controller: _passwordController,
                    title: "Password",
                    hintText: "Enter your secure password",
                    isObSecure: true,
                    isIcon: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 28),

                  CustomButton(
                    text: "Sign In",
                    height: 50,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    isLoading: provider.isLoading,
                    onTap: _handleLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
