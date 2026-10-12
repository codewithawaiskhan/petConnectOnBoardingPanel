import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../../constants/app_colors.dart';
import '../../utils/responsive_extensions.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text.dart';
import 'providers/sidebar_provider.dart';

class DashboardShell extends StatelessWidget with AppColors {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            _DesktopSidebar(navigationShell: navigationShell),
            Expanded(
              child: Column(
                children: [
                  _DesktopTopBar(currentIndex: navigationShell.currentIndex),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildMobileAppBar(context),
      drawer: _MobileDrawer(navigationShell: navigationShell),
      body: navigationShell,
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          const AppLogo(size: 28),
          const SizedBox(width: 10),
          AppText(
            text: "PetConnect Onboarding Portal",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
        ],
      ),
      actions: [
        Consumer<AdminAuthProvider>(
          builder: (context, auth, _) {
            final initial = auth.adminName.isNotEmpty
                ? auth.adminName.substring(0, 1).toUpperCase()
                : "A";
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor,
                child: AppText(
                  text: initial,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: whiteColor,
                ),
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: borderColor, height: 1),
      ),
    );
  }
}

// --- Desktop Top Bar ---
class _DesktopTopBar extends StatelessWidget with AppColors {
  final int currentIndex;

  const _DesktopTopBar({required this.currentIndex});

  static const List<String> _titles = [
    "Dashboard Overview",
    "Veterinarians & Doctors Onboarding",
    "Service Providers Management",
    "Diagnostic Labs & Branches",
  ];

