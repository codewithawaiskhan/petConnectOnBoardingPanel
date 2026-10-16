import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../dialogs/edit_pet_parent_dialog.dart';
import '../providers/pet_parents_list_provider.dart';

class PetParentsListScreen extends StatefulWidget {
  const PetParentsListScreen({super.key});

  @override
  State<PetParentsListScreen> createState() => _PetParentsListScreenState();
}

class _PetParentsListScreenState extends State<PetParentsListScreen>
    with AppColors {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PetParentsListProvider>();
      if (provider.petParents.isEmpty) {
        provider.fetchPetParents(isRefresh: true);
      }
    });
  }

  void _onSearchInputChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchInputChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<PetParentsListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchPetParents(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildSearchBar(provider, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final tableW = constraints.maxWidth > 850
                            ? constraints.maxWidth
                            : 850.0;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableW,
                            child: DataTableShimmer(
                              isDesktop: isDesktop,
                              columnWidths: const {
                                0: FlexColumnWidth(1.2),
                                1: FlexColumnWidth(2.5),
                                2: FlexColumnWidth(2.5),
                                3: FlexColumnWidth(1.8),
                                4: FlexColumnWidth(1.0),
                                5: FlexColumnWidth(1.2),
                              },
                              headers: const [
                                "ID",
                                "PET PARENT",
                                "CONTACT & EMAIL",
                                "LOCATION",
                                "STATUS",
                                "ACTIONS",
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else if (provider.errorMessage != null &&
                      provider.petParents.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.petParents.isEmpty)
                    _buildEmptyState()
                  else ...[
                    if (provider.isPaginationLoading)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final tableW = constraints.maxWidth > 850
                              ? constraints.maxWidth
                              : 850.0;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: tableW,
                              child: DataTableShimmer(
                                isDesktop: isDesktop,
                                columnWidths: const {
                                  0: FlexColumnWidth(1.2),
                                  1: FlexColumnWidth(2.5),
                                  2: FlexColumnWidth(2.5),
                                  3: FlexColumnWidth(1.8),
                                  4: FlexColumnWidth(1.0),
                                  5: FlexColumnWidth(1.2),
                                },
                                headers: const [
                                  "ID",
                                  "PET PARENT",
                                  "CONTACT & EMAIL",
                                  "LOCATION",
                                  "STATUS",
                                  "ACTIONS",
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else if (isDesktop)
                      _buildDesktopDataTable(provider)
                    else
                      _buildMobileList(provider),
                    const SizedBox(height: 24),
                    _buildPaginationControls(provider, isDesktop),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(PetParentsListProvider provider, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Pet Parents Directory",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      text: "Total Registered: ${provider.totalDocs}",
                      fontSize: 13,
                      color: textSecondaryColor,
                    ),
                  ),
                  CustomButton(
                    text: "Refresh",
                    isIcon: true,
                    icon: Icon(Icons.refresh_rounded, size: 16, color: whiteColor),
                    height: 34,
                    fontSize: 12,
                    radius: 8,
                    onTap: () => provider.fetchPetParents(isRefresh: true),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Pet Parents Directory",
                    fontSize: isDesktop ? 22 : 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: "Total Registered Pet Parents: ${provider.totalDocs}",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                ],
              ),
            ),
            CustomButton(
              text: "Refresh",
              isIcon: true,
              icon: Icon(Icons.refresh_rounded, size: 16, color: whiteColor),
              height: 38,
              radius: 8,
              onTap: () => provider.fetchPetParents(isRefresh: true),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(PetParentsListProvider provider, bool isDesktop) {
    final hasSearchText = _searchController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _searchController,
              hintText: "Search pet parents by full name or email...",
              prefixIcon: Icon(
                Icons.search_rounded,
                color: textSecondaryColor,
                size: 20,
              ),
              suffixIcon: hasSearchText
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: textSecondaryColor,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        provider.onSearchChanged('', immediate: true);
                      },
                    )
                  : null,
              onChanged: (val) => provider.onSearchChanged(val),
            ),
          ),
          const SizedBox(width: 12),
          CustomButton(
            text: "Search",
            height: 44,
            width: isDesktop ? 100 : 85,
            radius: 8,
            fillColor: hasSearchText ? primaryColor : borderColor,
            textColor: hasSearchText ? whiteColor : textSecondaryColor,
            onTap: hasSearchText
                ? () => provider.onSearchChanged(
                      _searchController.text,
                      immediate: true,
                    )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDataTable(PetParentsListProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth =
            constraints.maxWidth > 900 ? constraints.maxWidth : 900.0;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: tableWidth,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    color: backgroundColor,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: AppText(
                            text: "ID",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: AppText(
                            text: "PET PARENT",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: AppText(
                            text: "CONTACT & EMAIL",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AppText(
                            text: "LOCATION",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: AppText(
                            text: "STATUS",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: AppText(
                            text: "ACTIONS",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textSecondaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.petParents.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, thickness: 1),
                    itemBuilder: (context, index) {
                      final parent = provider.petParents[index];
                      return _buildTableRow(context, parent);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableRow(BuildContext context, PetParentItemEntity parent) {
    final displayName = parent.fullName?.trim().isNotEmpty == true
        ? parent.fullName!.trim()
        : "Not Provided";
    final initial = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : "P";
    final displayId =
        parent.longAutoIncrementId ??
        (parent.autoIncrementId != null ? "#${parent.autoIncrementId}" : "N/A");
    final displayEmail = parent.email?.trim().isNotEmpty == true
        ? parent.email!.trim()
        : "Not Provided";
    final displayPhone = parent.phone?.trim().isNotEmpty == true
        ? parent.phone!.trim()
        : "Not Provided";
    final locationParts = [
      if (parent.city?.trim().isNotEmpty == true) parent.city!.trim(),
      if (parent.countryName?.trim().isNotEmpty == true)
        parent.countryName!.trim()
      else if (parent.countryCode?.trim().isNotEmpty == true)
        parent.countryCode!.trim(),
    ];
    final displayLocation = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : "Not Provided";
    final status = parent.user?.status ?? "Active";

    return InkWell(
      onTap: () => context.go('/pet-parents/${parent.id}'),
      hoverColor: primaryColor.withValues(alpha: 0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      text: displayId,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: AppText(
                      text: initial,
                      fontSize: 13,
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
                          text: displayName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (parent.id.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          AppText(
                            text: "id: ${parent.id}",
                            fontSize: 11,
                            color: textSecondaryColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 13,
                        color: textSecondaryColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppText(
                          text: displayEmail,
                          fontSize: 13,
                          color: textPrimaryColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: textSecondaryColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppText(
                          text: displayPhone,
                          fontSize: 12,
                          color: textSecondaryColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppText(
                      text: displayLocation,
                      fontSize: 13,
                      color: textPrimaryColor,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Center(
                child: StatusBadge(
                  status: status,
                  isDeleted: parent.isDeleted,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: primaryColor,
                    ),
                    tooltip: "View Details",
                    splashRadius: 18,
                    onPressed: () => context.go('/pet-parents/${parent.id}'),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: textSecondaryColor,
                    ),
                    tooltip: "Edit Pet Parent",
                    splashRadius: 18,
                    onPressed: () => _showEditPetParentDialog(parent),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: errorColor,
                    ),
                    tooltip: "Delete Pet Parent",
                    splashRadius: 18,
                    onPressed: () => _showDeleteConfirmationDialog(parent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(PetParentsListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.petParents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final parent = provider.petParents[index];
        final displayName = parent.fullName?.trim().isNotEmpty == true
            ? parent.fullName!.trim()
            : "Not Provided";
        final initial = displayName.isNotEmpty
            ? displayName.substring(0, 1).toUpperCase()
            : "P";
        final displayId =
            parent.longAutoIncrementId ??
            (parent.autoIncrementId != null
                ? "#${parent.autoIncrementId}"
                : "N/A");
        final displayEmail = parent.email?.trim().isNotEmpty == true
            ? parent.email!.trim()
            : "Not Provided";
        final displayPhone = parent.phone?.trim().isNotEmpty == true
            ? parent.phone!.trim()
            : "Not Provided";

        return InkWell(
          onTap: () => context.go('/pet-parents/${parent.id}'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: AppText(
                        text: initial,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              AppText(
                                text: displayName,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  StatusBadge(
                                    status: parent.user?.status ?? "Active",
                                    isDeleted: parent.isDeleted,
                                    fontSize: 10,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AppText(
                                      text: displayId,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            text: displayEmail,
                            fontSize: 13,
                            color: textSecondaryColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText(
                        text: displayPhone,
                        fontSize: 12,
                        color: textSecondaryColor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "View Profile",
                      isOutlined: true,
                      height: 32,
                      fontSize: 12,
                      radius: 6,
                      onTap: () => context.go('/pet-parents/${parent.id}'),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.visibility_outlined,
                            size: 18,
                            color: primaryColor,
                          ),
                          tooltip: "View Details",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () =>
                              context.go('/pet-parents/${parent.id}'),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: textSecondaryColor,
                          ),
                          tooltip: "Edit Pet Parent",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () => _showEditPetParentDialog(parent),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: errorColor,
                          ),
                          tooltip: "Delete Pet Parent",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () =>
                              _showDeleteConfirmationDialog(parent),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(
    PetParentsListProvider provider,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 640;

          final infoAndDropdown = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              AppText(
                text:
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} pet parents)",
                fontFamily: fontPoppins,
                fontSize: 12,
                color: textSecondaryColor,
              ),
              ItemsPerPageDropdown(
                currentLimit: provider.limit,
                isEnabled: !provider.isPaginationLoading && !provider.isLoading,
                onLimitChanged: (newLimit) => provider.setLimit(newLimit),
              ),
            ],
          );

          final pagination = BootstrapPagination(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            isEnabled: !provider.isPaginationLoading && !provider.isLoading,
            onPageChanged: (page) => provider.goToPage(page),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                infoAndDropdown,
                const SizedBox(height: 12),
                pagination,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              infoAndDropdown,
              pagination,
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(PetParentsListProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 14),
          AppText(
            text: "Failed to Load Pet Parents",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: provider.errorMessage ?? "An unexpected error occurred.",
            fontSize: 13,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Retry",
            width: 120,
            height: 38,
            radius: 8,
            onTap: () => provider.fetchPetParents(isRefresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 48,
            color: textSecondaryColor,
          ),
          const SizedBox(height: 14),
          AppText(
            text: "No Pet Parents Found",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: "There are no pet parents matching the search criteria.",
            fontSize: 13,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _showEditPetParentDialog(PetParentItemEntity parent) async {
    final updated = await EditPetParentDialog.show(context, parent: parent);
    if (!mounted) return;
    if (updated == true) {
      context.read<PetParentsListProvider>().fetchPetParents(isRefresh: true);
    }
  }

  void _showDeleteConfirmationDialog(PetParentItemEntity parent) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Pet Parent",
      message:
          "Are you sure you want to delete ${parent.fullName?.trim().isNotEmpty == true ? parent.fullName : 'this pet parent'}?",
      confirmText: "Delete",
      onConfirm: () async {
        if (!mounted) return;
        final provider = context.read<PetParentsListProvider>();
        await provider.deletePetParent(context: context, id: parent.id);
      },
    );
  }
}
