import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import 'app_text.dart';

class BootstrapPagination extends StatelessWidget with AppColors {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final bool isEnabled;

  const BootstrapPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();

    int startPage = currentPage - 1;
    if (startPage < 1) startPage = 1;
    int endPage = startPage + 2;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = endPage - 2;
      if (startPage < 1) startPage = 1;
    }

    final pages = <int>[];
    for (int p = startPage; p <= endPage; p++) {
      pages.add(p);
    }

    final hasPrevious = currentPage > 1 && isEnabled;
    final hasNext = currentPage < totalPages && isEnabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Previous Button
        _buildNavButton(
          label: "Prev",
          icon: Icons.chevron_left_rounded,
          isEnabled: hasPrevious,
          onTap: hasPrevious ? () => onPageChanged(currentPage - 1) : null,
          isLeadingIcon: true,
        ),
        const SizedBox(width: 8),

        // Page Number Buttons
        ...pages.map((page) {
          final isSelected = page == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: isEnabled && !isSelected ? () => onPageChanged(page) : null,
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primaryColor : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(color: softSkyBlue, width: 0.4),
                ),
                alignment: Alignment.center,
                child: AppText(
                  text: "$page",
                  fontFamily: fontPoppins,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? whiteColor : primaryColor,
                ),
              ),
            ),
          );
        }),

        const SizedBox(width: 8),
        // Next Button
        _buildNavButton(
          label: "Next",
          icon: Icons.chevron_right_rounded,
          isEnabled: hasNext,
          onTap: hasNext ? () => onPageChanged(currentPage + 1) : null,
          isLeadingIcon: false,
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
    required bool isLeadingIcon,
  }) {
    final activeColor = primaryColor;
    final disabledColor = textSecondaryColor.withValues(alpha: 0.4);
    final currentColor = isEnabled ? activeColor : disabledColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? primaryColor.withValues(alpha: 0.35)
                : borderColor,
            width: 0.8,
          ),
          color: isEnabled
              ? primaryColor.withValues(alpha: 0.04)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLeadingIcon) ...[
              Icon(icon, size: 16, color: currentColor),
              const SizedBox(width: 4),
            ],
            AppText(
              text: label,
              fontFamily: fontPoppins,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: currentColor,
            ),
            if (!isLeadingIcon) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: currentColor),
            ],
          ],
        ),
      ),
    );
  }
}

class ItemsPerPageDropdown extends StatelessWidget with AppColors {
  final int currentLimit;
  final ValueChanged<int> onLimitChanged;
  final List<int> options;
  final bool isEnabled;

  const ItemsPerPageDropdown({
    super.key,
    required this.currentLimit,
    required this.onLimitChanged,
    this.options = const [10, 25, 50, 100],
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: "Rows:",
            fontFamily: fontPoppins,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: options.contains(currentLimit) ? currentLimit : options.first,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isEnabled ? textPrimaryColor : textSecondaryColor,
              ),
              isDense: true,
              borderRadius: BorderRadius.circular(8),
              dropdownColor: whiteColor,
              style: TextStyle(
                fontFamily: fontPoppins,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isEnabled ? primaryColor : textSecondaryColor,
              ),
              items: options.map((int limit) {
                return DropdownMenuItem<int>(
                  value: limit,
                  child: AppText(
                    text: "$limit",
                    fontFamily: fontPoppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: limit == currentLimit ? primaryColor : textPrimaryColor,
                  ),
                );
              }).toList(),
              onChanged: isEnabled
                  ? (newVal) {
                      if (newVal != null && newVal != currentLimit) {
                        onLimitChanged(newVal);
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
