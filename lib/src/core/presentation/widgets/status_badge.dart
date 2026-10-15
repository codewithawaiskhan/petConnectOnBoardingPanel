import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'app_text.dart';

class StatusBadge extends StatelessWidget with AppColors {
  final String status;
  final bool isDeleted;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.status,
    this.isDeleted = false,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    final trimmedStatus = status.trim();
    final lower = trimmedStatus.toLowerCase();

    if (isDeleted ||
        lower == 'deleted' ||
        lower == 'declined' ||
        lower == 'blocked' ||
        lower == 'rejected') {
      bg = peachColor.withValues(alpha: 0.6);
      fg = errorColor;
    } else if (lower == 'pending' ||
        lower == 'in review' ||
        lower == 'in_review' ||
        lower == 'under review' ||
        lower == 'review') {
      bg = lightYellowColor;
      fg = yellowColor;
    } else if (lower == 'approved' ||
        lower == 'active' ||
        lower == 'verified' ||
        lower == 'completed') {
      bg = lightGreenColor;
      fg = successColor;
    } else {
      bg = borderColor;
      fg = textSecondaryColor;
    }

    final String displayLabel;
    if (isDeleted) {
      if (lower == 'deleted') {
        displayLabel = trimmedStatus;
      } else if (lower == 'active' || trimmedStatus.isEmpty) {
        displayLabel = 'Deleted';
      } else {
        displayLabel = '$trimmedStatus (Deleted)';
      }
    } else {
      displayLabel = trimmedStatus.isEmpty ? 'Unknown' : trimmedStatus;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: AppText(
              text: displayLabel,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
