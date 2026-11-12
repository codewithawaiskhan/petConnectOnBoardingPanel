import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/dashboard_stats_shimmer.dart';
import '../../domain/entities/company_dashboard_entity.dart';
import '../providers/company_dashboard_provider.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen>
    with AppColors, Constants {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyDashboardProvider>().fetchDashboardData();
    });
  }

  Future<void> _pickFromDate(
    BuildContext context,
    CompanyDashboardProvider provider,
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
      context.read<CompanyDashboardProvider>().updateDateRange(
        picked,
        provider.toDate,
      );
    }
  }

  Future<void> _pickToDate(
    BuildContext context,
    CompanyDashboardProvider provider,
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
      context.read<CompanyDashboardProvider>().updateDateRange(
        provider.fromDate,
        picked,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<CompanyDashboardProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchDashboardData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(context, provider, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.isLoading && provider.profile.id.isEmpty)
                    const DashboardStatsShimmer()
                  else if (provider.errorMessage != null &&
                      provider.profile.id.isEmpty)
                    _buildErrorState(provider)
                  else ...[
                    _buildProfileCard(provider.profile, isDesktop),
                    const SizedBox(height: 20),
                    _buildStatsGrid(provider.stats),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    CompanyDashboardProvider provider,
    bool isDesktop,
  ) {
    final fromLabel = provider.fromDate != null
        ? _dateFormat.format(provider.fromDate!)
        : "Start Date";
    final toLabel = provider.toDate != null
        ? _dateFormat.format(provider.toDate!)
        : "End Date";

    final fromBtn = _buildDatePickerButton(
      label: fromLabel,
      isSelected: provider.fromDate != null,
      icon: Icons.calendar_today_outlined,
      onTap: provider.isLoading ? null : () => _pickFromDate(context, provider),
    );

    final toBtn = _buildDatePickerButton(
      label: toLabel,
      isSelected: provider.toDate != null,
      icon: Icons.event_outlined,
      onTap: provider.isLoading ? null : () => _pickToDate(context, provider),
    );

    final clearBtn = provider.hasDateFilter
        ? Tooltip(
            message: "Clear Date Filter",
            child: InkWell(
              onTap: provider.isLoading ? null : () => provider.clearDateRange(),
              borderRadius: BorderRadius.circular(radiusMedium),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(radiusMedium),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(Icons.close_rounded, size: 18, color: errorColor),
              ),
            ),
          )
        : const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 680;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Company Overview",
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      text: "Monitor your company profile and referral performance",
                      fontSize: 12,
                      color: textSecondaryColor,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  fromBtn,
                  const SizedBox(width: 8),
                  AppText(
                    text: "to",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  toBtn,
                  if (provider.hasDateFilter) ...[
                    const SizedBox(width: 8),
                    clearBtn,
                  ],
                ],
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Company Overview",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: fromBtn),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText(
                    text: "to",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                ),
                Expanded(child: toBtn),
                if (provider.hasDateFilter) ...[
                  const SizedBox(width: 8),
                  clearBtn,
                ],
              ],
            ),
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

  Widget _buildProfileCard(CompanyProfileEntity profile, bool isDesktop) {
    final initial = profile.displayName.isNotEmpty
        ? profile.displayName.substring(0, 1).toUpperCase()
        : "M";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 640;

          final leftInfo = Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: primaryColor.withValues(alpha: 0.12),
                child: AppText(
                  text: initial,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppText(
                            text: profile.displayName.isNotEmpty
                                ? profile.displayName
                                : "Marketing Company",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.status.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          StatusBadge(status: profile.status),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: profile.legalName.isNotEmpty
                          ? profile.legalName
                          : "—",
                      fontSize: 13,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: profile.email.isNotEmpty ? profile.email : "—",
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          );

          final revenueShareBadge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: isWide
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: "Revenue Share",
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textSecondaryColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: "${profile.revenueShare}%",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: leftInfo),
                const SizedBox(width: 16),
                revenueShareBadge,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftInfo,
              const SizedBox(height: 14),
              revenueShareBadge,
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(ReferralStatsEntity stats) {
    final metrics = [
      _KpiItem(
        title: "Total Referred Users",
        subtitle: "Cold + Hot",
        count: "${stats.totalReferredUsers}",
        icon: Icons.groups_rounded,
        color: primaryColor,
      ),
      _KpiItem(
        title: "Converted Referred Users",
        subtitle: "Hot",
        count: "${stats.convertedReferredUsers}",
        icon: Icons.verified_user_rounded,
        color: successColor,
      ),
      _KpiItem(
        title: "Non-Converted Referred Users",
        subtitle: "Cold",
        count: "${stats.nonconvertedReferredUsers}",
        icon: Icons.person_outline_rounded,
        color: yellowColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 860
            ? 3
            : constraints.maxWidth > 540
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 100,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final item = metrics[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: item.count,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: item.title,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textSecondaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppText(
                          text: item.subtitle,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(CompanyDashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: errorColor, size: 42),
          const SizedBox(height: 12),
          AppText(
            text: provider.errorMessage ?? "Failed to load company dashboard",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Try Again",
            height: 36,
            radius: 8,
            onTap: () => provider.fetchDashboardData(),
          ),
        ],
      ),
    );
  }
}

class _KpiItem {
  final String title;
  final String subtitle;
  final String count;
  final IconData icon;
  final Color color;

  const _KpiItem({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.color,
  });
}

