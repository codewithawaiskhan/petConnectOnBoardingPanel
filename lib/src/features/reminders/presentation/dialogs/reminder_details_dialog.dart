import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/show_image.dart';
import '../../domain/entities/reminder_entity.dart';

class ReminderDetailsDialog extends StatelessWidget with AppColors {
  final ReminderEntity reminder;

  const ReminderDetailsDialog({super.key, required this.reminder});

  String? _getPetImageUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return "${ApiEndpoints.storageBaseUrl}/$raw";
  }

  String _formatDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMMM d, yyyy • hh:mm a').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  String _formatChipText(String text) {
    if (text.isEmpty) return "";
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? "${w[0].toUpperCase()}${w.substring(1)}" : "")
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final petImageUrl = _getPetImageUrl(reminder.petImage);
    final statusColor = reminder.isActive ? successColor : textSecondaryColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 540,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ShowImage().buildImage(
                      image: petImageUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: reminder.petName,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: "Reminder Details",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        AppText(
                          text: reminder.isActive ? "Active" : "Inactive",
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textSecondaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: "Close",
                  ),
                ],
              ),
            ),

            // Modal Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  AppText(
                    text: reminder.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  if (reminder.description != null &&
                      reminder.description!.trim().isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: AppText(
                        text: reminder.description!.trim(),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Details Table
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Routine",
                            _formatChipText(reminder.routine ?? "One Time")),
                        _buildDetailRow("Type",
                            _formatChipText(reminder.reminderType ?? "General")),
                        _buildDetailRow("Reminder Time",
                            _formatDateTime(reminder.reminderDateTime)),
                        if (reminder.alerts.isNotEmpty)
                          _buildDetailRow(
                            "Alerts",
                            reminder.alerts
                                .map((a) => _formatChipText(a))
                                .join(", "),
                          ),
                        _buildDetailRow("Status",
                            reminder.isActive ? "Active" : "Inactive"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: "Close",
                    fillColor: whiteColor,
                    buttonBorder: Border.all(color: borderColor),
                    textColor: textPrimaryColor,
                    height: 38,
                    width: 90,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: borderColor.withValues(alpha: 0.6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: label,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
          Flexible(
            child: AppText(
              text: value,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
