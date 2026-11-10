import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../providers/withdrawal_list_provider.dart';

class UpdateWithdrawalStatusDialog extends StatefulWidget {
  final String id;
  final String currentStatus;
  final String? initialFailedReason;

  const UpdateWithdrawalStatusDialog({
    super.key,
    required this.id,
    required this.currentStatus,
    this.initialFailedReason,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String id,
    required String currentStatus,
    String? initialFailedReason,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateWithdrawalStatusDialog(
        id: id,
        currentStatus: currentStatus,
        initialFailedReason: initialFailedReason,
      ),
    );
  }

  @override
  State<UpdateWithdrawalStatusDialog> createState() =>
      _UpdateWithdrawalStatusDialogState();
}

class _UpdateWithdrawalStatusDialogState
    extends State<UpdateWithdrawalStatusDialog>
    with AppColors {
  static const List<String> _allowedStatuses = [
    'Submitted',
    'In Review',
    'Approved',
    'Processing',
    'Paid',
    'Failed',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _failedReasonController;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _failedReasonController = TextEditingController(
      text: widget.initialFailedReason ?? '',
    );

    final matchedStatus = _allowedStatuses.where(
      (s) => s.toLowerCase() == widget.currentStatus.trim().toLowerCase(),
    );
    _selectedStatus = matchedStatus.isNotEmpty
        ? matchedStatus.first
        : _allowedStatuses.first;
  }

  @override
  void dispose() {
    _failedReasonController.dispose();
    super.dispose();
  }

  Future<void> _onUpdateTap(WithdrawalListProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedStatus == null) return;

    final success = await provider.updateWithdrawalStatus(
      context,
      id: widget.id,
      status: _selectedStatus!,
      failedReason: _selectedStatus == 'Failed'
          ? _failedReasonController.text.trim()
          : null,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WithdrawalListProvider>(
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
            constraints: const BoxConstraints(maxWidth: 460),
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
                            Icons.edit_note_rounded,
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
                                text: "Update Withdrawal Status",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: "Select the new status for this request",
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
                    AppText(
                      text: "Status *",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: _selectedStatus,
                        hint: AppText(
                          text: "Select status",
                          fontSize: 13,
                          color: textSecondaryColor,
                        ),
                        items: _allowedStatuses.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Row(
                              children: [
                                StatusBadge(
                                  status: status,
                                  showDot: true,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: isUpdating
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedStatus = value;
                                });
                              },
                        buttonStyleData: ButtonStyleData(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 280,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: textSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedStatus == 'Failed') ...[
                      const SizedBox(height: 16),
                      AppText(
                        text: "Failed Reason *",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _failedReasonController,
                        hintText: "Enter reason for failure...",
                        maxLines: 3,
                        radius: 10,
                        isEnable: !isUpdating,
                        validator: (value) {
                          if (_selectedStatus == 'Failed' &&
                              (value == null || value.trim().isEmpty)) {
                            return "Failed reason is required when status is Failed";
                          }
                          return null;
                        },
                      ),
                    ],
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
                          onTap: isUpdating
                              ? null
                              : () => _onUpdateTap(provider),
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

