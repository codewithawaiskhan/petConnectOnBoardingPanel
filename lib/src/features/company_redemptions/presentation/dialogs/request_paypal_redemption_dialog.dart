import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../company_wallet/presentation/providers/company_wallet_provider.dart';
import '../providers/company_redemptions_provider.dart';

class RequestPayPalRedemptionDialog extends StatefulWidget {
  final double? availableBalance;

  const RequestPayPalRedemptionDialog({super.key, this.availableBalance});

  static Future<bool?> show(
    BuildContext context, {
    double? availableBalance,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          RequestPayPalRedemptionDialog(availableBalance: availableBalance),
    );
  }

  @override
  State<RequestPayPalRedemptionDialog> createState() =>
      _RequestPayPalRedemptionDialogState();
}

class _RequestPayPalRedemptionDialogState
    extends State<RequestPayPalRedemptionDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(CompanyRedemptionsProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    final email = _emailController.text.trim();

    final success = await provider.requestRedemption(amount, email, context);

    if (success && mounted) {
      // Also refresh wallet balance if wallet provider is in context
      try {
        context.read<CompanyWalletProvider>().fetchBalance();
      } catch (_) {}

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyRedemptionsProvider>(
      builder: (context, provider, _) {
        final isBusy = provider.isSubmitting;

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
            constraints: BoxConstraints(
              maxWidth: 460,
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.payments_rounded,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Request PayPal Payout",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Submit a referral commission withdrawal request to your PayPal account.",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.availableBalance != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: successColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 18,
                              color: successColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppText(
                                text:
                                    "Available Balance: \$${widget.availableBalance!.toStringAsFixed(2)} USD",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _amountController,
                      title: "Withdrawal Amount (USD)",
                      hintText: "Enter withdrawal amount",
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money_rounded,
                        color: textSecondaryColor,
                        size: 20,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter withdrawal amount";
                        }
                        final parsed = double.tryParse(val.trim());
                        if (parsed == null || parsed <= 0) {
                          return "Please enter a valid amount greater than 0";
                        }
                        if (widget.availableBalance != null &&
                            parsed > widget.availableBalance!) {
                          return "Amount exceeds available balance (\$${widget.availableBalance!.toStringAsFixed(2)})";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      title: "PayPal Email",
                      hintText: "Enter PayPal email address",
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                        color: textSecondaryColor,
                        size: 20,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter PayPal email address";
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(val.trim())) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          height: 42,
                          width: 110,
                          radius: 8,
                          isOutlined: true,
                          fontSize: 13,
                          onTap: isBusy
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: "Submit Request",
                          height: 42,
                          width: 150,
                          radius: 8,
                          fontSize: 13,
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
