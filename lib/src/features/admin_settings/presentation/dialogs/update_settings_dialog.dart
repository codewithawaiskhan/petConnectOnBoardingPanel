import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../data/models/settings_model.dart';
import '../providers/admin_settings_provider.dart';

class UpdateSettingsDialog extends StatefulWidget {
  final SettingsModel? currentSettings;

  const UpdateSettingsDialog({super.key, this.currentSettings});

  static Future<bool?> show(
    BuildContext context, {
    SettingsModel? currentSettings,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateSettingsDialog(currentSettings: currentSettings),
    );
  }

  @override
  State<UpdateSettingsDialog> createState() => _UpdateSettingsDialogState();
}

class _UpdateSettingsDialogState extends State<UpdateSettingsDialog>
    with AppColors {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _payoutThresholdController;
  late final TextEditingController _minRedeemableController;
  late bool _isReferralEnabled;

  @override
  void initState() {
    super.initState();
    final settings = widget.currentSettings;
    _isReferralEnabled = settings?.isReferralSystemEnabled ?? true;
    _payoutThresholdController = TextEditingController(
      text: settings?.payoutThreshold.amount.toString() ?? "20.00",
    );
    _minRedeemableController = TextEditingController(
      text: settings?.minimumRedeemable.amount.toString() ?? "10.00",
    );
  }

  @override
  void dispose() {
    _payoutThresholdController.dispose();
    _minRedeemableController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(AdminSettingsProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final payoutAmount =
        double.tryParse(_payoutThresholdController.text.trim()) ?? 0.0;
    final minRedeemAmount =
        double.tryParse(_minRedeemableController.text.trim()) ?? 0.0;

    final success = await provider.updateSettings(
      isReferralEnabled: _isReferralEnabled,
      payoutAmount: payoutAmount,
      minRedeemAmount: minRedeemAmount,
      context: context,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminSettingsProvider>(
      builder: (context, provider, _) {
        final isBusy = provider.isSaving;

        return Dialog(
          backgroundColor: whiteColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Update Global Settings",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text:
                                    "Configure system-wide referral activation and payout threshold rules.",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: isBusy ? null : () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),

                    // Referral Switch Tile
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.group_work_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "Enable Referral System",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                ),
                                const SizedBox(height: 2),
                                AppText(
                                  text: _isReferralEnabled
                                      ? "Referral tracking & commissions are active"
                                      : "Referral commissions are paused platform-wide",
                                  fontSize: 11,
                                  color: textSecondaryColor,
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _isReferralEnabled,
                            activeTrackColor: primaryColor.withValues(alpha: 0.4),
                            activeThumbColor: primaryColor,
                            onChanged: isBusy
                                ? null
                                : (val) {
                                    setState(() {
                                      _isReferralEnabled = val;
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Payout Threshold Field
                    AppText(
                      text: "Payout Threshold (USD)",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _payoutThresholdController,
                      hintText: "e.g., 20.00",
                      isEnable: !isBusy,
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      radius: 8,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Payout threshold is required";
                        }
                        final parsed = double.tryParse(val.trim());
                        if (parsed == null || parsed < 0) {
                          return "Enter a valid amount";
                        }
                        return null;
                      },
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppText(
                          text: "\$",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textSecondaryColor,
                        ),
                      ),
                      isIcon: true,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text:
                          "Minimum required balance for influencers/companies before submitting a withdrawal.",
                      fontSize: 11,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 16),

                    // Minimum Redeemable Field
                    AppText(
                      text: "Minimum Redeemable (USD)",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _minRedeemableController,
                      hintText: "e.g., 10.00",
                      isEnable: !isBusy,
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      radius: 8,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Minimum redeemable amount is required";
                        }
                        final parsed = double.tryParse(val.trim());
                        if (parsed == null || parsed < 0) {
                          return "Enter a valid amount";
                        }
                        return null;
                      },
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppText(
                          text: "\$",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textSecondaryColor,
                        ),
                      ),
                      isIcon: true,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text:
                          "Minimum allowed amount for a single payout transaction.",
                      fontSize: 11,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 24),

                    // Dialog Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          isOutlined: true,
                          height: 38,
                          radius: 8,
                          onTap: isBusy ? null : () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: "Save Changes",
                          height: 38,
                          radius: 8,
                          isLoading: isBusy,
                          onTap: isBusy ? null : () => _handleSave(provider),
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
