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
import '../../../../core/utils/show_image.dart';
import '../../../../shared/presentation/widgets/directory_filter_bar.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../dialogs/update_withdrawal_status_dialog.dart';
import '../providers/withdrawal_list_provider.dart';

class WithdrawalListScreen extends StatefulWidget {
  const WithdrawalListScreen({super.key});

  @override
  State<WithdrawalListScreen> createState() => _WithdrawalListScreenState();
}

class _WithdrawalListScreenState extends State<WithdrawalListScreen>
    with AppColors {
  final TextEditingController _searchController = TextEditingController();
  final ShowImage _showImage = ShowImage();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WithdrawalListProvider>();
      if (provider.requests.isEmpty) {
        provider.fetchRequests(isRefresh: true);
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

  String _formatTime(String dateStr) {
    if (dateStr.trim().isEmpty) return "";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return "";
    }
  }

  void _openUpdateStatusDialog(WithdrawalRequestEntity request) {
    UpdateWithdrawalStatusDialog.show(
      context,
      id: request.id,
      currentStatus: request.status,
      initialFailedReason: request.failedReason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<WithdrawalListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchRequests(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildFilterBar(provider),
                  const SizedBox(height: 16),
                  DirectoryFilterBar(
                    fromDate: provider.fromDate,
                    toDate: provider.toDate,
                    showCountryFilter: false,
                    isLoading: provider.isLoading,
                    onApply: ({countryCode, fromDate, toDate}) {
                      provider.applyFilters(from: fromDate, to: toDate);
                    },
                    onClear: () {
                      provider.clearFilters();
                    },
                  ),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    _buildTableShimmer(isDesktop)
                  else if (provider.errorMessage != null &&
                      provider.requests.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.requests.isEmpty)
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
        0: FlexColumnWidth(0.9),
        1: FlexColumnWidth(2.3),
        2: FlexColumnWidth(2.1),
        3: FlexColumnWidth(1.1),
        4: FlexColumnWidth(1.4),
        5: FlexColumnWidth(1.2),
        6: FlexColumnWidth(0.9),
      },
      headers: const [
        "ID",
        "User",
        "PayPal Account",
        "Amount",
        "Date",
        "Status",
        "Actions",
      ],
    );
  }

  Widget _buildHeader(WithdrawalListProvider provider, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "PayPal Withdrawal Requests",
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: "Total Requests: ${provider.totalDocs}",
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
          onTap: () => provider.fetchRequests(isRefresh: true),
        ),
      ],
    );
  }

  Widget _buildFilterBar(WithdrawalListProvider provider) {
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
                  hintText: "Search by user email, PayPal account, or ID...",
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

  Widget _buildUserAvatar(WithdrawalRequestEntity request) {
    final image = request.user?.userId?.image;
    final email = request.user?.email ?? '';
    final initial = email.isNotEmpty ? email.substring(0, 1).toUpperCase() : "U";

    if (image != null && image.trim().isNotEmpty) {
      return _showImage.buildImage(
        image: image.trim(),
        size: 36,
      );
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: primaryColor.withValues(alpha: 0.12),
      child: AppText(
        text: initial,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  Widget _buildDesktopDataTable(WithdrawalListProvider provider) {
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
                dataRowMinHeight: 64,
                dataRowMaxHeight: 72,
                columnSpacing: 24,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: AppText(
                      text: "ID",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "User",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "PayPal Account",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Amount",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Date",
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
                      text: "Actions",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
                rows: provider.requests.map((request) {
                  final email = request.user?.email ?? "—";
                  final roles = request.user?.userId?.roles ?? const [];
                  final timeStr = _formatTime(request.createdAt);

                  return DataRow(
                    cells: [
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
                            text: "#${request.autoIncrementId}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildUserAvatar(request),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  text: email,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                                if (roles.isNotEmpty)
                                  AppText(
                                    text: roles.join(', '),
                                    fontSize: 11,
                                    color: textSecondaryColor,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              text: request.accountNumber.isNotEmpty
                                  ? request.accountNumber
                                  : "—",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        AppText(
                          text: "${request.currencyCode} ${request.amount}",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: _formatDate(request.createdAt),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textPrimaryColor,
                            ),
                            if (timeStr.isNotEmpty)
                              AppText(
                                text: timeStr,
                                fontSize: 11,
                                color: textSecondaryColor,
                              ),
                          ],
                        ),
                      ),
                      DataCell(
                        StatusBadge(status: request.status),
                      ),
                      DataCell(
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: primaryColor,
                          ),
                          tooltip: "Update Status",
                          splashRadius: 18,
                          onPressed: () => _openUpdateStatusDialog(request),
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

  Widget _buildMobileList(WithdrawalListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = provider.requests[index];
        final email = request.user?.email ?? "—";

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
                  _buildUserAvatar(request),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: email,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppText(
                          text: "ID #${request.autoIncrementId}",
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: request.status),
                  const SizedBox(width: 4),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: primaryColor,
                    ),
                    tooltip: "Update Status",
                    onPressed: () => _openUpdateStatusDialog(request),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "PayPal Account",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                        AppText(
                          text: request.accountNumber.isNotEmpty
                              ? request.accountNumber
                              : "—",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textPrimaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        text: "Amount",
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                      AppText(
                        text: "${request.currencyCode} ${request.amount}",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Date",
                    fontSize: 11,
                    color: textSecondaryColor,
                  ),
                  AppText(
                    text: _formatDate(request.createdAt),
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

  Widget _buildPaginationControls(WithdrawalListProvider provider) {
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
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} requests)",
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

  Widget _buildErrorState(WithdrawalListProvider provider) {
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
            text: provider.errorMessage ?? "Failed to load withdrawal requests",
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
            onTap: () => provider.fetchRequests(isRefresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(WithdrawalListProvider provider) {
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
            Icons.account_balance_wallet_outlined,
            color: textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No withdrawal requests found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: provider.hasActiveFilters
                ? "Try adjusting your search query, date range, or status filter."
                : "PayPal referral withdrawal requests will appear here.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
