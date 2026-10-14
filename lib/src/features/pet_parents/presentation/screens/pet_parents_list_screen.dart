import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/pet_parent_entity.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PetParentsListProvider>();
      if (provider.petParents.isEmpty) {
        provider.fetchPetParents(isRefresh: true);
      }
    });
  }

  @override
  void dispose() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildSearchBar(provider, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    DataTableShimmer(
                      isDesktop: isDesktop,
                      columnWidths: const {
                        0: FlexColumnWidth(2.5),
                        1: FlexColumnWidth(2.5),
                        2: FlexColumnWidth(1.8),
                        3: FlexColumnWidth(1.0),
                        4: FlexColumnWidth(1.0),
                        5: FlexColumnWidth(0.8),
                      },
                      headers: const [
                        "PET PARENT",
                        "CONTACT & EMAIL",
                        "LOCATION",
                        "BOOKINGS",
                        "STATUS",
                        "ACTION",
                      ],
                    )
                  else if (provider.errorMessage != null &&
                      provider.petParents.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.petParents.isEmpty)
                    _buildEmptyState()
                  else ...[
                    if (isDesktop)
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
  }

  Widget _buildSearchBar(PetParentsListProvider provider, bool isDesktop) {
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
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: textSecondaryColor,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        provider.onSearchChanged('');
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
            width: 100,
            radius: 8,
            onTap: () => provider.onSearchChanged(_searchController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDataTable(PetParentsListProvider provider) {
    return Container(
      width: double.infinity,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      text: "BOOKINGS",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                      textAlign: TextAlign.center,
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
                  const SizedBox(
                    width: 60,
                    child: Center(
                      child: Icon(Icons.more_horiz_rounded, size: 18),
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
    );
  }

  Widget _buildTableRow(BuildContext context, PetParentItemEntity parent) {
    final displayName =
        parent.fullName?.trim().isNotEmpty == true
            ? parent.fullName!.trim()
            : "Not Provided";
    final initial =
        displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : "P";
    final displayId =
        parent.longAutoIncrementId ??
        (parent.autoIncrementId != null ? "#${parent.autoIncrementId}" : "N/A");
    final displayEmail =
        parent.email?.trim().isNotEmpty == true
            ? parent.email!.trim()
            : "Not Provided";
    final displayPhone =
        parent.phone?.trim().isNotEmpty == true
            ? parent.phone!.trim()
            : "Not Provided";
    final locationParts = [
      if (parent.city?.trim().isNotEmpty == true) parent.city!.trim(),
      if (parent.countryName?.trim().isNotEmpty == true)
        parent.countryName!.trim()
      else if (parent.countryCode?.trim().isNotEmpty == true)
        parent.countryCode!.trim(),
    ];
    final displayLocation =
        locationParts.isNotEmpty ? locationParts.join(', ') : "Not Provided";
    final status = parent.user?.status ?? "Active";

    return InkWell(
      onTap: () => context.push('/pet-parents/${parent.id}'),
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
                        if (parent.wallet != null &&
                            parent.wallet!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          AppText(
                            text: "Wallet: ${parent.wallet}",
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          text: "${parent.appointmentsBookedCount}",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.biotech_outlined,
                          size: 12,
                          color: tertiaryColor,
                        ),
                        const SizedBox(width: 2),
                        AppText(
                          text: "${parent.labTestsBookedCount}",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tertiaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: status,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: successColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: textSecondaryColor,
                ),
                tooltip: "View Details",
                onPressed: () => context.push('/pet-parents/${parent.id}'),
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
        final displayName =
            parent.fullName?.trim().isNotEmpty == true
                ? parent.fullName!.trim()
                : "Not Provided";
        final initial =
            displayName.isNotEmpty
                ? displayName.substring(0, 1).toUpperCase()
                : "P";
        final displayId =
            parent.longAutoIncrementId ??
            (parent.autoIncrementId != null
                ? "#${parent.autoIncrementId}"
                : "N/A");
        final displayEmail =
            parent.email?.trim().isNotEmpty == true
                ? parent.email!.trim()
                : "Not Provided";
        final displayPhone =
            parent.phone?.trim().isNotEmpty == true
                ? parent.phone!.trim()
                : "Not Provided";

        return InkWell(
          onTap: () => context.push('/pet-parents/${parent.id}'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppText(
                                  text: displayName,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.08),
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
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
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
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          text: "${parent.appointmentsBookedCount}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.biotech_outlined,
                          size: 13,
                          color: tertiaryColor,
                        ),
                        const SizedBox(width: 2),
                        AppText(
                          text: "${parent.labTestsBookedCount}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: tertiaryColor,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText(
              text:
                  "Showing page ${provider.currentPage} of ${provider.totalPages} (${provider.totalDocs} pet parents)",
              fontSize: 13,
              color: textSecondaryColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                label: isDesktop
                    ? AppText(text: "Previous", fontSize: 13)
                    : const SizedBox.shrink(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textPrimaryColor,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: provider.currentPage > 1
                    ? () => provider.previousPage()
                    : null,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                label: isDesktop
                    ? AppText(text: "Next", fontSize: 13)
                    : const SizedBox.shrink(),
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textPrimaryColor,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: provider.currentPage < provider.totalPages
                    ? () => provider.nextPage()
                    : null,
              ),
            ],
          ),
        ],
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
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
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
}
