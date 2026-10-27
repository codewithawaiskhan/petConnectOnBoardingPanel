import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/show_image.dart';
import '../../domain/entities/ai_assessment_entity.dart';

class AiAssessmentDetailsDialog extends StatelessWidget with AppColors {
  final AiAssessmentEntity assessment;

  const AiAssessmentDetailsDialog({super.key, required this.assessment});

  String? _resolveImageUrl(String? raw) {
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

  Color _getTriageColor(String triage) {
    switch (triage.toLowerCase()) {
      case 'routine':
      case 'low':
      case 'normal':
        return successColor;
      case 'urgent':
      case 'high':
      case 'critical':
      case 'emergency':
        return errorColor;
      case 'moderate':
      case 'monitoring':
      case 'warning':
        return yellowColor;
      default:
        return primaryColor;
    }
  }

  String _formatTitle(String text) {
    if (text.isEmpty) return "";
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? "${w[0].toUpperCase()}${w.substring(1)}" : "")
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final petImageUrl = _resolveImageUrl(assessment.petImage);
    final triageColor = _getTriageColor(assessment.triageLevel);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 680,
        constraints: const BoxConstraints(maxHeight: 780),
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
                          text: assessment.petName,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text:
                              "AI Assessment • ${_formatTitle(assessment.type)}",
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
                      color: triageColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: triageColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: triageColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        AppText(
                          text: _formatTitle(assessment.triageLevel),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: triageColor,
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: primaryColor.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded,
                                  size: 16, color: primaryColor),
                              const SizedBox(width: 8),
                              AppText(
                                text: "Diagnosis Headline",
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            text: assessment.headline,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            text: "Assessed on ${_formatDate(assessment.createdAt)}",
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),

                    // Scanned Input Images (if any)
                    if (assessment.images.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                          "Assessment Input Media (${assessment.images.length})"),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: assessment.images.entries.map((entry) {
                          final slotName = entry.key;
                          final imgUrl = _resolveImageUrl(entry.value);

                          return Container(
                            width: 140,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 140,
                                  child: imgUrl != null
                                      ? Image.network(
                                          imgUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Center(
                                            child: Icon(
                                                Icons.broken_image_rounded,
                                                color: textSecondaryColor),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  child: AppText(
                                    text: _formatTitle(slotName),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Detailed Findings Section
                    if (assessment.results.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                          "Detailed Findings (${assessment.results.length})"),
                      const SizedBox(height: 12),
                      Column(
                        children: assessment.results.map((result) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Finding Title & Risk Level
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: result.title,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimaryColor,
                                      ),
                                    ),
                                    if (result.riskLevel != null &&
                                        result.riskLevel!.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: successColor
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: AppText(
                                          text: result.riskLevel!,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: successColor,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Overview
                                if (result.overview != null &&
                                    result.overview!.isNotEmpty) ...[
                                  AppText(
                                    text: result.overview!,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: textSecondaryColor,
                                    maxLines: 25,
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // Recommended Steps
                                if (result.recommendedNextSteps.isNotEmpty) ...[
                                  AppText(
                                    text: "Recommended Next Steps:",
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimaryColor,
                                  ),
                                  const SizedBox(height: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: result.recommendedNextSteps
                                        .map((step) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.check_circle_rounded,
                                                      size: 13,
                                                      color: successColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: AppText(
                                                      text: step,
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: textSecondaryColor,
                                                      maxLines: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 8),
                                ],

                                // Urgent Care Advice
                                if (result
                                    .whenToSeekImmediateCare.isNotEmpty) ...[
                                  AppText(
                                    text: "When to Seek Immediate Care:",
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: errorColor,
                                  ),
                                  const SizedBox(height: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: result.whenToSeekImmediateCare
                                        .map((advice) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.warning_amber_rounded,
                                                      size: 13,
                                                      color: errorColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: AppText(
                                                      text: advice,
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: textSecondaryColor,
                                                      maxLines: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Disclaimer
                    if (assessment.disclaimer != null &&
                        assessment.disclaimer!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 14, color: textSecondaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                text: assessment.disclaimer!,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: textSecondaryColor,
                                maxLines: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
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

  Widget _buildSectionHeader(String title) {
    return AppText(
      text: title,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: textPrimaryColor,
    );
  }
}
