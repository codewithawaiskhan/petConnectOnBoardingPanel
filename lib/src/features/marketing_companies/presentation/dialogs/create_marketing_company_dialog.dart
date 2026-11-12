import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_country_picker_field.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../providers/marketing_company_list_provider.dart';

class CreateMarketingCompanyDialog extends StatefulWidget {
  const CreateMarketingCompanyDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CreateMarketingCompanyDialog(),
    );
  }

  @override
  State<CreateMarketingCompanyDialog> createState() =>
      _CreateMarketingCompanyDialogState();
}

class _CreateMarketingCompanyDialogState
    extends State<CreateMarketingCompanyDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _revenueShareController = TextEditingController();

  String? _selectedCountryCode;
  String? _selectedCountryName;

  @override
  void dispose() {
    _displayNameController.dispose();
    _legalNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _revenueShareController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(MarketingCompanyListProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final payload = <String, dynamic>{
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'displayName': _displayNameController.text.trim(),
      'legalName': _legalNameController.text.trim(),
    };

    final address = _addressController.text.trim();
    if (address.isNotEmpty) payload['address'] = address;

    if (_selectedCountryCode != null &&
        _selectedCountryCode!.trim().isNotEmpty) {
      payload['countryCode'] = _selectedCountryCode!.trim().toUpperCase();
    }

    if (_selectedCountryName != null &&
        _selectedCountryName!.trim().isNotEmpty) {
      payload['countryName'] = _selectedCountryName!.trim();
    }

    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) payload['phone'] = phone;

    final revenueShareText = _revenueShareController.text.trim();
    if (revenueShareText.isNotEmpty) {
      final parsed = num.tryParse(revenueShareText);
      if (parsed != null) {
        payload['revenueShare'] = parsed;
      }
    }

    final success = await provider.createCompany(payload, context);
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
        final isSubmitting = provider.isUpdating;

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
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
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
                          Icons.business_rounded,
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
                              text: "Add Marketing Company",
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text: "Create a new marketing partner account",
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 480;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Display Name *"),
                                          CustomTextField(
                                            controller: _displayNameController,
                                            hintText: "Enter display name",
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                            validator: (val) =>
                                                (val == null ||
                                                        val.trim().isEmpty)
                                                    ? "Display name is required"
                                                    : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Legal Name *"),
                                          CustomTextField(
                                            controller: _legalNameController,
                                            hintText:
                                                "Enter legal name",
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                            validator: (val) =>
                                                (val == null ||
                                                        val.trim().isEmpty)
                                                    ? "Legal name is required"
                                                    : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _buildLabel("Display Name *"),
                                CustomTextField(
                                  controller: _displayNameController,
                                  hintText: "Enter display name",
                                  radius: 10,
                                  isEnable: !isSubmitting,
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                          ? "Display name is required"
                                          : null,
                                ),
                                const SizedBox(height: 14),
                                _buildLabel("Legal Name *"),
                                CustomTextField(
                                  controller: _legalNameController,
                                  hintText: "Enter legal name",
                                  radius: 10,
                                  isEnable: !isSubmitting,
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                          ? "Legal name is required"
                                          : null,
                                ),
                              ],
                              const SizedBox(height: 14),
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Owner Email *"),
                                          CustomTextField(
                                            controller: _emailController,
                                            hintText:
                                                "Enter owner email",
                                            textInputType:
                                                TextInputType.emailAddress,
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                            validator: (val) {
                                              if (val == null ||
                                                  val.trim().isEmpty) {
                                                return "Email is required";
                                              }
                                              if (!val.contains('@')) {
                                                return "Enter a valid email";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Password *"),
                                          CustomTextField(
                                            controller: _passwordController,
                                            hintText: "Enter password",
                                            isObSecure: true,
                                            maxLines: 1,
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                            validator: (val) {
                                              if (val == null ||
                                                  val.trim().isEmpty) {
                                                return "Password is required";
                                              }
                                              if (val.trim().length < 6) {
                                                return "Min 6 characters";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _buildLabel("Owner Email *"),
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Enter owner email",
                                  textInputType: TextInputType.emailAddress,
                                  radius: 10,
                                  isEnable: !isSubmitting,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Email is required";
                                    }
                                    if (!val.contains('@')) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                _buildLabel("Password *"),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: "Enter password",
                                  isObSecure: true,
                                  maxLines: 1,
                                  radius: 10,
                                  isEnable: !isSubmitting,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Password is required";
                                    }
                                    if (val.trim().length < 6) {
                                      return "Min 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 14),
                              _buildLabel("Address"),
                              CustomTextField(
                                controller: _addressController,
                                hintText: "Enter address",
                                radius: 10,
                                isEnable: !isSubmitting,
                              ),
                              const SizedBox(height: 14),
                              _buildLabel("Country"),
                              AppCountryPickerField(
                                hintText: "Select Country",
                                radius: 10,
                                isEnable: !isSubmitting,
                                selectedCountryCode: _selectedCountryCode,
                                selectedCountryName: _selectedCountryName,
                                onCountryChanged: (countryName, countryCode) {
                                  setState(() {
                                    _selectedCountryName = countryName;
                                    _selectedCountryCode = countryCode;
                                  });
                                },
                                onCleared: () {
                                  setState(() {
                                    _selectedCountryName = null;
                                    _selectedCountryCode = null;
                                  });
                                },
                              ),
                              const SizedBox(height: 14),
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Phone"),
                                          CustomTextField(
                                            controller: _phoneController,
                                            hintText: "Enter phone number",
                                            textInputType: TextInputType.phone,
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel("Revenue Share (%)"),
                                          CustomTextField(
                                            controller: _revenueShareController,
                                            hintText: "Enter revenue share (%)",
                                            textInputType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*'),
                                              ),
                                            ],
                                            radius: 10,
                                            isEnable: !isSubmitting,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _buildLabel("Phone"),
                                CustomTextField(
                                  controller: _phoneController,
                                  hintText: "Enter phone number",
                                  textInputType: TextInputType.phone,
                                  radius: 10,
                                  isEnable: !isSubmitting,
                                ),
                                const SizedBox(height: 14),
                                _buildLabel("Revenue Share (%)"),
                                CustomTextField(
                                  controller: _revenueShareController,
                                  hintText: "Enter revenue share (%)",
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
                                ),
                              ],
                            ],
                          );
                        },
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
                        text: "Create Company",
                        height: 42,
                        width: 150,
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

