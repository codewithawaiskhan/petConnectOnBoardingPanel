import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';

class DevicePlatformStatsCard extends StatelessWidget with AppColors {
  final int androidCount;
  final int iosCount;

  const DevicePlatformStatsCard({
    super.key,
    required this.androidCount,
    required this.iosCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = androidCount + iosCount;
    final double androidPct = total > 0 ? (androidCount / total) * 100 : 0.0;
    final double iosPct = total > 0 ? (iosCount / total) * 100 : 0.0;

    final numberFormat = NumberFormat('#,###');
    final formattedAndroid = numberFormat.format(androidCount);
    final formattedIOS = numberFormat.format(iosCount);
    final formattedTotal = numberFormat.format(total);

    final int androidFlex =
        total > 0 ? (androidPct * 10).round().clamp(1, 1000) : 1;
    final int iosFlex =
        total > 0 ? (iosPct * 10).round().clamp(1, 1000) : 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 620;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.devices_rounded,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Mobile Platform Adoption",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Android vs iOS distribution of registered users",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: "Total Devices: ",
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                        AppText(
                          text: formattedTotal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Metrics Breakdown: Android Card & iOS Card
              if (isNarrow)
                Column(
                  children: [
                    _buildPlatformTile(
                      platform: "Android Users",
                      icon: Icons.android_rounded,
                      color: androidGreenColor,
                      count: formattedAndroid,
                      percentage: androidPct,
                    ),
                    const SizedBox(height: 10),
                    _buildPlatformTile(
                      platform: "iOS Users",
                      icon: Icons.apple_rounded,
                      color: iosDarkColor,
                      count: formattedIOS,
                      percentage: iosPct,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _buildPlatformTile(
                        platform: "Android Users",
                        icon: Icons.android_rounded,
                        color: androidGreenColor,
                        count: formattedAndroid,
                        percentage: androidPct,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPlatformTile(
                        platform: "iOS Users",
                        icon: Icons.apple_rounded,
                        color: iosDarkColor,
                        count: formattedIOS,
                        percentage: iosPct,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 18),

              // Linear Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: borderColor,
                  child: total == 0
                      ? Container(color: borderColor)
                      : Row(
                          children: [
                            if (androidCount > 0)
                              Expanded(
                                flex: androidFlex,
                                child: Container(color: androidGreenColor),
                              ),
                            if (iosCount > 0)
                              Expanded(
                                flex: iosFlex,
                                child: Container(color: iosDarkColor),
                              ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 10),

              // Progress Bar Legend / Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: androidGreenColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        text: "Android: ${androidPct.toStringAsFixed(1)}%",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: iosDarkColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        text: "iOS: ${iosPct.toStringAsFixed(1)}%",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlatformTile({
    required String platform,
    required IconData icon,
    required Color color,
    required String count,
    required double percentage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: platform,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textSecondaryColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: count,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: AppText(
              text: "${percentage.toStringAsFixed(1)}%",
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color == iosDarkColor ? textPrimaryColor : color,
            ),
          ),
        ],
      ),
    );
  }
}
