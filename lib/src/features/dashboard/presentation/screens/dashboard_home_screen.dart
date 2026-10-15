import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/dashboard_stats_shimmer.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../providers/dashboard_provider.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchDashboardStats(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(context.isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeBanner(context),
                  const SizedBox(height: 24),
                  if (provider.isLoading)
                    const DashboardStatsShimmer()
                  else
                    _buildMetricsGrid(context, provider.stats),
                  const SizedBox(height: 28),
                  _buildQuickActionsAndChartSection(context, provider),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        gradient: LinearGradient(
          colors: [primaryColor.withValues(alpha: 0.08), whiteColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: "PORTAL OVERVIEW",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                AppText(
                  text: "Welcome to PetConnect Onboarding Portal",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 6),
                AppText(
                  text:
                      "Manage provider verifications, onboard medical veterinarians, and oversee clinical lab branches.",
                  fontSize: 14,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),
          if (context.isDesktop) ...[
            const SizedBox(width: 24),
            CustomButton(
              text: "Onboard New Doctor",
              width: 190,
              height: 46,
              fontSize: 14,
              onTap: () => context.go('/doctors'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, DashboardStatsEntity stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 550
            ? 2
            : 1;

        final metrics = [
          _MetricData(
            title: "Total Veterinarians",
            count: "${stats.totalDoctorsCount}",
            subtitle: "+${stats.newThisMonthDoctorsCount} this month",
            icon: Icons.medical_services_rounded,
            color: primaryColor,
          ),
          _MetricData(
            title: "Service Providers",
            count: "${stats.totalServiceProvidersCount}",
            subtitle: "+${stats.newThisMonthServiceProvidersCount} this month",
            icon: Icons.pets_rounded,
            color: skyBlueColor,
          ),
          _MetricData(
            title: "Diagnostic Labs",
            count: "${stats.totalLabsCount}",
            subtitle: "+${stats.newThisMonthLabsCount} this month",
            icon: Icons.biotech_rounded,
            color: tertiaryColor,
          ),
          _MetricData(
            title: "Pet Parents",
            count: "${stats.totalPetParentsCount}",
            subtitle: "+${stats.newThisMonthPetParentsCount} this month",
            icon: Icons.people_outline_rounded,
            color: yellowColor,
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 130,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final m = metrics[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: m.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(m.icon, color: m.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: m.count,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: m.title,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: m.subtitle,
                          fontSize: 11,
                          color: m.color,
                          fontWeight: FontWeight.w600,
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

  Widget _buildQuickActionsAndChartSection(
    BuildContext context,
    DashboardProvider provider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTwoColumn = constraints.maxWidth > 860;

        final quickActions = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Quick Onboarding Portals",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: "Direct links to register each medical role",
                fontSize: 12,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 18),
              _buildActionTile(
                title: "Doctor / Vet Onboarding",
                desc: "Medical licenses, clinics, degrees & schedule",
                icon: Icons.medical_services_outlined,
                onTap: () => context.go('/doctors'),
              ),
              const Divider(height: 20),
              _buildActionTile(
                title: "Service Provider Onboarding",
                desc: "Grooming, training, boarding facilities & services",
                icon: Icons.pets_outlined,
                onTap: () => context.go('/service-providers'),
              ),
              const Divider(height: 20),
              _buildActionTile(
                title: "Diagnostic Lab Onboarding",
                desc: "Clinical tests, sample collection, ISO licenses",
                icon: Icons.biotech_outlined,
                onTap: () => context.go('/diagnostic-labs'),
              ),
            ],
          ),
        );

        final monthlyChart = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "New This Month Overview",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: "Monthly registrations across all roles",
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: "Live Stats",
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: provider.isLoading
                    ? Shimmer.fromColors(
                        baseColor: baseShimmerColor,
                        highlightColor: highlightShimmerColor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    : _buildMonthlyBarChart(provider.stats),
              ),
            ],
          ),
        );

        if (isTwoColumn) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: quickActions),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: monthlyChart),
            ],
          );
        } else {
          return Column(
            children: [quickActions, const SizedBox(height: 20), monthlyChart],
          );
        }
      },
    );
  }

  Widget _buildMonthlyBarChart(DashboardStatsEntity stats) {
    final values = [
      stats.newThisMonthDoctorsCount.toDouble(),
      stats.newThisMonthServiceProvidersCount.toDouble(),
      stats.newThisMonthLabsCount.toDouble(),
      stats.newThisMonthPetParentsCount.toDouble(),
    ];

    final maxVal = values.reduce(max);
    final topLimit = (maxVal > 5 ? maxVal + 2 : 6.0);

    final colors = [primaryColor, skyBlueColor, tertiaryColor, yellowColor];

    final labels = ["Vets", "SPs", "Labs", "Parents"];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topLimit,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => primaryColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                "${labels[group.x]}: ${rod.toY.toInt()}",
                TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: AppText(
                    text: labels[index],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: topLimit > 10 ? (topLimit / 4).roundToDouble() : 2,
              getTitlesWidget: (value, meta) {
                return AppText(
                  text: value.toInt().toString(),
                  fontSize: 11,
                  color: textSecondaryColor,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: topLimit > 10
              ? (topLimit / 4).roundToDouble()
              : 2,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: borderColor, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(4, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index],
                color: colors[index],
                width: 28,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: topLimit,
                  color: backgroundColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String desc,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  AppText(text: desc, fontSize: 12, color: textSecondaryColor),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: textSecondaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricData {
  final String title;
  final String count;
  final String subtitle;
  final IconData icon;
  final Color color;

  _MetricData({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
