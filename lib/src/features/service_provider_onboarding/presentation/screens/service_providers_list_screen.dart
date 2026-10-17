import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../shared/presentation/widgets/directory_filter_bar.dart';
import '../dialogs/edit_service_provider_dialog.dart';
import '../providers/service_providers_list_provider.dart';

class ServiceProvidersListScreen extends StatefulWidget {
  const ServiceProvidersListScreen({super.key});

  @override
  State<ServiceProvidersListScreen> createState() =>
      _ServiceProvidersListScreenState();
}

class _ServiceProvidersListScreenState extends State<ServiceProvidersListScreen>
    with AppColors {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ServiceProvidersListProvider>();
      if (provider.serviceProviders.isEmpty) {
        provider.fetchServiceProviders(isRefresh: true);
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
      body: Consumer<ServiceProvidersListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchServiceProviders(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildFilterBar(provider, isDesktop),
                  const SizedBox(height: 16),
                  DirectoryFilterBar(
                    fromDate: provider.fromDate,
                    toDate: provider.toDate,
                    countryCode: provider.countryCode,
                    isLoading: provider.isLoading,
                    onApply: ({countryCode, fromDate, toDate}) {
                      provider.applyFilters(
                        from: fromDate,
                        to: toDate,
                        countryCode: countryCode,
                      );
                    },
                    onClear: () {
                      provider.clearFilters();
                    },
                  ),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    DataTableShimmer(
                      isDesktop: isDesktop,
                      columnWidths: const {
                        0: FlexColumnWidth(2.2),
                        1: FlexColumnWidth(2.0),
                        2: FlexColumnWidth(1.8),
                        3: FlexColumnWidth(1.1),
                        4: FlexColumnWidth(1.4),
                      },
                      headers: const [
                        "Provider",
                        "Business Name",
                        "Contact Info",
                        "Status",
                        "Action",
                      ],
                    )
                  else if (provider.errorMessage != null &&
                      provider.serviceProviders.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.serviceProviders.isEmpty)
                    _buildEmptyState()
                  else ...[
                    if (provider.isPaginationLoading)
                      DataTableShimmer(
                        isDesktop: isDesktop,
                        columnWidths: const {
                          0: FlexColumnWidth(2.2),
                          1: FlexColumnWidth(2.0),
                          2: FlexColumnWidth(1.8),
                          3: FlexColumnWidth(1.1),
                          4: FlexColumnWidth(1.4),
                        },
                        headers: const [
                          "Provider",
                          "Business Name",
                          "Contact Info",
                          "Status",
                          "Action",
                        ],
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

  Widget _buildHeader(ServiceProvidersListProvider provider, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Registered Service Providers",
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 4),
            AppText(
              text: "Total Providers: ${provider.totalDocs}",
              fontSize: 13,
              color: textSecondaryColor,
            ),
          ],
        ),
        CustomButton(
          text: "Refresh",
          isIcon: true,
          icon: Icon(Icons.refresh_rounded, size: 16, color: whiteColor),
          height: 38,
          radius: 8,
          onTap: () => provider.fetchServiceProviders(isRefresh: true),
        ),
      ],
    );
  }

  Widget _buildFilterBar(
    ServiceProvidersListProvider provider,
    bool isDesktop,
  ) {
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
                  hintText: "Search provider by name, business, email...",
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

  Widget _buildDesktopDataTable(ServiceProvidersListProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2.2),
            1: FlexColumnWidth(2.0),
            2: FlexColumnWidth(1.8),
            3: FlexColumnWidth(1.1),
            4: FlexColumnWidth(1.4),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: backgroundColor),
              children: [
                _buildHeaderCell("Provider"),
                _buildHeaderCell("Business Name"),
                _buildHeaderCell("Contact Info"),
                _buildHeaderCell("Status"),
                _buildHeaderCell("Action", isCenter: true),
              ],
            ),
            ...provider.serviceProviders.map((sp) {
              return TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                children: [
                  _buildProviderCell(sp),
                  _buildBusinessCell(sp),
                  _buildContactCell(sp),
                  _buildStatusCell(sp.status),
                  _buildActionCell(sp),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: isCenter ? Alignment.center : Alignment.centerLeft,
        child: AppText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildProviderCell(ServiceProviderItemEntity sp) {
    final initial = sp.fullName.isNotEmpty
        ? sp.fullName.substring(0, 1).toUpperCase()
        : "S";

    return InkWell(
      onTap: () => context.go('/providers/${sp.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: secondaryColor.withValues(alpha: 0.12),
              child: AppText(
                text: initial,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: secondaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: sp.fullName,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  if (sp.longAutoIncrementId != null)
                    AppText(
                      text: sp.longAutoIncrementId!,
                      fontSize: 11,
                      color: textSecondaryColor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessCell(ServiceProviderItemEntity sp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: sp.businessName ?? "Independent Provider",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          if (sp.city != null && sp.city!.isNotEmpty)
            AppText(
              text:
                  "${sp.city}${sp.province != null ? ', ${sp.province}' : ''}",
              fontSize: 11,
              color: textSecondaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildContactCell(ServiceProviderItemEntity sp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: sp.businessEmail ?? sp.email,
            fontSize: 12,
            color: textPrimaryColor,
          ),
          if (sp.businessPhone != null && sp.businessPhone!.isNotEmpty)
            AppText(
              text: sp.businessPhone!,
              fontSize: 11,
              color: textSecondaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(
          status: status,
        ),
      ),
    );
  }

  Widget _buildActionCell(ServiceProviderItemEntity sp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(
                Icons.visibility_outlined,
                size: 18,
                color: primaryColor,
              ),
              tooltip: "View Details",
              splashRadius: 18,
              onPressed: () => context.go('/providers/${sp.id}'),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: textSecondaryColor,
              ),
              tooltip: "Edit Provider",
              splashRadius: 18,
              onPressed: () => _showEditServiceProviderDialog(sp),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: errorColor,
              ),
              tooltip: "Delete Provider",
              splashRadius: 18,
              onPressed: () => _showDeleteConfirmationDialog(sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(ServiceProvidersListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.serviceProviders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sp = provider.serviceProviders[index];
        return InkWell(
          onTap: () => context.go('/providers/${sp.id}'),
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
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: secondaryColor.withValues(alpha: 0.12),
                      child: AppText(
                        text: sp.fullName.isNotEmpty
                            ? sp.fullName.substring(0, 1).toUpperCase()
                            : "S",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: sp.fullName,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                          if (sp.businessName != null)
                            AppText(
                              text: sp.businessName!,
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: sp.status),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Contact",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                        AppText(
                          text: sp.businessEmail ?? sp.email,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "View Details",
                      isOutlined: true,
                      height: 32,
                      fontSize: 12,
                      radius: 6,
                      onTap: () => context.go('/providers/${sp.id}'),
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
                              context.go('/providers/${sp.id}'),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: textSecondaryColor,
                          ),
                          tooltip: "Edit Provider",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () => _showEditServiceProviderDialog(sp),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: errorColor,
                          ),
                          tooltip: "Delete Provider",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () =>
                              _showDeleteConfirmationDialog(sp),
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
    ServiceProvidersListProvider provider,
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
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} service providers)",
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

  Widget _buildErrorState(ServiceProvidersListProvider provider) {
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
            text: provider.errorMessage ?? "Failed to load service providers",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Try Again",
            height: 36,
            radius: 8,
            onTap: () => provider.fetchServiceProviders(isRefresh: true),
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
        children: [
          Icon(Icons.storefront_outlined, color: textSecondaryColor, size: 48),
          const SizedBox(height: 12),
          AppText(
            text: "No service providers found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: "Try adjusting your search query or status filter.",
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Future<void> _showEditServiceProviderDialog(
    ServiceProviderItemEntity serviceProvider,
  ) async {
    final updated = await EditServiceProviderDialog.show(
      context,
      serviceProvider: serviceProvider,
    );
    if (!mounted) return;
    if (updated == true) {
      context
          .read<ServiceProvidersListProvider>()
          .fetchServiceProviders(isRefresh: true);
    }
  }

  void _showDeleteConfirmationDialog(
    ServiceProviderItemEntity serviceProvider,
  ) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Service Provider",
      message:
          "Are you sure you want to delete ${serviceProvider.fullName.isNotEmpty ? serviceProvider.fullName : 'this service provider'}?",
      confirmText: "Delete",
      onConfirm: () async {
        if (!mounted) return;
        final provider = context.read<ServiceProvidersListProvider>();
        await provider.deleteServiceProvider(
          context: context,
          id: serviceProvider.id,
        );
      },
    );
  }
}
