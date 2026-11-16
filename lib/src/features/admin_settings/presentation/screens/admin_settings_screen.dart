import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../data/models/settings_model.dart';
import '../dialogs/update_settings_dialog.dart';
import '../providers/admin_settings_provider.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminSettingsProvider>().fetchSettings(context);
    });
  }

  Future<void> _openEditDialog(SettingsModel? settings) async {
    final updated = await UpdateSettingsDialog.show(
      context,
      currentSettings: settings,
    );
    if (updated == true && mounted) {
      context.read<AdminSettingsProvider>().fetchSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<AdminSettingsProvider>(
        builder: (context, provider, _) {
          final settings = provider.settings;

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchSettings(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24.0 : 16.0,
                vertical: isDesktop ? 20.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, settings, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.isLoading && settings == null)
                    _buildLoadingSkeleton()
                  else if (provider.errorMessage != null && settings == null)
                    _buildErrorState(provider)
                  else if (settings != null) ...[
                    _buildReferralStatusCard(settings),
                    const SizedBox(height: 20),
                    _buildThresholdMetricsCard(settings, isDesktop),
                    const SizedBox(height: 20),
                    _buildPlatformMetadataCard(settings, isDesktop),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    AdminSettingsProvider provider,
    SettingsModel? settings,
    bool isDesktop,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Global Referral & Payout Settings",
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: "Manage system referral and payout rules.",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: "Refresh",
              isOutlined: true,
              isIcon: true,
              icon: Icon(Icons.refresh_rounded, size: 16, color: primaryColor),
              height: 38,
              radius: 8,
              onTap: provider.isLoading
                  ? null
                  : () => provider.fetchSettings(context),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Edit Settings",
              isIcon: true,
              icon: const Icon(
                Icons.edit_rounded,
                size: 16,
                color: Colors.white,
              ),
              height: 38,
              radius: 8,
              onTap: provider.isLoading
                  ? null
                  : () => _openEditDialog(settings),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReferralStatusCard(SettingsModel settings) {
    final isEnabled = settings.isReferralSystemEnabled;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.info, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Referral Program Status",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: "Enable or disable the referral system platform-wide.",
                  fontSize: 12,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildStatusPill(isEnabled),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool isEnabled) {
    final bg = isEnabled ? lightGreenColor : peachColor.withValues(alpha: 0.6);
    final fg = isEnabled ? successColor : errorColor;
    final dotColor = isEnabled ? successColor : errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          AppText(
            text: isEnabled ? "Active" : "Disabled",
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdMetricsCard(SettingsModel settings, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              AppText(
                text: "Withdrawal & Redemption Thresholds",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            text: "Minimum balance requirements for payout requests.",
            fontSize: 12,
            color: textSecondaryColor,
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoCol = constraints.maxWidth >= 640;

              final payoutCard = _buildMetricBox(
                label: "PAYOUT THRESHOLD",
                amountText:
                    "${settings.payoutThreshold.currencyCode} ${settings.payoutThreshold.amount.toStringAsFixed(2)}",
                subtitle:
                    "Minimum wallet balance required to request a withdrawal.",
                icon: Icons.payments_rounded,
                accentColor: primaryColor,
              );

              final minRedeemCard = _buildMetricBox(
                label: "MINIMUM REDEEMABLE",
                amountText:
                    "${settings.minimumRedeemable.currencyCode} ${settings.minimumRedeemable.amount.toStringAsFixed(2)}",
                subtitle: "Minimum amount allowed per single transaction.",
                icon: Icons.price_check_rounded,
                accentColor: successColor,
              );

              if (isTwoCol) {
                return Row(
                  children: [
                    Expanded(child: payoutCard),
                    const SizedBox(width: 16),
                    Expanded(child: minRedeemCard),
                  ],
                );
              }

              return Column(
                children: [
                  payoutCard,
                  const SizedBox(height: 16),
                  minRedeemCard,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox({
    required String label,
    required String amountText,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: label,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: textSecondaryColor,
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppText(
            text: amountText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: subtitle,
            fontSize: 12,
            color: textSecondaryColor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformMetadataCard(SettingsModel settings, bool isDesktop) {
    final metaItems = <_MetaTileData>[
      if (settings.adminProfit != null)
        _MetaTileData(
          icon: Icons.trending_up_rounded,
          label: "ADMIN PROFIT",
          value: "${settings.adminProfit}%",
          accentColor: primaryColor,
        ),
      if (settings.platformFee != null)
        _MetaTileData(
          icon: Icons.pie_chart_outline_rounded,
          label: "PLATFORM FEE",
          value: "${settings.platformFee}%",
          accentColor: yellowColor,
        ),
      if (settings.vat != null)
        _MetaTileData(
          icon: Icons.receipt_long_rounded,
          label: "VAT RATE",
          value: "${settings.vat}%",
          accentColor: textSecondaryColor,
        ),
      if (settings.contactEmail != null && settings.contactEmail!.isNotEmpty)
        _MetaTileData(
          icon: Icons.email_outlined,
          label: "CONTACT EMAIL",
          value: settings.contactEmail!,
          accentColor: primaryColor,
        ),
      if (settings.whatsAppPhone != null && settings.whatsAppPhone!.isNotEmpty)
        _MetaTileData(
          icon: Icons.phone_outlined,
          label: "WHATSAPP PHONE",
          value: settings.whatsAppPhone!,
          accentColor: successColor,
        ),
    ];

    if (metaItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              AppText(
                text: "Platform Fee & Contact Configuration",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            text:
                "Standard administrative margins, statutory deductions, and communication channels.",
            fontSize: 12,
            color: textSecondaryColor,
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: metaItems.map((item) {
                  final double tileWidth = constraints.maxWidth >= 780
                      ? (constraints.maxWidth - (14 * 2)) / 3
                      : (constraints.maxWidth >= 500
                            ? (constraints.maxWidth - 14) / 2
                            : constraints.maxWidth);

                  return SizedBox(
                    width: tileWidth,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: backgroundColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: item.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item.icon,
                              size: 18,
                              color: item.accentColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: item.label,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondaryColor,
                                ),
                                const SizedBox(height: 2),
                                AppText(
                                  text: item.value,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          AppText(
            text: "Loading global settings...",
            fontSize: 13,
            color: textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AdminSettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: errorColor, size: 36),
          const SizedBox(height: 10),
          AppText(
            text: provider.errorMessage ?? "Failed to load global settings",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 14),
          CustomButton(
            text: "Retry",
            height: 36,
            radius: 6,
            onTap: () => provider.fetchSettings(context),
          ),
        ],
      ),
    );
  }
}

class _MetaTileData {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _MetaTileData({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });
}
