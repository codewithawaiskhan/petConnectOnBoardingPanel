import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/reminder_entity.dart';
import '../providers/reminders_provider.dart';
import 'reminder_card.dart';

class RemindersTabView extends StatefulWidget {
  final String userId;

  const RemindersTabView({super.key, required this.userId});

  @override
  State<RemindersTabView> createState() => _RemindersTabViewState();
}

class _RemindersTabViewState extends State<RemindersTabView> with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.userId.isNotEmpty) {
        context.read<RemindersProvider>().fetchReminders(widget.userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant RemindersTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId && widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RemindersProvider>().fetchReminders(widget.userId);
        }
      });
    }
  }

  String _formatFilterName(String filter) {
    if (filter == 'All') return 'All Reminders';
    return filter
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? "${w[0].toUpperCase()}${w.substring(1)}" : "")
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(Icons.person_off_outlined,
                size: 48, color: textSecondaryColor),
            const SizedBox(height: 12),
            AppText(
              text: "No User Account Linked",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
            AppText(
              text:
                  "This pet parent profile does not have an active user ID linked to fetch scheduled reminders.",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Consumer<RemindersProvider>(
      builder: (context, provider, _) {
        final reminders = provider.filteredReminders;
        final allReminders = provider.reminders;
        final filters = provider.availableFilters;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar: Title, Count, Filters & Refresh Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  AppText(
                    text: "Scheduled Reminders",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: "${allReminders.length}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Filter Chips
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map((filter) {
                          final isSelected = provider.selectedFilter.toLowerCase() ==
                              filter.toLowerCase();

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => provider.setSelectedFilter(filter),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        isSelected ? primaryColor : borderColor,
                                  ),
                                ),
                                child: AppText(
                                  text: _formatFilterName(filter),
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color:
                                      isSelected ? whiteColor : textSecondaryColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Refresh Button
                  IconButton(
                    icon: provider.isRemindersLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          )
                        : Icon(Icons.refresh_rounded, color: textSecondaryColor),
                    tooltip: "Refresh Reminders",
                    onPressed: provider.isRemindersLoading
                        ? null
                        : () => provider.fetchReminders(
                              widget.userId,
                              forceRefresh: true,
                            ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content Area
            if (provider.isRemindersLoading && allReminders.isEmpty) ...[
              _buildShimmerGrid(context),
            ] else if (provider.errorMessage != null && allReminders.isEmpty) ...[
              _buildErrorState(context, provider),
            ] else if (reminders.isEmpty) ...[
              _buildEmptyState(context, provider),
            ] else ...[
              _buildRemindersGrid(context, reminders),
            ],
          ],
        );
      },
    );
  }

  Widget _buildRemindersGrid(
      BuildContext context, List<ReminderEntity> reminders) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 188,
          ),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return ReminderCard(reminder: reminder);
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 188,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: 100,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 9,
                            width: 60,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 14,
                  width: 140,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 11,
                  width: 120,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, RemindersProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            text: provider.selectedFilter == 'All'
                ? "No Reminders Found"
                : "No ${_formatFilterName(provider.selectedFilter)} Reminders",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: provider.selectedFilter == 'All'
                ? "There are no reminders scheduled for this user's pets."
                : "No reminders found under the '${_formatFilterName(provider.selectedFilter)}' schedule.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          if (provider.selectedFilter != 'All') ...[
            const SizedBox(height: 16),
            CustomButton(
              text: "Reset Filter",
              fillColor: primaryColor,
              textColor: whiteColor,
              height: 40,
              onTap: () => provider.setSelectedFilter('All'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, RemindersProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
          const SizedBox(height: 12),
          AppText(
            text: "Failed to Load Reminders",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: provider.errorMessage ?? "An unexpected error occurred.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Retry",
            fillColor: primaryColor,
            textColor: whiteColor,
            height: 40,
            onTap: () => provider.fetchReminders(
              widget.userId,
              forceRefresh: true,
            ),
          ),
        ],
      ),
    );
  }
}
