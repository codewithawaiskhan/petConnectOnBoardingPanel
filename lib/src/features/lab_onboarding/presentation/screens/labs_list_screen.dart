import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/lab_entity.dart';
import '../providers/labs_list_provider.dart';

class LabsListScreen extends StatefulWidget {
  const LabsListScreen({super.key});

  @override
  State<LabsListScreen> createState() => _LabsListScreenState();
}

class _LabsListScreenState extends State<LabsListScreen> with AppColors {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LabsListProvider>();
      if (provider.labs.isEmpty) {
        provider.fetchLabs(isRefresh: true);
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
      body: Consumer<LabsListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchLabs(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildFilterBar(provider, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    DataTableShimmer(
                      isDesktop: isDesktop,
                      columnWidths: const {
                        0: FlexColumnWidth(2.2),
                        1: FlexColumnWidth(2.0),
                        2: FlexColumnWidth(1.6),
                        3: FlexColumnWidth(1.8),
                        4: FlexColumnWidth(1.0),
                        5: FlexColumnWidth(0.8),
                      },
                      headers: const [
                        "Lab Name",
                        "Contact Info",
                        "Type / Designation",
                        "Location",
                        "Status",
                        "Action",
                      ],
                    )
                  else if (provider.errorMessage != null &&
                      provider.labs.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.labs.isEmpty)
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

  Widget _buildHeader(LabsListProvider provider, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Diagnostic Labs Directory",
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: "Total Diagnostic Labs: ${provider.totalDocs}",
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
          onTap: () => provider.fetchLabs(isRefresh: true),
        ),
      ],
    );
  }

  Widget _buildFilterBar(LabsListProvider provider, bool isDesktop) {
    return Container(
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
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _searchController,
                  hintText: "Search lab by title, email, city...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: textSecondaryColor,
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
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.statusFilters.map((status) {
                final isSelected = provider.selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => provider.onStatusChanged(status),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : primaryColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primaryColor : borderColor,
                        ),
                      ),
                      child: AppText(
                        text: status,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? whiteColor : textPrimaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDataTable(LabsListProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2.2),
            1: FlexColumnWidth(2.0),
            2: FlexColumnWidth(1.6),
            3: FlexColumnWidth(1.8),
            4: FlexColumnWidth(1.0),
            5: FlexColumnWidth(0.8),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: backgroundColor),
              children: [
                _buildHeaderCell("Lab Name"),
                _buildHeaderCell("Contact Info"),
                _buildHeaderCell("Type / Designation"),
                _buildHeaderCell("Location"),
                _buildHeaderCell("Status"),
                _buildHeaderCell("Action"),
              ],
            ),
            ...provider.labs.map((lab) {
              return TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                children: [
                  _buildLabNameCell(lab),
                  _buildContactCell(lab),
                  _buildTypeCell(lab),
                  _buildLocationCell(lab),
                  _buildStatusCell(lab.status),
                  _buildActionCell(lab),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: textSecondaryColor,
      ),
    );
  }

  Widget _buildLabNameCell(LabItemEntity lab) {
    final initial = lab.title.isNotEmpty
        ? lab.title.substring(0, 1).toUpperCase()
        : "L";

    return InkWell(
      onTap: () => context.push('/labs/${lab.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: tertiaryColor.withValues(alpha: 0.14),
              child: AppText(
                text: initial,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tertiaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: lab.title,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lab.labTestCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: AppText(
                        text:
                            "${lab.labTestCategories.length} Test Categor${lab.labTestCategories.length > 1 ? 'ies' : 'y'}",
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCell(LabItemEntity lab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.mail_outline_rounded, size: 14, color: textSecondaryColor),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  text: lab.email,
                  fontSize: 12,
                  color: textPrimaryColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (lab.phone != null && lab.phone!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 14, color: textSecondaryColor),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text: lab.phone!,
                    fontSize: 11,
                    color: textSecondaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeCell(LabItemEntity lab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: lab.labType ?? "Diagnostic Lab",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (lab.designation != null && lab.designation!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AppText(
                text: lab.designation!,
                fontSize: 11,
                color: textSecondaryColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationCell(LabItemEntity lab) {
    final locationParts = [
      if (lab.address != null && lab.address!.isNotEmpty) lab.address!,
      if (lab.city != null && lab.city!.isNotEmpty) lab.city!,
      if (lab.state != null && lab.state!.isNotEmpty) lab.state!,
    ].join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 14, color: textSecondaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: AppText(
              text: locationParts.isNotEmpty ? locationParts : "Not specified",
              fontSize: 12,
              color: locationParts.isNotEmpty ? textPrimaryColor : textSecondaryColor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color badgeColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        badgeColor = successColor.withValues(alpha: 0.12);
        textColor = successColor;
        break;
      case 'declined':
      case 'rejected':
        badgeColor = errorColor.withValues(alpha: 0.12);
        textColor = errorColor;
        break;
      case 'pending':
      default:
        badgeColor = yellowColor.withValues(alpha: 0.15);
        textColor = yellowColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            text: status,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCell(LabItemEntity lab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: IconButton(
        icon: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryColor),
        tooltip: "View Details",
        onPressed: () => context.push('/labs/${lab.id}'),
      ),
    );
  }

  Widget _buildMobileList(LabsListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.labs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lab = provider.labs[index];
        final initial = lab.title.isNotEmpty
            ? lab.title.substring(0, 1).toUpperCase()
            : "L";

        return InkWell(
          onTap: () => context.push('/labs/${lab.id}'),
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
                      backgroundColor: tertiaryColor.withValues(alpha: 0.14),
                      child: AppText(
                        text: initial,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: tertiaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: lab.title,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: lab.labType ?? "Diagnostic Lab",
                            fontSize: 12,
                            color: textSecondaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusCell(lab.status),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Icon(Icons.mail_outline_rounded, size: 14, color: textSecondaryColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText(
                        text: lab.email,
                        fontSize: 12,
                        color: textSecondaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (lab.city != null && lab.city!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: textSecondaryColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppText(
                          text: lab.city!,
                          fontSize: 12,
                          color: textSecondaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(LabsListProvider provider, bool isDesktop) {
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
          AppText(
            text:
                "Page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1}",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed:
                    provider.currentPage > 1 && !provider.isPaginationLoading
                        ? provider.previousPage
                        : null,
                tooltip: "Previous Page",
              ),
              const SizedBox(width: 8),
              if (provider.isPaginationLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              else
                AppText(
                  text: "${provider.currentPage}",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed:
                    provider.currentPage < provider.totalPages &&
                            !provider.isPaginationLoading
                        ? provider.nextPage
                        : null,
                tooltip: "Next Page",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(LabsListProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
          const SizedBox(height: 12),
          AppText(
            text: "Failed to load diagnostic labs",
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
          const SizedBox(height: 16),
          CustomButton(
            text: "Try Again",
            width: 120,
            height: 38,
            radius: 8,
            onTap: () => provider.fetchLabs(isRefresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.biotech_outlined, size: 48, color: textSecondaryColor),
          const SizedBox(height: 14),
          AppText(
            text: "No Diagnostic Labs Found",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: "There are no labs matching the current criteria or status filter.",
            fontSize: 13,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
