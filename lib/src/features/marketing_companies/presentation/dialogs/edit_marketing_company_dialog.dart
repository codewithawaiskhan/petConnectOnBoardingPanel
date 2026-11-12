import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../domain/entities/marketing_company_entity.dart';
import '../providers/marketing_company_list_provider.dart';

class EditMarketingCompanyDialog extends StatefulWidget {
  final MarketingCompanyEntity company;

  const EditMarketingCompanyDialog({super.key, required this.company});

  static Future<bool?> show(
    BuildContext context, {
    required MarketingCompanyEntity company,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditMarketingCompanyDialog(company: company),
    );
  }

  @override
  State<EditMarketingCompanyDialog> createState() =>
      _EditMarketingCompanyDialogState();
}

class _EditMarketingCompanyDialogState extends State<EditMarketingCompanyDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;
  late final TextEditingController _legalNameController;
  late final TextEditingController _revenueShareController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.company.displayName,
    );
    _legalNameController = TextEditingController(
      text: widget.company.legalName,
    );
    _revenueShareController = TextEditingController(
      text: widget.company.revenueShare.toString(),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _legalNameController.dispose();
    _revenueShareController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(MarketingCompanyListProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final parsedRevenueShare = num.tryParse(
      _revenueShareController.text.trim(),
    );

    final payload = <String, dynamic>{
      'displayName': _displayNameController.text.trim(),
      'legalName': _legalNameController.text.trim(),
      'revenueShare': ?parsedRevenueShare,
    };

    final success = await provider.updateCompany(
      widget.company.id,
      payload,
      context,
    );
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AppText(
        text: text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketingCompanyListProvider>(
      builder: (context, provider, _) {
        final isUpdating = provider.isUpdating;

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
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
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
                                text: "Edit Marketing Company",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: widget.company.longAutoIncrementId
                                        .isNotEmpty
                                    ? widget.company.longAutoIncrementId
                                    : widget.company.displayName,
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isUpdating
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
                    _buildLabel("Display Name *"),
                    CustomTextField(
                      controller: _displayNameController,
                      hintText: "Enter display name",
                      radius: 10,
                      isEnable: !isUpdating,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? "Display name is required"
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel("Legal Name *"),
                    CustomTextField(
                      controller: _legalNameController,
                      hintText: "Enter legal entity name",
                      radius: 10,
                      isEnable: !isUpdating,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? "Legal name is required"
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel("Revenue Share (%) *"),
                    CustomTextField(
                      controller: _revenueShareController,
                      hintText: "Enter revenue share (%)",
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      radius: 10,
                      isEnable: !isUpdating,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Revenue share is required";
                        }
                        if (num.tryParse(val.trim()) == null) {
                          return "Enter a valid number";
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
                          onTap: isUpdating
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: "Update",
                          height: 42,
                          width: 120,
                          radius: 8,
                          fontSize: 13,
                          isLoading: isUpdating,
                          onTap: isUpdating ? null : () => _onSubmit(provider),
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

