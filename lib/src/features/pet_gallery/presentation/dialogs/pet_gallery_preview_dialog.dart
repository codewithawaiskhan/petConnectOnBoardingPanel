import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/show_image.dart';
import '../../domain/entities/pet_gallery_entity.dart';

class PetGalleryPreviewDialog extends StatelessWidget with AppColors {
  final PetGalleryEntity item;

  const PetGalleryPreviewDialog({super.key, required this.item});

  String _resolveImageUrl(String raw) {
    if (raw.trim().isEmpty) return "";
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final cleanPath = raw.startsWith('/') ? raw.substring(1) : raw;
    return "${ApiEndpoints.storageBaseUrl}/$cleanPath";
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMMM d, yyyy • hh:mm a').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.pets_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: item.petName,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 1),
                          AppText(
                            text: _formatDate(item.createdAt),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: textSecondaryColor,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: "Close",
                    ),
                  ],
                ),
              ),

              // Image Area
              Flexible(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.03),
                  child: Center(
                    child: ShowImage().buildImage(
                      image: _resolveImageUrl(item.imageUrl),
                      fit: BoxFit.contain,
                      radius: 0,
                    ),
                  ),
                ),
              ),

              // Remark (if any)
              if (item.remark != null && item.remark!.trim().isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes_rounded, size: 16, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          text: item.remark!.trim(),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: "Close",
                      onTap: () => Navigator.of(context).pop(),
                      fillColor: primaryColor,
                      textColor: whiteColor,
                      height: 38,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
