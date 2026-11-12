import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../domain/entities/commission_settings_entity.dart';
import '../providers/commission_settings_provider.dart';

class CreateGlobalSettingsDialog extends StatefulWidget {
  final RenewalCommissionSettingsEntity? currentSettings;

  const CreateGlobalSettingsDialog({super.key, this.currentSettings});

  static Future<bool?> show(
    BuildContext context, {
    RenewalCommissionSettingsEntity? currentSettings,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          CreateGlobalSettingsDialog(currentSettings: currentSettings),
    );
  }

  @override
  State<CreateGlobalSettingsDialog> createState() =>
      _CreateGlobalSettingsDialogState();
}

class _CreateGlobalSettingsDialogState extends State<CreateGlobalSettingsDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _isReferralFirstEnabled;
  late bool _isReferralRenewalEnabled;
  late bool _isCommissionFirstEnabled;
  late bool _isCommissionRenewalEnabled;

  late final TextEditingController _firstRewardAmountController;
  late final TextEditingController _firstRewardCurrencyController;
  late final TextEditingController _renewalRewardAmountController;
  late final TextEditingController _renewalRewardCurrencyController;
  late final TextEditingController _firstCommissionRateController;
  late final TextEditingController _renewalCommissionRateController;

  DateTime _effectiveFrom = DateTime.now();

  @override
  void initState() {
    super.initState();
    final s = widget.currentSettings;
    _isReferralFirstEnabled = s?.isReferralRewardOnFirstPurchaseEnabled ?? true;
    _isReferralRenewalEnabled = s?.isReferralRewardOnRenewalEnabled ?? false;
    _isCommissionFirstEnabled = s?.isCommissionOnFirstPurchaseEnabled ?? true;
    _isCommissionRenewalEnabled = s?.isCommissionOnRenewalEnabled ?? true;

    _firstRewardAmountController = TextEditingController(
      text: s?.referralRewardOnFirstPurchase?.amount?.toString() ?? '0.10',
    );
    _firstRewardCurrencyController = TextEditingController(
      text: s?.referralRewardOnFirstPurchase?.currencyCode ?? 'USD',
    );
    _renewalRewardAmountController = TextEditingController(
      text: s?.referralRewardOnRenewal?.amount?.toString() ?? '',
    );
    _renewalRewardCurrencyController = TextEditingController(
      text: s?.referralRewardOnRenewal?.currencyCode ?? 'USD',
    );
    _firstCommissionRateController = TextEditingController(
      text: s?.commissionRateOnFirstPurchase.toString() ?? '15',
    );
    _renewalCommissionRateController = TextEditingController(
      text: s?.commissionRateOnRenewal.toString() ?? '15',
    );
  }

  @override
  void dispose() {
    _firstRewardAmountController.dispose();
    _firstRewardCurrencyController.dispose();
    _renewalRewardAmountController.dispose();
    _renewalRewardCurrencyController.dispose();
    _firstCommissionRateController.dispose();
    _renewalCommissionRateController.dispose();
    super.dispose();
  }

  Future<void> _pickEffectiveDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _effectiveFrom.isBefore(today) ? today : _effectiveFrom;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_effectiveFrom),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;
    setState(() {
      _effectiveFrom = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? _effectiveFrom.hour,
        pickedTime?.minute ?? _effectiveFrom.minute,
      );
    });
  }

  Future<void> _onSubmit(CommissionSettingsProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final firstRewardAmount = _firstRewardAmountController.text.trim();
    final firstRewardCurrency =
        _firstRewardCurrencyController.text.trim().toUpperCase();
    final renewalRewardAmount = _renewalRewardAmountController.text.trim();
    final renewalRewardCurrency =
        _renewalRewardCurrencyController.text.trim().toUpperCase();

    final firstCommRate =
        num.tryParse(_firstCommissionRateController.text.trim()) ?? 0;
    final renewalCommRate =
        num.tryParse(_renewalCommissionRateController.text.trim()) ?? 0;

    final payload = <String, dynamic>{
      'isReferralRewardOnFirstPurchaseEnabled': _isReferralFirstEnabled,
      'isReferralRewardOnRenewalEnabled': _isReferralRenewalEnabled,
      'referralRewardOnFirstPurchase': _isReferralFirstEnabled
          ? {
              'amount': firstRewardAmount.isNotEmpty ? firstRewardAmount : null,
              'currencyCode': firstRewardCurrency.isNotEmpty
                  ? firstRewardCurrency
                  : 'USD',
            }
          : {'amount': null, 'currencyCode': null},
      'referralRewardOnRenewal': _isReferralRenewalEnabled
          ? {
              'amount':
                  renewalRewardAmount.isNotEmpty ? renewalRewardAmount : null,
              'currencyCode': renewalRewardCurrency.isNotEmpty
                  ? renewalRewardCurrency
                  : 'USD',
            }
          : {'amount': null, 'currencyCode': null},
      'isCommissionOnFirstPurchaseEnabled': _isCommissionFirstEnabled,
      'isCommissionOnRenewalEnabled': _isCommissionRenewalEnabled,
      'commissionRateOnFirstPurchase': firstCommRate,
      'commissionRateOnRenewal': renewalCommRate,
      'effectiveFrom': _effectiveFrom.toUtc().toIso8601String(),
    };

    final success = await provider.createGlobalSettings(payload, context);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppText(
        text: title,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommissionSettingsProvider>(
      builder: (context, provider, _) {
        final isSubmitting = provider.isSubmitting;
        final formattedEffective = DateFormat(
          'MMM dd, yyyy • hh:mm a',
        ).format(_effectiveFrom);

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
              maxWidth: 620,
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
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
                              text: "Create Global Settings Version",
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text:
                                  "Configure default referral rewards and commission rates",
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                        icon: Icon(
                          Icons.close_rounded,
                          color: textSecondaryColor,
                          size: 20,
                        ),
                        tooltip: "Close",
                      ),
                    ],
                  ),
                ),
                Divider(color: borderColor, height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Referral Rewards (Influencers)"),
                          _buildSwitchRow(
                            label: "Reward on First Purchase",
                            value: _isReferralFirstEnabled,
                            onChanged: isSubmitting
                                ? null
                                : (val) => setState(
                                    () => _isReferralFirstEnabled = val,
                                  ),
                          ),
                          if (_isReferralFirstEnabled) ...[
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomTextField(
                                    controller: _firstRewardAmountController,
                                    hintText: "Enter reward amount",
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                    radius: 10,
                                    isEnable: !isSubmitting,
                                    validator: (val) {
                                      if (_isReferralFirstEnabled &&
                                          (val == null || val.trim().isEmpty)) {
                                        return "Amount required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _firstRewardCurrencyController,
                                    hintText: "Enter currency code",
                                    maxLength: 5,
                                    radius: 10,
                                    isEnable: !isSubmitting,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          _buildSwitchRow(
                            label: "Reward on Renewal",
                            value: _isReferralRenewalEnabled,
                            onChanged: isSubmitting
                                ? null
                                : (val) => setState(
                                    () => _isReferralRenewalEnabled = val,
                                  ),
                          ),
                          if (_isReferralRenewalEnabled) ...[
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomTextField(
                                    controller: _renewalRewardAmountController,
                                    hintText: "Enter reward amount",
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                    radius: 10,
                                    isEnable: !isSubmitting,
                                    validator: (val) {
                                      if (_isReferralRenewalEnabled &&
                                          (val == null || val.trim().isEmpty)) {
                                        return "Amount required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller:
                                        _renewalRewardCurrencyController,
                                    hintText: "Enter currency code",
                                    maxLength: 5,
                                    radius: 10,
                                    isEnable: !isSubmitting,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          _buildSectionTitle("Marketing Company Commission (%)"),
                          _buildSwitchRow(
                            label: "Commission on First Purchase",
                            value: _isCommissionFirstEnabled,
                            onChanged: isSubmitting
                                ? null
                                : (val) => setState(
                                    () => _isCommissionFirstEnabled = val,
                                  ),
                          ),
                          if (_isCommissionFirstEnabled) ...[
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _firstCommissionRateController,
                              hintText: "Enter first purchase rate (%)",
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              radius: 10,
                              isEnable: !isSubmitting,
                              validator: (val) {
                                if (_isCommissionFirstEnabled &&
                                    (val == null || val.trim().isEmpty)) {
                                  return "Rate is required";
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 12),
                          _buildSwitchRow(
                            label: "Commission on Renewal",
                            value: _isCommissionRenewalEnabled,
                            onChanged: isSubmitting
                                ? null
                                : (val) => setState(
                                    () => _isCommissionRenewalEnabled = val,
                                  ),
                          ),
                          if (_isCommissionRenewalEnabled) ...[
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _renewalCommissionRateController,
                              hintText: "Enter renewal rate (%)",
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              radius: 10,
                              isEnable: !isSubmitting,
                              validator: (val) {
                                if (_isCommissionRenewalEnabled &&
                                    (val == null || val.trim().isEmpty)) {
                                  return "Rate is required";
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 20),
                          _buildSectionTitle("Effective From *"),
                          InkWell(
                            onTap: isSubmitting ? null : _pickEffectiveDate,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: AppText(
                                      text: formattedEffective,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimaryColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit_calendar_outlined,
                                    size: 18,
                                    color: textSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: borderColor, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "Cancel",
                        height: 42,
                        width: 110,
                        radius: 8,
                        isOutlined: true,
                        fontSize: 13,
                        onTap: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: "Save Version",
                        height: 42,
                        width: 140,
                        radius: 8,
                        fontSize: 13,
                        isLoading: isSubmitting,
                        onTap: isSubmitting ? null : () => _onSubmit(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

