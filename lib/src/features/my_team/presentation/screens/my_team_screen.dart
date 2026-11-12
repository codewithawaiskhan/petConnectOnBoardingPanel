import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../dialogs/request_influencer_dialog.dart';
import '../providers/my_team_provider.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> with AppColors {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MyTeamProvider>();
      if (provider.influencers.isEmpty) {
        provider.fetchInfluencers(isRefresh: true);
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

  String _formatDate(String dateStr) {
    if (dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<MyTeamProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchInfluencers(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildFilterBar(provider),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    _buildTableShimmer(isDesktop)
                  else if (provider.errorMessage != null &&
                      provider.influencers.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.influencers.isEmpty)
                    _buildEmptyState(provider)
                  else ...[
                    if (provider.isPaginationLoading)
                      _buildTableShimmer(isDesktop)
                    else if (isDesktop)
                      _buildDesktopDataTable(provider)
                    else
                      _buildMobileList(provider),
                    const SizedBox(height: 24),
                    _buildPaginationControls(provider),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableShimmer(bool isDesktop) {
    return DataTableShimmer(
      isDesktop: isDesktop,
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2.2),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.4),
      },
      headers: const [
        "Influencer Name",
        "Email",
        "Referral Code",
        "Status",
        "Joined Date",
      ],
    );
  }

  Widget _buildHeader(MyTeamProvider provider, bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "My Team",
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: "Total Influencers: ${provider.totalDocs}",
                  fontSize: 13,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: "Refresh",
                isOutlined: true,
                isIcon: true,
                icon: Icon(Icons.refresh_rounded, size: 16, color: primaryColor),
                height: 38,
                radius: 8,
                onTap: () => provider.fetchInfluencers(isRefresh: true),
              ),
              const SizedBox(width: 10),
              CustomButton(
                text: "Add Influencer",
                isIcon: true,
                icon: Icon(Icons.add_rounded, size: 18, color: whiteColor),
                height: 38,
                radius: 8,
                onTap: () => RequestInfluencerDialog.show(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(MyTeamProvider provider) {
    final hasSearchText = _searchController.text.trim().isNotEmpty;

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
                  hintText: "Search influencer by name or email...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                  suffixIcon: hasSearchText
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: textSecondaryColor,
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
                width: 100,
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

  Widget _buildDesktopDataTable(MyTeamProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(backgroundColor),
                headingTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textSecondaryColor,
                ),
                dataRowMinHeight: 62,
                dataRowMaxHeight: 70,
                columnSpacing: 24,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: AppText(
                      text: "Influencer Name",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Email",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Referral Code",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Status",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Joined Date",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
                rows: provider.influencers.map((influencer) {
                  final initial = influencer.fullName.isNotEmpty
                      ? influencer.fullName.substring(0, 1).toUpperCase()
                      : "I";

                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryColor.withValues(
                                alpha: 0.12,
                              ),
                              child: AppText(
                                text: initial,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  text: influencer.fullName.isNotEmpty
                                      ? influencer.fullName
                                      : "—",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                                if (influencer.username != null &&
                                    influencer.username!.isNotEmpty)
                                  AppText(
                                    text: "@${influencer.username}",
                                    fontSize: 11,
                                    color: textSecondaryColor,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        AppText(
                          text: influencer.email.isNotEmpty
                              ? influencer.email
                              : "—",
                          fontSize: 12,
                          color: textPrimaryColor,
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                          ),
                          child: AppText(
                            text: influencer.longAutoIncrementId.isNotEmpty
                                ? influencer.longAutoIncrementId
                                : "#${influencer.autoIncrementId}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      DataCell(
                        StatusBadge(status: influencer.status),
                      ),
                      DataCell(
                        AppText(
                          text: _formatDate(influencer.createdAt),
                          fontSize: 12,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileList(MyTeamProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.influencers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final influencer = provider.influencers[index];
        final initial = influencer.fullName.isNotEmpty
            ? influencer.fullName.substring(0, 1).toUpperCase()
            : "I";

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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryColor.withValues(alpha: 0.12),
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
                        AppText(
                          text: influencer.fullName.isNotEmpty
                              ? influencer.fullName
                              : "—",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        AppText(
                          text: influencer.longAutoIncrementId.isNotEmpty
                              ? influencer.longAutoIncrementId
                              : "#${influencer.autoIncrementId}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: influencer.status),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      text: influencer.email.isNotEmpty
                          ? influencer.email
                          : "—",
                      fontSize: 12,
                      color: textSecondaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppText(
                    text: _formatDate(influencer.createdAt),
                    fontSize: 12,
                    color: textPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(MyTeamProvider provider) {
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
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} influencers)",
                fontFamily: fontPoppins,
                fontSize: 12,
                color: textSecondaryColor,
              ),
              ItemsPerPageDropdown(
                currentLimit: provider.limit,
                isEnabled:
                    !provider.isPaginationLoading && !provider.isLoading,
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

  Widget _buildErrorState(MyTeamProvider provider) {
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
            text: provider.errorMessage ?? "Failed to load influencers",
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
            onTap: () => provider.fetchInfluencers(isRefresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(MyTeamProvider provider) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups_outlined,
            color: textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No influencers in your team yet",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: provider.hasActiveFilters
                ? "Try adjusting your search query or status filter."
                : "Click 'Add Influencer' to send an assignment request.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

