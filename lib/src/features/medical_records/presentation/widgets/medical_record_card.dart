import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../dialogs/medical_record_details_dialog.dart';

class MedicalRecordCard extends StatefulWidget {
  final MedicalRecordEntity record;

  const MedicalRecordCard({super.key, required this.record});

  @override
  State<MedicalRecordCard> createState() => _MedicalRecordCardState();
}

class _MedicalRecordCardState extends State<MedicalRecordCard> with AppColors {
  bool _isHovered = false;

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
      return DateFormat('MMM d, yyyy • hh:mm a').format(dateTime);
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'vital':
        return Icons.monitor_heart_rounded;
      case 'vaccination':
        return Icons.vaccines_rounded;
      case 'document':
        return Icons.description_rounded;
      case 'medication':
        return Icons.medication_rounded;
      case 'surgery':
        return Icons.healing_rounded;
      default:
        return Icons.medical_information_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final categoryColor = _getCategoryColor(record.category);
    final categoryIcon = _getCategoryIcon(record.category);
    final petImageUrl = _getPetImageUrl(record.petImage);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => MedicalRecordDetailsDialog(record: record),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0.0, _isHovered ? -2.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? categoryColor.withValues(alpha: 0.5)
                  : borderColor,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? categoryColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: _isHovered ? 10 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Header: Pet Avatar + Name & Category Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pet Thumbnail (Loads from AWS S3, falls back to clean initial)
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: petImageUrl != null
                          ? Image.network(
                              petImageUrl,
                              width: 38,
                              height: 38,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildAvatarPlaceholder(record.petName),
                            )
                          : _buildAvatarPlaceholder(record.petName),
                    ),
                    const SizedBox(width: 10),
                    // Pet Name & Type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: record.petName,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          AppText(
                            text: record.type != null && record.type!.isNotEmpty
                                ? record.type!
                                : "Record #${record.id.length > 6 ? record.id.substring(record.id.length - 6).toUpperCase() : record.id}",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryIcon, size: 12, color: categoryColor),
                          const SizedBox(width: 4),
                          AppText(
                            text: record.category.isEmpty
                                ? "Record"
                                : "${record.category[0].toUpperCase()}${record.category.substring(1).toLowerCase()}",
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: categoryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 2. Body: Dynamic Content (Compact height)
                _buildDynamicBody(record),

                // 3. Footer: RecordedAt Date & Attachment indicator
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1, color: borderColor.withValues(alpha: 0.8)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 11.5,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 5),
                            AppText(
                              text: _formatDate(record.recordedAt),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                        if (record.files.isNotEmpty) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                size: 12,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 2),
                              AppText(
                                text: "${record.files.length}",
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicBody(MedicalRecordEntity record) {
    final cat = record.category.toLowerCase();

    if (cat == 'vital') {
      final vitalName = (record.vitalType != null && record.vitalType!.isNotEmpty)
          ? "${record.vitalType![0].toUpperCase()}${record.vitalType!.substring(1)}"
          : "Vital Reading";
      final valStr = record.value != null ? "${record.value}" : "—";
      final unitStr = record.unit != null ? " ${record.unit}" : "";

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.scale_rounded, size: 14, color: primaryColor),
            ),
            const SizedBox(width: 8),
            AppText(
              text: vitalName,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textSecondaryColor,
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AppText(
                  text: valStr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
                if (unitStr.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  AppText(
                    text: unitStr,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textSecondaryColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    }

    if (cat == 'vaccination') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: successColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: successColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_rounded, size: 14, color: successColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                text: record.type ?? "Vaccination Administered",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: successColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (cat == 'document') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: skyBlueColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: skyBlueColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: skyBlueColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_shared_rounded, size: 14, color: skyBlueColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                text: record.type ?? "Medical Document",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: skyBlueColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Medication, Surgery, Other
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: textSecondaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getCategoryIcon(record.category),
                size: 14, color: textSecondaryColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text: record.type ?? record.category.toUpperCase(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : "P";
    return Container(
      color: primaryColor.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: AppText(
        text: initial,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }
}
