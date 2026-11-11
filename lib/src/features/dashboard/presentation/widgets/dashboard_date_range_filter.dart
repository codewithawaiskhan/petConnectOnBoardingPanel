import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../providers/dashboard_provider.dart';

class DashboardDateRangeFilter extends StatelessWidget
    with AppColors, Constants {
  final bool expandButtons;

  DashboardDateRangeFilter({
    super.key,
    this.expandButtons = false,
  });

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  Future<void> _pickFromDate(
    BuildContext context,
    DashboardProvider provider,
  ) async {
    final now = DateTime.now();
    final first = DateTime(2000);
    final last = provider.toDate ?? DateTime(2100);
    final initial = provider.fromDate ?? now;
    final clampedInitial = initial.isAfter(last)
        ? last
        : (initial.isBefore(first) ? first : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<DashboardProvider>().updateDateRange(picked, provider.toDate);
    }
  }

  Future<void> _pickToDate(
    BuildContext context,
    DashboardProvider provider,
  ) async {
    final now = DateTime.now();
    final first = provider.fromDate ?? DateTime(2000);
    final last = DateTime(2100);
    final initial = provider.toDate ?? now;
    final clampedInitial = initial.isBefore(first)
        ? first
        : (initial.isAfter(last) ? last : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<DashboardProvider>().updateDateRange(provider.fromDate, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final isBusy =
            provider.isLoading ||
            provider.isTopCountriesLoading ||
            provider.isTopStatesLoading;

        final fromLabel = provider.fromDate != null
            ? _dateFormat.format(provider.fromDate!)
            : "Start Date";
        final toLabel = provider.toDate != null
            ? _dateFormat.format(provider.toDate!)
            : "End Date";

        final fromButton = _buildDatePickerButton(
          label: fromLabel,
          isSelected: provider.fromDate != null,
          icon: Icons.calendar_today_outlined,
          onTap: isBusy ? null : () => _pickFromDate(context, provider),
        );

        final toButton = _buildDatePickerButton(
          label: toLabel,
          isSelected: provider.toDate != null,
          icon: Icons.event_outlined,
          onTap: isBusy ? null : () => _pickToDate(context, provider),
        );

        final clearButton = provider.hasDateFilter
            ? Tooltip(
                message: "Clear Date Filter",
                child: InkWell(
                  onTap: isBusy
                      ? null
                      : () => context.read<DashboardProvider>().clearDateRange(),
                  borderRadius: BorderRadius.circular(radiusMedium),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(radiusMedium),
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: errorColor,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();

        return Row(
          mainAxisSize: expandButtons ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (expandButtons) Expanded(child: fromButton) else fromButton,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AppText(
                text: "to",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textSecondaryColor,
              ),
            ),
            if (expandButtons) Expanded(child: toButton) else toButton,
            if (provider.hasDateFilter) ...[
              const SizedBox(width: 8),
              clearButton,
            ],
          ],
        );
      },
    );
  }

  Widget _buildDatePickerButton({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radiusMedium),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : whiteColor,
          borderRadius: BorderRadius.circular(radiusMedium),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? primaryColor : textSecondaryColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: AppText(
                text: label,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? primaryColor : textSecondaryColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

