import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../providers/pet_parent_detail_provider.dart';

class UpdatePasswordDialog extends StatefulWidget {
  final String petParentId;
  final String? petParentName;

  const UpdatePasswordDialog({
    super.key,
    required this.petParentId,
    this.petParentName,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String petParentId,
    String? petParentName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdatePasswordDialog(
        petParentId: petParentId,
        petParentName: petParentName,
      ),
    );
  }

  @override
  State<UpdatePasswordDialog> createState() => _UpdatePasswordDialogState();
}

class _UpdatePasswordDialogState extends State<UpdatePasswordDialog>
    with AppColors {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<PetParentDetailProvider>();
    final success = await provider.updatePassword(
      context: context,
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      petParentId: widget.petParentId,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = context.watch<PetParentDetailProvider>().isUpdatingPassword;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(
                    bottom: BorderSide(
                      color: primaryColor.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Update Password',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          if (widget.petParentName != null &&
                              widget.petParentName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            AppText(
                              text: 'For ${widget.petParentName}',
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: isUpdating ? null : () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        foregroundColor: textSecondaryColor,
                        hoverColor: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                  ],
                ),
              ),

              // Form body with scrolling
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _passwordController,
                          title: 'New Password',
                          hintText: 'Enter new password',
                          isObSecure: true,
                          hasBorder: true,
                          enableBorderColor: borderColor,
                          focusBorderColor: primaryColor,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: textSecondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          title: 'Confirm Password',
                          hintText: 'Re-enter new password',
                          isObSecure: true,
                          hasBorder: true,
                          enableBorderColor: borderColor,
                          focusBorderColor: primaryColor,
                          prefixIcon: Icon(
                            Icons.lock_clock_outlined,
                            size: 18,
                            color: textSecondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please confirm the password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.02),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 340;

                    return Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        TextButton(
                          onPressed: isUpdating ? null : () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: AppText(
                            text: 'Cancel',
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomButton(
                          text: 'Update Password',
                          isLoading: isUpdating,
                          width: isNarrow ? double.infinity : 170,
                          onTap: isUpdating ? null : _handleSubmit,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