  @override
  Widget build(BuildContext context) {
    final currentTitle =
        currentIndex < _titles.length ? _titles[currentIndex] : "Onboarding Portal";

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    text: "Portal",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: textSecondaryColor,
                    ),
                  ),
                  AppText(
                    text: currentTitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              AppText(
                text: currentTitle,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const Spacer(),
          // Dynamic Admin Profile & Logout
          Consumer<AdminAuthProvider>(
            builder: (context, auth, _) {
              final initial = auth.adminName.isNotEmpty
                  ? auth.adminName.substring(0, 1).toUpperCase()
                  : "A";

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: primaryColor,
                      child: AppText(
                        text: initial,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: auth.adminName,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        AppText(
                          text: auth.adminEmail,
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 24,
                      width: 1,
                      color: borderColor,
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(Icons.logout_rounded, color: textSecondaryColor, size: 18),
                      tooltip: "Logout",
                      splashRadius: 18,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                      onPressed: () => auth.logout(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Desktop Collapsible Sidebar ---
class _DesktopSidebar extends StatelessWidget with AppColors {
  final StatefulNavigationShell navigationShell;

  const _DesktopSidebar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Consumer<SidebarProvider>(
      builder: (context, sidebar, _) {
        final isCollapsed = sidebar.isCollapsed;
        final width = isCollapsed ? 82.0 : 260.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: width,
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border(right: BorderSide(color: borderColor)),
          ),
          child: Column(
            children: [
              // Logo & Collapse Button
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: isCollapsed
                    ? Center(
                        child: InkWell(
                          onTap: sidebar.toggleCollapsed,
                          borderRadius: BorderRadius.circular(8),
                          child: const Tooltip(
                            message: "Expand Sidebar",
                            child: AppLogo(size: 32),
                          ),
                        ),
                      )
                    : ClipRect(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: SizedBox(
                            width: 232,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const AppLogo(size: 36),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: "PetConnect",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimaryColor,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                        ),
                                        AppText(
                                          text: "ONBOARDING PORTAL",
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: textSecondaryColor,
                                    size: 20,
                                  ),
                                  onPressed: sidebar.toggleCollapsed,
                                  tooltip: "Collapse Sidebar",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 10 : 14),
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      title: "Dashboard",
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard_rounded,
                      isCollapsed: isCollapsed,
                    ),
                    const SizedBox(height: 6),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      title: "Doctors / Vets",
                      icon: Icons.medical_services_outlined,
                      activeIcon: Icons.medical_services_rounded,
                      isCollapsed: isCollapsed,
                    ),
                    const SizedBox(height: 6),
                    _buildNavItem(
                      context: context,
                      index: 2,
                      title: "Service Providers",
                      icon: Icons.pets_outlined,
                      activeIcon: Icons.pets_rounded,
                      isCollapsed: isCollapsed,
                    ),
                    const SizedBox(height: 6),
                    _buildNavItem(
                      context: context,
                      index: 3,
                      title: "Diagnostic Labs",
                      icon: Icons.biotech_outlined,
                      activeIcon: Icons.biotech_rounded,
                      isCollapsed: isCollapsed,
                    ),
                  ],
                ),
              ),
              // Bottom Status / Logout with dynamic Admin details
              Consumer<AdminAuthProvider>(
                builder: (context, auth, _) {
                  final initial = auth.adminName.isNotEmpty
                      ? auth.adminName.substring(0, 1).toUpperCase()
                      : "A";

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCollapsed ? 10 : 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: borderColor)),
                    ),
                    child: isCollapsed
                        ? Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              icon: Icon(
                                Icons.logout_rounded,
                                color: textSecondaryColor,
                                size: 20,
                              ),
                              tooltip: "Logout (${auth.adminEmail})",
                              onPressed: () => auth.logout(context),
                            ),
                          )
                        : ClipRect(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                width: 232,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: primaryColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      child: AppText(
                                        text: initial,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppText(
                                            text: auth.adminRole,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimaryColor,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                          AppText(
                                            text: auth.adminEmail,
                                            fontSize: 11,
                                            color: textSecondaryColor,
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 28,
                                        minHeight: 28,
                                      ),
                                      icon: Icon(
                                        Icons.logout_rounded,
                                        color: textSecondaryColor,
                                        size: 18,
                                      ),
                                      tooltip: "Logout",
                                      onPressed: () => auth.logout(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required IconData activeIcon,
    required bool isCollapsed,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    final itemWidget = InkWell(
      onTap: () => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 12 : 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: primaryColor.withValues(alpha: 0.2))
              : null,
        ),
        child: isCollapsed
            ? Center(
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? primaryColor : unSelectedIconColor,
                  size: 20,
                ),
              )
            : ClipRect(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: 204,
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? activeIcon : icon,
                          color: isSelected
                              ? primaryColor
                              : unSelectedIconColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppText(
                            text: title,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? primaryColor : textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(message: title, preferBelow: false, child: itemWidget);
    }

    return itemWidget;
  }
}

// --- Mobile Drawer ---
class _MobileDrawer extends StatelessWidget with AppColors {
  final StatefulNavigationShell navigationShell;

  const _MobileDrawer({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  const AppLogo(size: 38),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "PetConnect",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      AppText(
                        text: "Onboarding Portal",
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildDrawerItem(
                    context,
                    0,
                    "Dashboard",
                    Icons.dashboard_outlined,
                    Icons.dashboard_rounded,
                  ),
                  _buildDrawerItem(
                    context,
                    1,
                    "Doctors / Vets",
                    Icons.medical_services_outlined,
                    Icons.medical_services_rounded,
                  ),
                  _buildDrawerItem(
                    context,
                    2,
                    "Service Providers",
                    Icons.pets_outlined,
                    Icons.pets_rounded,
                  ),
                  _buildDrawerItem(
                    context,
                    3,
                    "Diagnostic Labs",
                    Icons.biotech_outlined,
                    Icons.biotech_rounded,
                  ),
                ],
              ),
            ),
            // Mobile Drawer Bottom Admin Tile & Logout
            Consumer<AdminAuthProvider>(
              builder: (context, auth, _) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor.withValues(alpha: 0.12),
                        child: AppText(
                          text: auth.adminName.isNotEmpty
                              ? auth.adminName.substring(0, 1).toUpperCase()
                              : "A",
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
                              text: auth.adminName,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                            AppText(
                              text: auth.adminEmail,
                              fontSize: 11,
                              color: textSecondaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.logout_rounded,
                          color: textSecondaryColor,
                          size: 20,
                        ),
                        tooltip: "Logout",
                        onPressed: () {
                          Navigator.pop(context);
                          auth.logout(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    int index,
    String title,
    IconData icon,
    IconData activeIcon,
  ) {
    final isSelected = navigationShell.currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected
            ? primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? primaryColor : unSelectedIconColor,
        ),
        title: AppText(
          text: title,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? primaryColor : textPrimaryColor,
        ),
        onTap: () {
          Navigator.pop(context); // close drawer
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}
