import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../marketing_companies/presentation/providers/marketing_company_list_provider.dart';
import '../providers/commission_settings_provider.dart';

class CreateCompanyPolicyDialog extends StatefulWidget {
  final String? initialCompanyId;

  const CreateCompanyPolicyDialog({super.key, this.initialCompanyId});

  static Future<bool?> show(
    BuildContext context, {
    String? initialCompanyId,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          CreateCompanyPolicyDialog(initialCompanyId: initialCompanyId),
    );
  }

  @override
  State<CreateCompanyPolicyDialog> createState() =>
      _CreateCompanyPolicyDialogState();
}

class _CreateCompanyPolicyDialogState extends State<CreateCompanyPolicyDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCompanyId;
  bool _isCommissionFirstEnabled = true;
  bool _isCommissionRenewalEnabled = true;

  final TextEditingController _firstRateController = TextEditingController(
    text: '15',
  );
  final TextEditingController _renewalRateController = TextEditingController(
    text: '15',
  );

  DateTime _effectiveFrom = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCompanyId = widget.initialCompanyId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companiesProvider = context.read<MarketingCompanyListProvider>();
      if (companiesProvider.companies.isEmpty) {
        companiesProvider.fetchCompanies(isRefresh: true);
      }
    });
  }

  @override
  void dispose() {
    _firstRateController.dispose();
    _renewalRateController.dispose();
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
    if (_selectedCompanyId == null || _selectedCompanyId!.isEmpty) return;

    final firstRate = num.tryParse(_firstRateController.text.trim()) ?? 0;
    final renewalRate = num.tryParse(_renewalRateController.text.trim()) ?? 0;

    final payload = <String, dynamic>{
      'company': _selectedCompanyId!,
      'isCommissionOnFirstPurchaseEnabled': _isCommissionFirstEnabled,
      'isCommissionOnRenewalEnabled': _isCommissionRenewalEnabled,
      'commissionRateOnFirstPurchase': firstRate,
      'commissionRateOnRenewal': renewalRate,
      'effectiveFrom': _effectiveFrom.toUtc().toIso8601String(),
    };

    final success = await provider.createCompanyPolicy(payload, context);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
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
    final companiesProvider = context.watch<MarketingCompanyListProvider>();
    final companies = companiesProvider.companies;

    return Consumer<CommissionSettingsProvider>(
      builder: (context, provider, _) {
        final isSubmitting = provider.isSubmitting;
        final formattedEffective = DateFormat(
          'MMM dd, yyyy • hh:mm a',
        ).format(_effectiveFrom);

        final effectiveSelectedId =
            (_selectedCompanyId != null &&
                    companies.any((c) => c.id == _selectedCompanyId))
                ? _selectedCompanyId
                : null;

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
              maxWidth: 500,
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
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
                            Icons.percent_rounded,
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
                                text: "Assign Company Policy",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Override commission rates for a marketing company",
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
                    const SizedBox(height: 20),
                    Divider(color: borderColor, height: 1),
                    const SizedBox(height: 20),
                    AppText(
                      text: "Marketing Company *",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      value: effectiveSelectedId,
                      hint: AppText(
                        text: companiesProvider.isLoading
                            ? "Loading companies..."
                            : "Select marketing company",
                        fontSize: 13,
                        color: textSecondaryColor,
                      ),
                      items: companies.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.id,
                          child: AppText(
                            text: c.longAutoIncrementId.isNotEmpty
                                ? "${c.displayName} (${c.longAutoIncrementId})"
                                : c.displayName,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: isSubmitting
                          ? null
                          : (val) => setState(() => _selectedCompanyId = val),
                      validator: (val) => (val == null || val.isEmpty)
                          ? "Please select a marketing company"
                          : null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 260,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSwitchRow(
                      label: "Commission on First Purchase",
                      value: _isCommissionFirstEnabled,
                      onChanged: isSubmitting
                          ? null
                          : (val) =>
                              setState(() => _isCommissionFirstEnabled = val),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _firstRateController,
                      hintText: "Enter first purchase rate (%)",
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      radius: 10,
                      isEnable: !isSubmitting && _isCommissionFirstEnabled,
                      validator: (val) {
                        if (_isCommissionFirstEnabled &&
                            (val == null || val.trim().isEmpty)) {
                          return "Rate is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildSwitchRow(
                      label: "Commission on Renewal",
                      value: _isCommissionRenewalEnabled,
                      onChanged: isSubmitting
                          ? null
                          : (val) =>
                              setState(() => _isCommissionRenewalEnabled = val),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _renewalRateController,
                      hintText: "Enter renewal rate (%)",
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      radius: 10,
                      isEnable: !isSubmitting && _isCommissionRenewalEnabled,
                      validator: (val) {
                        if (_isCommissionRenewalEnabled &&
                            (val == null || val.trim().isEmpty)) {
                          return "Rate is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      text: "Effective From *",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: isSubmitting ? null : _pickEffectiveDate,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
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
                          onTap: isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: "Assign Policy",
                          height: 42,
                          width: 140,
                          radius: 8,
                          fontSize: 13,
                          isLoading: isSubmitting,
                          onTap:
                              isSubmitting ? null : () => _onSubmit(provider),
                        ),
                      ],
                    ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

