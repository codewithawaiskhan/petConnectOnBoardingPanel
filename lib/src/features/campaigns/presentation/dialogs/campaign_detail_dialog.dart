import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/campaign_entity.dart';

class CampaignDetailDialog extends StatelessWidget with AppColors {
  final CampaignEntity campaign;

  const CampaignDetailDialog({super.key, required this.campaign});

  static Future<void> show(BuildContext context, CampaignEntity campaign) {
    return showDialog<void>(
      context: context,
      builder: (_) => CampaignDetailDialog(campaign: campaign),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  String _getUserTypeLabel(String type) {
    switch (type) {
      case 'all':
        return 'All Users';
      case 'petParent':
        return 'Pet Parents';
      case 'doctor':
        return 'Veterinarians';
      case 'lab':
        return 'Diagnostic Labs';
      case 'serviceProvider':
        return 'Service Providers';
      default:
        return type;
    }
  }

  String _getWeekDayLabel(int? day) {
    switch (day) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '—';
    }
  }

  Widget _buildBanner(String? rawImage) {
    if (rawImage == null || rawImage.trim().isEmpty) return const SizedBox.shrink();

    final trimmed = rawImage.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Part =
            commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final bytes = base64Decode(base64Part.trim());
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
              ),
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),
        );
      } catch (_) {
        return const SizedBox.shrink();
      }
    }

    final imageUrl = trimmed.startsWith('http')
        ? trimmed
        : "${ApiEndpoints.storageBaseUrl}/$trimmed";

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: backgroundColor,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: textSecondaryColor,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannerImage = campaign.featuredImage ?? campaign.attachment;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 800),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: textPrimaryColor.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Campaign Details',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text:
                                campaign.longAutoIncrementId ??
                                (campaign.id.length > 8
                                    ? campaign.id.substring(0, 8).toUpperCase()
                                    : campaign.id),
                            fontSize: 12,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: textSecondaryColor,
                        size: 22,
                      ),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: borderColor),

              // Body content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner if present
                      _buildBanner(bannerImage),

                      // Title
                      AppText(
                        text: campaign.title,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 12),

                      // Badges Row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Target Audience
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_alt_outlined,
                                  size: 14,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 6),
                                AppText(
                                  text: _getUserTypeLabel(campaign.userType),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                          // Frequency
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: tertiaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.repeat_rounded,
                                  size: 14,
                                  color: tertiaryColor,
                                ),
                                const SizedBox(width: 6),
                                AppText(
                                  text: campaign.frequency,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: tertiaryColor,
                                ),
                              ],
                            ),
                          ),
                          // Weekly Recurrence
                          if (campaign.frequency.toLowerCase() == 'weekly' &&
                              campaign.weekDay != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: yellowColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 14,
                                    color: yellowColor,
                                  ),
                                  const SizedBox(width: 6),
                                  AppText(
                                    text:
                                        'Every ${_getWeekDayLabel(campaign.weekDay)}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: yellowColor,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Message Body
                      AppText(
                        text: 'Message Content',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondaryColor,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: AppText(
                          text: campaign.body.isNotEmpty
                              ? campaign.body
                              : 'No message content provided.',
                          fontSize: 14,
                          color: textPrimaryColor,
                          fontWeight: FontWeight.w400,
                          maxLines: 10,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Additional Info
                      _buildInfoRow(
                        label: 'Target URL / Link',
                        value: campaign.link ?? 'None',
                        isLink:
                            campaign.link != null &&
                            campaign.link!.trim().isNotEmpty,
                      ),
                      if (campaign.attachment != null &&
                          campaign.attachment!.trim().isNotEmpty &&
                          !campaign.attachment!.startsWith('data:image') &&
                          campaign.attachment != bannerImage) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          label: 'Attachment',
                          value: campaign.attachment!,
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        label: 'Country / Region',
                        value:
                            (campaign.countryName != null &&
                                campaign.countryName!.isNotEmpty)
                            ? "${campaign.countryName!} (${campaign.countryCode ?? '—'})"
                            : (campaign.countryCode ?? 'Global / All Regions'),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        label: 'Created Date',
                        value: _formatDate(campaign.createdAt),
                      ),
                      if (campaign.updatedAt != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          label: 'Last Updated',
                          value: _formatDate(campaign.updatedAt),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: borderColor),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Close',
                      height: 42,
                      width: 100,
                      fontSize: 13,
                      onTap: () => Navigator.of(context).pop(),
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: AppText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            text: value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isLink ? primaryColor : textPrimaryColor,
          ),
        ),
      ],
    );
  }
}
