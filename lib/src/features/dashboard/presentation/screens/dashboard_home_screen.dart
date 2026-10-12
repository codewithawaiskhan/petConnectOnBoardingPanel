import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';

class DashboardHomeScreen extends StatelessWidget with AppColors {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.isDesktop ? 32 : 16,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context),
            const SizedBox(height: 24),
            _buildMetricsGrid(context),
            const SizedBox(height: 28),
            _buildQuickActionsAndRecentSection(context),
            const SizedBox(height: 40),
          ],
        ),
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
          colors: [
            primaryColor.withValues(alpha: 0.08),
            whiteColor,
          ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  text: "Manage provider verifications, onboard medical veterinarians, and oversee clinical lab branches.",
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

  Widget _buildMetricsGrid(BuildContext context) {
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
            count: "128",
            subtitle: "+12 this month",
            icon: Icons.medical_services_rounded,
            color: primaryColor,
          ),
          _MetricData(
            title: "Service Providers",
            count: "64",
            subtitle: "+5 active facilities",
            icon: Icons.pets_rounded,
            color: skyBlueColor,
          ),
          _MetricData(
            title: "Diagnostic Labs",
            count: "32",
            subtitle: "3 branches pending",
            icon: Icons.biotech_rounded,
            color: tertiaryColor,
          ),
          _MetricData(
            title: "Pending Verifications",
            count: "18",
            subtitle: "Requires action",
            icon: Icons.verified_user_outlined,
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

  Widget _buildQuickActionsAndRecentSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTwoColumn = constraints.maxWidth > 800;

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
                onTap: () => context.go('/labs'),
              ),
            ],
          ),
        );

        final recentActivity = Container(
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
                text: "Recent Applications",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: "Latest verification submissions",
                fontSize: 12,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 18),
              _buildRecentItem(
                name: "Dr. Bryan Clarke",
                role: "Veterinary Specialist (DVM)",
                status: "Pending Review",
                statusColor: yellowColor,
              ),
              const Divider(height: 18),
              _buildRecentItem(
                name: "Infinite Labs (Head Office)",
                role: "Diagnostic Laboratory",
                status: "Approved",
                statusColor: successColor,
              ),
              const Divider(height: 18),
              _buildRecentItem(
                name: "Melissa Monroe",
                role: "Service Provider (Care)",
                status: "Pending Review",
                statusColor: yellowColor,
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
              Expanded(flex: 3, child: recentActivity),
            ],
          );
        } else {
          return Column(
            children: [
              quickActions,
              const SizedBox(height: 20),
              recentActivity,
            ],
          );
        }
      },
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
                  AppText(
                    text: desc,
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem({
    required String name,
    required String role,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: primaryColor.withValues(alpha: 0.1),
          child: AppText(
            text: name.substring(0, 1),
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: name,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              AppText(text: role, fontSize: 11, color: textSecondaryColor),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            text: status,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ],
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
