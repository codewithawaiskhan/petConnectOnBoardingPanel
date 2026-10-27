import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../domain/entities/ai_assessment_entity.dart';
import '../dialogs/ai_assessment_details_dialog.dart';

class AiAssessmentCard extends StatefulWidget {
  final AiAssessmentEntity assessment;

  const AiAssessmentCard({super.key, required this.assessment});

  @override
  State<AiAssessmentCard> createState() => _AiAssessmentCardState();
}

class _AiAssessmentCardState extends State<AiAssessmentCard> with AppColors {
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

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'eye':
        return Icons.remove_red_eye_rounded;
      case 'skin':
      case 'coat':
        return Icons.pets_rounded;
      case 'dental':
      case 'teeth':
        return Icons.sentiment_satisfied_alt_rounded;
      case 'ear':
        return Icons.hearing_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessment = widget.assessment;
    final petImageUrl = _getPetImageUrl(assessment.petImage);
    final triageColor = _getTriageColor(assessment.triageLevel);
    final typeIcon = _getTypeIcon(assessment.type);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                AiAssessmentDetailsDialog(assessment: assessment),
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
                  ? triageColor.withValues(alpha: 0.5)
                  : borderColor,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? triageColor.withValues(alpha: 0.08)
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
                // 1. Header: Pet Image, Pet Name, and Triage Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pet Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: petImageUrl != null
                          ? Image.network(
                              petImageUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildAvatarPlaceholder(assessment.petName),
                            )
                          : _buildAvatarPlaceholder(assessment.petName),
                    ),
                    const SizedBox(width: 10),
                    // Pet Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: assessment.petName,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          AppText(
                            text: "AI Health Scan",
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    // Triage Level Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: triageColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: triageColor.withValues(alpha: 0.25),
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
                          const SizedBox(width: 4),
                          AppText(
                            text: _formatTitle(assessment.triageLevel),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: triageColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 2. Body: Headline prominently & Type Chip below it
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: assessment.headline,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Type Chip
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(typeIcon, size: 11, color: primaryColor),
                              const SizedBox(width: 4),
                              AppText(
                                text: "${_formatTitle(assessment.type)} Assessment",
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        if (assessment.results.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: borderColor),
                            ),
                            child: AppText(
                              text:
                                  "${assessment.results.length} Finding${assessment.results.length > 1 ? 's' : ''}",
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 3. Footer: CreatedAt Date with Clock/Calendar icon
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
                              text: _formatDate(assessment.createdAt),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AppText(
                              text: "View Report",
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 14,
                              color: primaryColor,
                            ),
                          ],
                        ),
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

  Widget _buildAvatarPlaceholder(String name) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : "P";
    return Container(
      color: primaryColor.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: AppText(
        text: initial,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }
}
