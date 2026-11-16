import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
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
      context.read<CompanyDashboardProvider>().fetchDashboardStats();
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
            onRefresh: () => provider.fetchDashboardStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24.0 : 16.0,
                vertical: isDesktop ? 16.0 : 14.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(context, provider, isDesktop),
                  const SizedBox(height: 16),
                  if (provider.isLoading && provider.dashboardData == null)
                    const DashboardStatsShimmer()
                  else if (provider.errorMessage != null &&
                      provider.dashboardData == null)
                    _buildErrorState(provider)
                  else if (provider.dashboardData != null) ...[
                    _buildTeamAndReferralsSection(
                      context,
                      provider.dashboardData!,
                    ),
                    const SizedBox(height: 20),
                    _buildFinancialOverviewSection(
                      context,
                      provider.dashboardData!,
                    ),
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
    final companyName =
        provider.dashboardData?.marketingCompany.displayName.isNotEmpty == true
        ? provider.dashboardData!.marketingCompany.displayName
        : "Marketing Company";

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
              onTap: provider.isLoading
                  ? null
                  : () => provider.clearDateRange(),
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
        final isWide = constraints.maxWidth >= 720;

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
                    const SizedBox(height: 4),
                    AppText(
                      text: "Welcome back, $companyName",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
            const SizedBox(height: 2),
            AppText(
              text: "Welcome back, $companyName",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textSecondaryColor,
            ),
            const SizedBox(height: 14),
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
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : whiteColor,
          borderRadius: BorderRadius.circular(radiusMedium),
          border: Border.all(color: isSelected ? primaryColor : borderColor),
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

  // ==================== SECTION 1: TEAM & REFERRALS ====================
  Widget _buildTeamAndReferralsSection(
    BuildContext context,
    CompanyDashboardEntity data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Team & Referrals",
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 2),
        AppText(
          text: "Track active influencer network and referral conversion rates",
          fontSize: 11,
          color: textSecondaryColor,
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 920
                ? 3
                : constraints.maxWidth > 580
                ? 2
                : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 168,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) return _buildActiveInfluencersCard(data);
                if (index == 1) return _buildConvertedCard(data);
                return _buildNonConvertedCard(data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActiveInfluencersCard(CompanyDashboardEntity data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Active Influencers",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: primaryColor,
                  size: 17,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: "${data.activeInfluencersCount}",
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 13, color: primaryColor),
                    const SizedBox(width: 3),
                    AppText(
                      text: "Active Network",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConvertedCard(CompanyDashboardEntity data) {
    final rateStr = data.combinedConversionRate.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "Converted Referrals",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: "Hot",
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: successColor,
                    ),
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: successColor,
                  size: 17,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    text: "${data.convertedUsersCount}",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: successColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 13,
                            color: successColor,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: AppText(
                              text: "$rateStr% Conversion",
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: successColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 5),
              DeviceDistributionVisualizer(
                androidCount: data.convertedUsersCountAndroid,
                iosCount: data.convertedUsersCountiOS,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNonConvertedCard(CompanyDashboardEntity data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "Non-Converted Referrals",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: yellowColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: "Cold",
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: yellowColor,
                    ),
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: yellowColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: yellowColor,
                  size: 17,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    text: "${data.nonconvertedUsersCount}",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: yellowColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: yellowColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            size: 12,
                            color: yellowColor,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: AppText(
                              text: "Unconverted Leads",
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: yellowColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 5),
              DeviceDistributionVisualizer(
                androidCount: data.nonconvertedUsersCountAndroid,
                iosCount: data.nonconvertedUsersCountiOS,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== SECTION 2: FINANCIAL OVERVIEW ====================
  Widget _buildFinancialOverviewSection(
    BuildContext context,
    CompanyDashboardEntity data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Financial Overview",
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 2),
        AppText(
          text:
              "Real-time earnings, deductions, and net company payout balance",
          fontSize: 11,
          color: textSecondaryColor,
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 920
                ? 3
                : constraints.maxWidth > 580
                ? 2
                : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 120,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) return _buildGrossEarningsCard(data);
                if (index == 1) return _buildRefundsCard(data);
                return _buildNetEarningsCard(data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGrossEarningsCard(CompanyDashboardEntity data) {
    final formatted =
        "${data.currencyCode} ${data.grossEarnings.toStringAsFixed(2)}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Gross Earnings",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: primaryColor,
                  size: 17,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: formatted,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 2),
              AppText(
                text: "Total Revenue Generated",
                fontSize: 11,
                color: textSecondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefundsCard(CompanyDashboardEntity data) {
    final formatted = "${data.currencyCode} ${data.refunds.toStringAsFixed(2)}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Refunds",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.replay_rounded, color: errorColor, size: 17),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: formatted,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: errorColor,
              ),
              const SizedBox(height: 2),
              AppText(
                text: "Total Deductions & Reversals",
                fontSize: 11,
                color: textSecondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetEarningsCard(CompanyDashboardEntity data) {
    final formatted =
        "${data.currencyCode} ${data.netEarnings.toStringAsFixed(2)}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: successColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "Net Earnings",
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: "Payout",
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: successColor,
                    ),
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payments_rounded,
                  color: successColor,
                  size: 17,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: formatted,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: successColor,
              ),
              const SizedBox(height: 2),
              AppText(
                text: "Net Take-Home Earnings",
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
            ],
          ),
        ],
      ),
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
            onTap: () => provider.fetchDashboardStats(),
          ),
        ],
      ),
    );
  }
}

class DeviceDistributionVisualizer extends StatelessWidget with AppColors {
  final int androidCount;
  final int iosCount;

  const DeviceDistributionVisualizer({
    super.key,
    required this.androidCount,
    required this.iosCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = androidCount + iosCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Row: Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Android Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: lightGreenColor.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: successColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.android, size: 12, color: successColor),
                  const SizedBox(width: 4),
                  AppText(
                    text: "$androidCount",
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: successColor,
                  ),
                ],
              ),
            ),
            // iOS Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.apple, size: 12, color: iosDarkColor),
                  const SizedBox(width: 4),
                  AppText(
                    text: "$iosCount",
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: iosDarkColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Bottom Row: Mini Graph Segmented Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 6.0,
            child: Row(
              children: [
                if (total == 0)
                  Expanded(flex: 1, child: Container(color: borderColor))
                else ...[
                  if (androidCount > 0)
                    Expanded(
                      flex: androidCount,
                      child: Container(
                        decoration: BoxDecoration(color: androidGreenColor),
                      ),
                    ),
                  if (androidCount > 0 && iosCount > 0)
                    const SizedBox(width: 2),
                  if (iosCount > 0)
                    Expanded(
                      flex: iosCount,
                      child: Container(
                        decoration: BoxDecoration(color: iosDarkColor),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
