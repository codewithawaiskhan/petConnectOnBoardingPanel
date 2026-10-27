import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../domain/entities/reminder_entity.dart';
import '../dialogs/reminder_details_dialog.dart';

class ReminderCard extends StatefulWidget {
  final ReminderEntity reminder;

  const ReminderCard({super.key, required this.reminder});

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> with AppColors {
  bool _isHovered = false;

  String? _getPetImageUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return "${ApiEndpoints.storageBaseUrl}/$raw";
  }

  String _formatDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "No time set";
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMM d, yyyy • hh:mm a').format(dateTime);
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
    final reminder = widget.reminder;
    final petImageUrl = _getPetImageUrl(reminder.petImage);
    final statusColor = reminder.isActive ? successColor : textSecondaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ReminderDetailsDialog(reminder: reminder),
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
                  ? primaryColor.withValues(alpha: 0.5)
                  : borderColor,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? primaryColor.withValues(alpha: 0.08)
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
                // 1. Header: Pet Image, Pet Name, and Active Status Badge
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
                                  _buildAvatarPlaceholder(reminder.petName),
                            )
                          : _buildAvatarPlaceholder(reminder.petName),
                    ),
                    const SizedBox(width: 10),
                    // Pet Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: reminder.petName,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          AppText(
                            text: "Pet Reminder",
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    // Active / Inactive Status Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.25),
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
                          const SizedBox(width: 4),
                          AppText(
                            text: reminder.isActive ? "Active" : "Inactive",
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 2. Body: Title prominently & Description below it
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: reminder.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (reminder.description != null &&
                        reminder.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      AppText(
                        text: reminder.description!.trim(),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: textSecondaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // 3. Meta Data Row: reminderType and routine chips
                Row(
                  children: [
                    if (reminder.routine != null &&
                        reminder.routine!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.repeat_rounded,
                                size: 11, color: primaryColor),
                            const SizedBox(width: 4),
                            AppText(
                              text: _formatChipText(reminder.routine!),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (reminder.reminderType != null &&
                        reminder.reminderType!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: skyBlueColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: skyBlueColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.category_outlined,
                                size: 11, color: skyBlueColor),
                            const SizedBox(width: 4),
                            AppText(
                              text: _formatChipText(reminder.reminderType!),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: skyBlueColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // 4. Footer: reminderDateTime with Clock Icon
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
                              Icons.access_time_rounded,
                              size: 12,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 5),
                            AppText(
                              text: _formatDateTime(reminder.reminderDateTime),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                        if (reminder.alerts.isNotEmpty) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 12,
                                color: yellowColor,
                              ),
                              const SizedBox(width: 2),
                              AppText(
                                text: "${reminder.alerts.length} alert${reminder.alerts.length > 1 ? 's' : ''}",
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: yellowColor,
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
