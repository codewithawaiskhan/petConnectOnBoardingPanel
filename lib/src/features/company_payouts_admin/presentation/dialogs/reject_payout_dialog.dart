import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../providers/company_payouts_provider.dart';

class RejectPayoutDialog extends StatefulWidget {
  final String payoutId;
  final String? companyName;
  final double amount;
  final String currency;

  const RejectPayoutDialog({
    super.key,
    required this.payoutId,
    this.companyName,
    required this.amount,
    required this.currency,
  });

  @override
  State<RejectPayoutDialog> createState() => _RejectPayoutDialogState();
}

class _RejectPayoutDialogState extends State<RejectPayoutDialog> with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(CompanyPayoutsProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) return;

    final success = await provider.updateStatus(
      widget.payoutId,
      'Failed',
      failedReason: reason,
      context: context,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyPayoutsProvider>(
      builder: (context, provider, _) {
        final isBusy = provider.isUpdating(widget.payoutId);

        return Dialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.cancel_outlined,
                            color: errorColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Reject Company Payout",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Provide the reason for rejecting this withdrawal request.",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Company",
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textSecondaryColor,
                              ),
                              AppText(
                                text: widget.companyName ?? "—",
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppText(
                                text: "Amount",
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textSecondaryColor,
                              ),
                              AppText(
                                text:
                                    "${widget.currency} ${widget.amount.toStringAsFixed(2)}",
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: errorColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      text: "Reason for Rejection *",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _reasonController,
                      hintText:
                          "e.g., Invalid PayPal account, pending verification...",
                      maxLines: 3,
                      radius: 10,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please provide a reason for rejection";
                        }
                        if (val.trim().length < 5) {
                          return "Reason must be at least 5 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          height: 40,
                          width: 100,
                          radius: 8,
                          isOutlined: true,
                          fontSize: 13,
                          onTap: isBusy
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: "Confirm Rejection",
                          height: 40,
                          width: 160,
                          radius: 8,
                          fontSize: 13,
                          fillColor: errorColor,
                          isLoading: isBusy,
                          onTap: isBusy ? null : () => _onSubmit(provider),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

