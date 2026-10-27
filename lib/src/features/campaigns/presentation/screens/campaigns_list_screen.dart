import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/campaign_entity.dart';
import '../dialogs/add_edit_campaign_dialog.dart';
import '../dialogs/campaign_detail_dialog.dart';
import '../providers/campaign_provider.dart';

class CampaignsListScreen extends StatefulWidget {
  const CampaignsListScreen({super.key});

  @override
  State<CampaignsListScreen> createState() => _CampaignsListScreenState();
}

class _CampaignsListScreenState extends State<CampaignsListScreen>
    with AppColors, Constants {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  Timer? _debounce;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CampaignProvider>();
      if (provider.campaigns.isEmpty) {
        provider.fetchCampaigns(isRefresh: true);
      }
    });
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<CampaignProvider>().setSearchKeyword(
          _searchController.text.trim(),
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _selectFromDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromController.text.isNotEmpty
          ? (DateTime.tryParse(_fromController.text) ?? now)
          : now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      final formatted = _dateFormat.format(picked);
      _fromController.text = formatted;
      if (mounted) {
        context.read<CampaignProvider>().setDateRange(
          from: formatted,
          to: _toController.text.trim().isNotEmpty
              ? _toController.text.trim()
              : null,
        );
      }
    }
  }

  Future<void> _selectToDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _toController.text.isNotEmpty
          ? (DateTime.tryParse(_toController.text) ?? now)
          : now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      final formatted = _dateFormat.format(picked);
      _toController.text = formatted;
      if (mounted) {
        context.read<CampaignProvider>().setDateRange(
          from: _fromController.text.trim().isNotEmpty
              ? _fromController.text.trim()
              : null,
          to: formatted,
        );
      }
    }
  }

  bool _isOneTimeCampaign(CampaignEntity campaign) {
    final freq = campaign.frequency.trim().toLowerCase();
    return freq == 'onetime' ||
        freq == 'one-time' ||
        freq == 'one_time' ||
        freq == 'once';
  }

  void _showOneTimeCampaignCannotEditDialog() {
    DialogUtils.showDynamicInfoDialog(
      context: context,
      title: "Cannot Edit Campaign",
      message:
          "One-time broadcast campaigns cannot be modified after creation, as they are processed and dispatched immediately to recipients. If you need to make changes, please create a new campaign.",
      buttonText: "Understood",
    );
  }

  void _openAddEditDialog([CampaignEntity? campaign]) {
    if (campaign != null && _isOneTimeCampaign(campaign)) {
      _showOneTimeCampaignCannotEditDialog();
      return;
    }
    AddEditCampaignDialog.show(context, campaign: campaign);
  }

  void _openDetailDialog(CampaignEntity campaign) {
    CampaignDetailDialog.show(context, campaign);
  }

  void _confirmDelete(CampaignEntity campaign) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Campaign",
      message:
          "Are you sure you want to delete '${campaign.title}'? This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () async {
        final provider = context.read<CampaignProvider>();
        final success = await provider.deleteCampaign(campaign.id);
        if (mounted) {
          if (success) {
            showToast(context, "Campaign deleted successfully");
          } else {
            showToast(
              context,
              provider.errorMessage ?? "Failed to delete campaign",
              isError: true,
            );
          }
        }
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  String _getUserTypeLabel(String type) {
    switch (type) {
      case 'all':
        return 'All Users';
      case 'petParent':
        return 'Pet Parents';
      case 'doctor':
        return 'Veterinarians';
      case 'lab':
        return 'Labs';
      case 'serviceProvider':
        return 'Service Providers';
      default:
        return type;
    }
  }

  String _getWeekDayLabel(int? day) {
    switch (day) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }

  Widget _buildPlaceholderThumbnail(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Icon(
          Icons.campaign_outlined,
          color: primaryColor.withValues(alpha: 0.6),
          size: size * 0.5,
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? image, {double size = 42}) {
    if (image == null || image.trim().isEmpty) {
      return _buildPlaceholderThumbnail(size);
    }

    final trimmed = image.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Part =
            commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final bytes = base64Decode(base64Part.trim());
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderThumbnail(size),
          ),
        );
      } catch (_) {
        return _buildPlaceholderThumbnail(size);
      }
    }

    final url = trimmed.startsWith('http')
        ? trimmed
        : "${ApiEndpoints.storageBaseUrl}/$trimmed";

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderThumbnail(size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampaignProvider>();
    final isDesktop = context.isDesktop;
    final isSmall = context.isMobile;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchCampaigns(isRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 28,
              vertical: isSmall ? 16 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(provider, isSmall),
                const SizedBox(height: 20),
                _buildFilterBar(provider, isDesktop),
                const SizedBox(height: 20),
                if (provider.isLoading && provider.campaigns.isEmpty)
                  DataTableShimmer(
                    isDesktop: isDesktop,
                    headers: const [
                      "ID",
                      "CAMPAIGN",
                      "TARGET AUDIENCE",
                      "FREQUENCY",
                      "CREATED AT",
                      "ACTIONS",
                    ],
                  )
                else if (provider.campaigns.isEmpty)
                  _buildEmptyState(provider)
                else if (isDesktop) ...[
                  _buildDesktopTable(provider.campaigns),
                  const SizedBox(height: 16),
                  _buildPaginationControls(provider, isDesktop),
                ] else ...[
                  _buildMobileList(provider.campaigns),
                  const SizedBox(height: 16),
                  _buildPaginationControls(provider, isDesktop),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CampaignProvider provider, bool isSmall) {
    if (isSmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderTitle(provider),
          const SizedBox(height: 14),
          _buildHeaderActions(provider),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildHeaderTitle(provider), _buildHeaderActions(provider)],
    );
  }

  Widget _buildHeaderTitle(CampaignProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: "Campaigns Directory",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: "${provider.totalCount} Total",
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          text:
              "Broadcast announcements, promotional campaigns, and notifications to portal users.",
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildHeaderActions(CampaignProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: provider.isLoading
              ? null
              : () => provider.fetchCampaigns(isRefresh: true),
          icon: Icon(
            Icons.refresh_rounded,
            color: textSecondaryColor,
            size: 22,
          ),
          tooltip: "Refresh Campaigns",
        ),
        const SizedBox(width: 10),
        CustomButton(
          text: "Add Campaign",
          height: 42,
          fontSize: 13,
          isIcon: true,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
          onTap: () => _openAddEditDialog(),
        ),
      ],
    );
  }

  // Filter Bar: EXACTLY keyword, from, to, and sortBy
  Widget _buildFilterBar(CampaignProvider provider, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: isDesktop
          ? Row(
              children: [
                // Keyword search
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: "Search keyword...",
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // From Date
                SizedBox(
                  width: 160,
                  child: CustomTextField(
                    controller: _fromController,
                    hintText: "From Date",
                    readOnly: true,
                    onTap: _selectFromDate,
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: _fromController.text.isNotEmpty
                          ? primaryColor
                          : textSecondaryColor,
                    ),
                    suffixIcon: _fromController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            onPressed: () {
                              _fromController.clear();
                              provider.setDateRange(
                                from: null,
                                to: _toController.text.trim().isNotEmpty
                                    ? _toController.text.trim()
                                    : null,
                              );
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // To Date
                SizedBox(
                  width: 160,
                  child: CustomTextField(
                    controller: _toController,
                    hintText: "To Date",
                    readOnly: true,
                    onTap: _selectToDate,
                    prefixIcon: Icon(
                      Icons.event_outlined,
                      size: 16,
                      color: _toController.text.isNotEmpty
                          ? primaryColor
                          : textSecondaryColor,
                    ),
                    suffixIcon: _toController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            onPressed: () {
                              _toController.clear();
                              provider.setDateRange(
                                from: _fromController.text.trim().isNotEmpty
                                    ? _fromController.text.trim()
                                    : null,
                                to: null,
                              );
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Sort By Dropdown
                _buildSortByDropdown(provider),

                // Clear Filters Button
                if (provider.hasActiveFilters) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _fromController.clear();
                      _toController.clear();
                      provider.clearFilters();
                    },
                    icon: Icon(
                      Icons.filter_alt_off_rounded,
                      color: errorColor,
                      size: 20,
                    ),
                    tooltip: "Clear Filters",
                  ),
                ],
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _searchController,
                  hintText: "Search keyword...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _fromController,
                        hintText: "From Date",
                        readOnly: true,
                        onTap: _selectFromDate,
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        controller: _toController,
                        hintText: "To Date",
                        readOnly: true,
                        onTap: _selectToDate,
                        prefixIcon: Icon(Icons.event_outlined, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildSortByDropdown(provider)),
                    if (provider.hasActiveFilters) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _fromController.clear();
                          _toController.clear();
                          provider.clearFilters();
                        },
                        icon: Icon(
                          Icons.filter_alt_off_rounded,
                          color: errorColor,
                          size: 20,
                        ),
                        tooltip: "Clear Filters",
                      ),
                    ],
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSortByDropdown(CampaignProvider provider) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.sortBy,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textSecondaryColor,
          ),
          onChanged: (val) {
            if (val != null) {
              provider.setSortBy(val);
            }
          },
          items: const [
            DropdownMenuItem<String>(
              value: "createdAt_descending",
              child: Text("Newest First"),
            ),
            DropdownMenuItem<String>(
              value: "createdAt_ascending",
              child: Text("Oldest First"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(CampaignProvider provider) {
    final hasFilter = provider.hasActiveFilters;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.campaign_outlined, size: 46, color: primaryColor),
          ),
          const SizedBox(height: 20),
          AppText(
            text: hasFilter ? "No Matching Campaigns" : "No Campaigns Yet",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AppText(
              text: hasFilter
                  ? "No campaigns match your search or filter criteria. Try clearing filters or create a new campaign."
                  : "Create and publish targeted campaigns, offers, and announcements to pet parents, vets, and service providers.",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: "Add Campaign",
            height: 42,
            fontSize: 13,
            isIcon: true,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            onTap: () => _openAddEditDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(List<CampaignEntity> list) {
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
                headingRowColor: WidgetStateProperty.all(
                  backgroundColor.withValues(alpha: 0.5),
                ),
                headingTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textSecondaryColor,
                  letterSpacing: 0.5,
                ),
                dataRowMinHeight: 68,
                dataRowMaxHeight: 74,
                columnSpacing: 24,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: AppText(
                      text: "ID",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "CAMPAIGN",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "AUDIENCE",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "FREQUENCY",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "CREATED AT",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "ACTIONS",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                rows: list.map((campaign) {
                  return DataRow(
                    cells: [
                      // ID
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
                            text:
                                campaign.longAutoIncrementId ??
                                (campaign.id.length > 8
                                    ? campaign.id.substring(0, 8).toUpperCase()
                                    : campaign.id.toUpperCase()),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),

                      // CAMPAIGN (Thumbnail + Title)
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: Row(
                            children: [
                              _buildThumbnail(campaign.featuredImage ?? campaign.attachment),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppText(
                                  text: campaign.title,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // AUDIENCE
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            text: _getUserTypeLabel(campaign.userType),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      // FREQUENCY & SCHEDULE
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: tertiaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AppText(
                                text: campaign.frequency,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: tertiaryColor,
                              ),
                            ),
                            if (campaign.frequency.toLowerCase() == 'weekly' &&
                                campaign.weekDay != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: yellowColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: AppText(
                                  text: _getWeekDayLabel(campaign.weekDay),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: yellowColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // CREATED AT
                      DataCell(
                        AppText(
                          text: _formatDate(campaign.createdAt),
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ),

                      // ACTIONS (View, Edit, Delete)
                      DataCell(
                        Builder(
                          builder: (context) {
                            final isOneTime = _isOneTimeCampaign(campaign);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _openDetailDialog(campaign),
                                  icon: Icon(
                                    Icons.visibility_outlined,
                                    color: textSecondaryColor,
                                    size: 18,
                                  ),
                                  tooltip: "View Campaign",
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  onPressed: isOneTime
                                      ? () =>
                                          _showOneTimeCampaignCannotEditDialog()
                                      : () => _openAddEditDialog(campaign),
                                  icon: Icon(
                                    isOneTime
                                        ? Icons.edit_off_outlined
                                        : Icons.edit_outlined,
                                    color: isOneTime
                                        ? textSecondaryColor.withValues(
                                            alpha: 0.45,
                                          )
                                        : primaryColor,
                                    size: 18,
                                  ),
                                  tooltip: isOneTime
                                      ? "One-time campaigns cannot be edited"
                                      : "Edit Campaign",
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  onPressed: () => _confirmDelete(campaign),
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: errorColor,
                                    size: 18,
                                  ),
                                  tooltip: "Delete Campaign",
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            );
                          },
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

  Widget _buildMobileList(List<CampaignEntity> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final campaign = list[index];
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(
                    campaign.featuredImage ?? campaign.attachment,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      text: campaign.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 1, color: borderColor),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
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
                      text: _getUserTypeLabel(campaign.userType),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: tertiaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      text: campaign.frequency,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tertiaryColor,
                    ),
                  ),
                  if (campaign.frequency.toLowerCase() == 'weekly' &&
                      campaign.weekDay != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: yellowColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: "Every ${_getWeekDayLabel(campaign.weekDay)}",
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: yellowColor,
                      ),
                    ),
                  AppText(
                    text: _formatDate(campaign.createdAt),
                    fontSize: 11,
                    color: textSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final isOneTime = _isOneTimeCampaign(campaign);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => _openDetailDialog(campaign),
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: textSecondaryColor,
                          size: 20,
                        ),
                        tooltip: "View",
                      ),
                      IconButton(
                        onPressed: isOneTime
                            ? () => _showOneTimeCampaignCannotEditDialog()
                            : () => _openAddEditDialog(campaign),
                        icon: Icon(
                          isOneTime
                              ? Icons.edit_off_outlined
                              : Icons.edit_outlined,
                          color: isOneTime
                              ? textSecondaryColor.withValues(alpha: 0.45)
                              : primaryColor,
                          size: 20,
                        ),
                        tooltip: isOneTime
                            ? "One-time campaigns cannot be edited"
                            : "Edit",
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(campaign),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: errorColor,
                          size: 20,
                        ),
                        tooltip: "Delete",
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pagination Controls Bar (BootstrapPagination + ItemsPerPageDropdown)
  Widget _buildPaginationControls(CampaignProvider provider, bool isDesktop) {
    if (provider.totalDocs == 0) return const SizedBox.shrink();

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
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} campaigns)",
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
            children: [infoAndDropdown, pagination],
          );
        },
      ),
    );
  }
}
