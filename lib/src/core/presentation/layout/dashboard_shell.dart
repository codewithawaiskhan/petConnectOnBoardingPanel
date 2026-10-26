import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../../constants/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text.dart';

class _NavItemData {
  final int index;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const _NavItemData({
    required this.index,
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}

const List<_NavItemData> _navItems = [
  _NavItemData(
    index: 0,
    title: "Dashboard",
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
  ),
  _NavItemData(
    index: 1,
    title: "Pet Parents",
    icon: Icons.family_restroom_outlined,
    activeIcon: Icons.family_restroom_rounded,
  ),
  _NavItemData(
    index: 2,
    title: "Vets Directory",
    icon: Icons.people_alt_outlined,
    activeIcon: Icons.people_alt_rounded,
  ),
  _NavItemData(
    index: 3,
    title: "Onboard Veterinarian",
    icon: Icons.medical_services_outlined,
    activeIcon: Icons.medical_services_rounded,
  ),
  _NavItemData(
    index: 4,
    title: "Providers Directory",
    icon: Icons.storefront_outlined,
    activeIcon: Icons.storefront_rounded,
  ),
  _NavItemData(
    index: 5,
    title: "Onboard Provider",
    icon: Icons.add_business_outlined,
    activeIcon: Icons.add_business_rounded,
  ),
  _NavItemData(
    index: 6,
    title: "Labs Directory",
    icon: Icons.science_outlined,
    activeIcon: Icons.science_rounded,
  ),
  _NavItemData(
    index: 7,
    title: "Onboard Lab",
    icon: Icons.biotech_outlined,
    activeIcon: Icons.biotech_rounded,
  ),
  _NavItemData(
    index: 8,
    title: "Resource Categories",
    icon: Icons.category_outlined,
    activeIcon: Icons.category_rounded,
  ),
  _NavItemData(
    index: 9,
    title: "Resources",
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
  ),
  _NavItemData(
    index: 10,
    title: "Campaigns",
    icon: Icons.campaign_outlined,
    activeIcon: Icons.campaign_rounded,
  ),
];

class DashboardShell extends StatelessWidget with AppColors {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMedium = width >= 765 && width < 1024;
        final isSmall = width < 765;
        final isCollapsed = isMedium;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: _GlobalTopAppBar(
            currentIndex: navigationShell.currentIndex,
            isSmall: isSmall,
            isMedium: isMedium,
          ),
          drawer: isSmall
              ? _MobileDrawer(navigationShell: navigationShell)
              : null,
          body: Row(
            children: [
              if (!isSmall)
                _DesktopSidebar(
                  navigationShell: navigationShell,
                  isCollapsed: isCollapsed,
                ),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}

class _GlobalTopAppBar extends StatelessWidget
    with AppColors
    implements PreferredSizeWidget {
  final int currentIndex;
  final bool isSmall;
  final bool isMedium;

  const _GlobalTopAppBar({
    required this.currentIndex,
    required this.isSmall,
    required this.isMedium,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  static const List<String> _titles = [
    "Dashboard Overview",
    "Pet Parents Directory",
    "Veterinarians Directory",
    "Onboard Veterinarian",
    "Service Providers Directory",
    "Onboard Provider",
    "Diagnostic Labs Directory",
    "Onboard Lab",
    "Resource Categories",
    "Resources Directory",
    "Campaigns Directory",
  ];

  @override
  Widget build(BuildContext context) {
    final currentTitle = currentIndex < _titles.length
        ? _titles[currentIndex]
        : "PetAccess Portal";

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        bottom: false,
        child: isSmall
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Builder(
                      builder: (scaffoldContext) => IconButton(
                        icon: Icon(
                          Icons.menu_rounded,
                          color: textPrimaryColor,
                          size: 24,
                        ),
                        tooltip: "Open Menu",
                        onPressed: () =>
                            Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppLogo(size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        text: currentTitle,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildAdminUserMenu(context),
                  ],
                ),
              )
            : Row(
                children: [
                  Container(
                    width: isMedium ? 76.0 : 260.0,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMedium ? 16 : 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: borderColor)),
                    ),
                    child: Row(
                      mainAxisAlignment: isMedium
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const AppLogo(size: 34),
                        if (!isMedium) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "PetAccess",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                  maxLines: 1,
                                ),
                                AppText(
                                  text: "PORTAL",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          _buildAdminUserMenu(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAdminUserMenu(BuildContext context) {
    return Consumer<AdminAuthProvider>(
      builder: (context, auth, _) {
        final initial = auth.adminName.isNotEmpty
            ? auth.adminName.substring(0, 1).toUpperCase()
            : "A";

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: primaryColor.withValues(alpha: 0.12),
              child: AppText(
                text: initial,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            if (!isSmall) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: auth.adminName.isNotEmpty
                        ? auth.adminName
                        : auth.adminRole,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                    maxLines: 1,
                  ),
                  AppText(
                    text: auth.adminEmail,
                    fontSize: 11,
                    color: textSecondaryColor,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: textSecondaryColor,
                size: 20,
              ),
              tooltip: "Logout (${auth.adminEmail})",
              onPressed: () => auth.logout(context),
            ),
          ],
        );
      },
    );
  }
}

class _DesktopSidebar extends StatelessWidget with AppColors {
  final StatefulNavigationShell navigationShell;
  final bool isCollapsed;

  const _DesktopSidebar({
    required this.navigationShell,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    final width = isCollapsed ? 76.0 : 260.0;

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
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 10 : 14,
                vertical: 4,
              ),
              itemCount: _navItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = _navItems[index];
                return _buildNavItem(
                  context: context,
                  item: item,
                  isCollapsed: isCollapsed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItemData item,
    required bool isCollapsed,
  }) {
    final isSelected = navigationShell.currentIndex == item.index;

    final itemWidget = InkWell(
      onTap: () => navigationShell.goBranch(
        item.index,
        initialLocation: item.index == navigationShell.currentIndex,
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
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected ? primaryColor : unSelectedIconColor,
                  size: 20,
                ),
              )
            : Row(
                children: [
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: isSelected ? primaryColor : unSelectedIconColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      text: item.title,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? primaryColor : textPrimaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
    );

    if (isCollapsed) {
      return Tooltip(
        message: item.title,
        preferBelow: false,
        child: itemWidget,
      );
    }

    return itemWidget;
  }
}

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
                        text: "PetAccess",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      AppText(
                        text: "OnBoarding Portal",
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _navItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final item = _navItems[index];
                  final isSelected = navigationShell.currentIndex == item.index;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: isSelected
                        ? primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? primaryColor : unSelectedIconColor,
                    ),
                    title: AppText(
                      text: item.title,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? primaryColor : textPrimaryColor,
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(
                        item.index,
                        initialLocation:
                            item.index == navigationShell.currentIndex,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
