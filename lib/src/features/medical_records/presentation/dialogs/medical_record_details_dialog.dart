import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/show_image.dart';
import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordDetailsDialog extends StatelessWidget with AppColors {
  final MedicalRecordEntity record;

  const MedicalRecordDetailsDialog({super.key, required this.record});

  String? _getPetImageUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return "${ApiEndpoints.storageBaseUrl}/$raw";
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMMM d, yyyy • hh:mm a').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'vital':
        return primaryColor;
      case 'vaccination':
        return successColor;
      case 'document':
        return skyBlueColor;
      case 'medication':
        return yellowColor;
      case 'surgery':
        return errorColor;
      default:
        return textSecondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(record.category);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 620,
        constraints: const BoxConstraints(maxHeight: 700),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ShowImage().buildImage(
                      image: _getPetImageUrl(record.petImage),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: record.petName,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: "Medical Record • ${record.category.toUpperCase()}",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                    ),
                    child: AppText(
                      text: record.category.toUpperCase(),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: categoryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textSecondaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: "Close",
                  ),
                ],
              ),
            ),

            // Modal Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highlight Banner (if vital reading or type)
                    if (record.category.toLowerCase() == 'vital') ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.monitor_heart_rounded,
                                  color: primaryColor, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: record.vitalType != null
                                      ? "Vital: ${record.vitalType![0].toUpperCase()}${record.vitalType!.substring(1)}"
                                      : "Vital Measurement",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondaryColor,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    AppText(
                                      text: record.value != null
                                          ? "${record.value}"
                                          : "N/A",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                    ),
                                    if (record.unit != null) ...[
                                      const SizedBox(width: 4),
                                      AppText(
                                        text: record.unit!,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textSecondaryColor,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Specifications Table
                    _buildSectionHeader("Record Details"),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow("Record ID", record.id),
                          _buildDetailRow("Category", record.category),
                          if (record.type != null && record.type!.isNotEmpty)
                            _buildDetailRow("Type", record.type!),
                          if (record.vitalType != null && record.vitalType!.isNotEmpty)
                            _buildDetailRow("Vital Type", record.vitalType!),
                          if (record.value != null)
                            _buildDetailRow("Value", "${record.value} ${record.unit ?? ''}"),
                          _buildDetailRow("Recorded At", _formatDate(record.recordedAt)),
                          if (record.createdAt != null)
                            _buildDetailRow("Created On", _formatDate(record.createdAt)),
                        ],
                      ),
                    ),

                    // Action Taken
                    if (record.actionTaken != null && record.actionTaken!.trim().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSectionHeader("Action Taken"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: successColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 18, color: successColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppText(
                                text: record.actionTaken!,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Clinical Notes
                    if (record.notes != null && record.notes!.trim().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSectionHeader("Clinical Notes"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.description_outlined, size: 18, color: textSecondaryColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppText(
                                text: record.notes!,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Files & Attachments
                    if (record.files.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSectionHeader("Attachments (${record.files.length})"),
                      const SizedBox(height: 10),
                      Column(
                        children: record.files.map((fileUrl) {
                          final fileName = fileUrl.split('/').last;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.attach_file_rounded, size: 18, color: primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AppText(
                                    text: fileName.isNotEmpty ? fileName : fileUrl,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimaryColor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
                    height: 40,
                    width: 100,
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

  Widget _buildSectionHeader(String title) {
    return AppText(
      text: title,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: textPrimaryColor,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
          Flexible(
            child: AppText(
              text: value,
              fontSize: 12,
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
