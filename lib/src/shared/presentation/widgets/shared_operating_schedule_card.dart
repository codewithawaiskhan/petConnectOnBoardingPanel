import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/widgets/app_text.dart';

class SharedOperatingScheduleCard extends StatelessWidget with AppColors {
  final List<dynamic> availableDays;
  final String title;

  const SharedOperatingScheduleCard({
    super.key,
    required this.availableDays,
    this.title = "Operating Schedule",
  });

  static const List<String> _dayNames = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 18, color: primaryColor),
              const SizedBox(width: 8),
              AppText(
                text: title,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (availableDays.isEmpty)
            AppText(
              text: "No operating schedule provided.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          else
            Column(
              children: List.generate(availableDays.length, (index) {
                final dayItem = availableDays[index];

                final String dayLabel = _resolveDayName(dayItem, index);
                final bool isAvailable = _resolveIsAvailable(dayItem);
                final String? openTime = _resolveOpenTime(dayItem);
                final String? closeTime = _resolveCloseTime(dayItem);

                final String timeText;
                if (!isAvailable) {
                  timeText = "Closed";
                } else if (openTime != null &&
                    closeTime != null &&
                    openTime.isNotEmpty &&
                    closeTime.isNotEmpty) {
                  timeText = "$openTime - $closeTime";
                } else {
                  timeText = "Open";
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isAvailable
                                ? Icons.check_circle_outline_rounded
                                : Icons.cancel_outlined,
                            size: 16,
                            color: isAvailable ? successColor : errorColor,
                          ),
                          const SizedBox(width: 10),
                          AppText(
                            text: dayLabel,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ],
                      ),
                      AppText(
                        text: timeText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isAvailable ? textPrimaryColor : textSecondaryColor,
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  String _resolveDayName(dynamic item, int index) {
    if (index >= 0 && index < _dayNames.length) {
      return _dayNames[index];
    }

    try {
      if (item.dayIndex != null && item.dayIndex >= 0 && item.dayIndex < _dayNames.length) {
        return _dayNames[item.dayIndex as int];
      }
    } catch (_) {}

    try {
      if (item.dayName != null && item.dayName.toString().isNotEmpty) {
        return item.dayName.toString();
      }
    } catch (_) {}

    try {
      if (item.day != null && item.day.toString().isNotEmpty) {
        return item.day.toString();
      }
    } catch (_) {}

    return "Day ${index + 1}";
  }

  bool _resolveIsAvailable(dynamic item) {
    try {
      if (item.isAvailable != null) {
        return item.isAvailable == true;
      }
    } catch (_) {}

    try {
      if (item is Map) {
        return item['isAvailable'] == true || item['isAvailable'] == 'true';
      }
    } catch (_) {}

    return false;
  }

  String? _resolveOpenTime(dynamic item) {
    try {
      if (item.openTime != null) {
        return item.openTime.toString();
      }
    } catch (_) {}

    try {
      if (item is Map && item['openTime'] != null) {
        return item['openTime'].toString();
      }
    } catch (_) {}

    return null;
  }

  String? _resolveCloseTime(dynamic item) {
    try {
      if (item.closeTime != null) {
        return item.closeTime.toString();
      }
    } catch (_) {}

    try {
      if (item is Map && item['closeTime'] != null) {
        return item['closeTime'].toString();
      }
    } catch (_) {}

    return null;
  }
}
