import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../company_redemptions/domain/entities/redemption_entity.dart';
import '../dialogs/reject_payout_dialog.dart';
import '../providers/company_payouts_provider.dart';

class CompanyPayoutsScreen extends StatefulWidget {
  const CompanyPayoutsScreen({super.key});

  @override
  State<CompanyPayoutsScreen> createState() => _CompanyPayoutsScreenState();
}

class _CompanyPayoutsScreenState extends State<CompanyPayoutsScreen>
    with AppColors, Constants {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyPayoutsProvider>().fetchPayouts(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickFromDate(
    BuildContext context,
    CompanyPayoutsProvider provider,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.fromDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      provider.applyDateRange(from: picked, to: provider.toDate);
    }
  }

  Future<void> _pickToDate(
    BuildContext context,
    CompanyPayoutsProvider provider,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.toDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      provider.applyDateRange(from: provider.fromDate, to: picked);
    }
  }

  void _confirmMarkPaid(
    BuildContext context,
    CompanyPayoutsProvider provider,
    RedemptionEntity payout,
  ) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Mark as Paid?",
      message:
          "Are you sure you want to mark this payout of ${payout.currencyCode} ${payout.amount.toStringAsFixed(2)} to ${payout.accountNumber} as Paid?",
      confirmText: "Confirm Paid",
      cancelText: "Cancel",
      onConfirm: () {
        provider.updateStatus(
          payout.id,
          'Paid',
          context: context,
        );
      },
    );
  }

  void _openRejectDialog(BuildContext context, RedemptionEntity payout) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RejectPayoutDialog(
        payoutId: payout.id,
        companyName: payout.marketingCompanyName,
        amount: payout.amount,
        currency: payout.currencyCode,
      ),
    );
  }

  void _viewDetails(BuildContext context, RedemptionEntity payout) {
    final idText = payout.autoIncrementId != null
        ? "#${payout.autoIncrementId}"
        : "#${payout.id.substring(0, 6)}";

    DialogUtils.showDynamicInfoDialog(
      context: context,
      title: "Payout Details ($idText)",
      message:
          "Company: ${payout.marketingCompanyName ?? '—'}\n"
          "Account/User Email: ${payout.userEmail ?? '—'}\n"
          "PayPal Account: ${payout.accountNumber}\n"
          "Amount: ${payout.currencyCode} ${payout.amount.toStringAsFixed(2)}\n"
          "Status: ${payout.status}\n"
          "Requested: ${_formatDate(payout.createdAt)}"
          "${payout.failedReason != null && payout.failedReason!.isNotEmpty ? '\n\nRejection Reason: ${payout.failedReason}' : ''}",
      buttonText: "Close",
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return "—";
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return _dateFormat.format(dt);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<CompanyPayoutsProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchPayouts(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, provider, isDesktop),
                  const SizedBox(height: 16),
                  _buildFiltersCard(context, provider),
                  const SizedBox(height: 16),
                  _buildTableCard(context, provider, isDesktop),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CompanyPayoutsProvider provider,
    bool isDesktop,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final titleCol = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Company Payouts",
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 4),
            AppText(
              text:
                  "Review and process PayPal redemption payouts submitted by Marketing Companies",
              fontSize: 13,
              color: textSecondaryColor,
            ),
          ],
        );

        final refreshBtn = CustomButton(
          text: "Refresh",
          icon: const Icon(Icons.refresh_rounded, size: 16),
          height: 38,
          radius: 8,
          isOutlined: true,
          fontSize: 13,
          onTap: provider.isLoading
              ? null
              : () => provider.fetchPayouts(isRefresh: true),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleCol,
              const SizedBox(height: 12),
              refreshBtn,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: titleCol),
            const SizedBox(width: 16),
            refreshBtn,
          ],
        );
      },
    );
  }

  Widget _buildFiltersCard(
    BuildContext context,
    CompanyPayoutsProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;

              final searchField = SizedBox(
                width: isWide ? 280 : double.infinity,
                child: CustomTextField(
                  controller: _searchController,
                  hintText: "Search company, user email...",
                  isIcon: true,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: textSecondaryColor,
                  ),
                  radius: 8,
                  onChanged: (val) => provider.onSearchChanged(val),
                ),
              );

              final dateRow = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _pickFromDate(context, provider),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: provider.fromDate != null
                            ? primaryColor.withValues(alpha: 0.08)
                            : whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: provider.fromDate != null
                              ? primaryColor
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: provider.fromDate != null
                                ? primaryColor
                                : textSecondaryColor,
                          ),
                          const SizedBox(width: 6),
                          AppText(
                            text: provider.fromDate != null
                                ? _dateFormat.format(provider.fromDate!)
                                : "From Date",
                            fontSize: 12,
                            color: provider.fromDate != null
                                ? primaryColor
                                : textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _pickToDate(context, provider),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: provider.toDate != null
                            ? primaryColor.withValues(alpha: 0.08)
                            : whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: provider.toDate != null
                              ? primaryColor
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: provider.toDate != null
                                ? primaryColor
                                : textSecondaryColor,
                          ),
                          const SizedBox(width: 6),
                          AppText(
                            text: provider.toDate != null
                                ? _dateFormat.format(provider.toDate!)
                                : "To Date",
                            fontSize: 12,
                            color: provider.toDate != null
                                ? primaryColor
                                : textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.fromDate != null ||
                      provider.toDate != null ||
                      provider.selectedStatus != 'All' ||
                      provider.searchKeyword.isNotEmpty)
                    CustomButton(
                      text: "Clear",
                      height: 38,
                      width: 76,
                      radius: 8,
                      isOutlined: true,
                      fontSize: 12,
                      onTap: () {
                        _searchController.clear();
                        provider.clearFilters();
                      },
                    ),
                ],
              );

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchField,
                    dateRow,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchField,
                  const SizedBox(height: 10),
                  dateRow,
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.statusFilters.map((st) {
                final isSelected = provider.selectedStatus == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: AppText(
                      text: st,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? whiteColor : textPrimaryColor,
                    ),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryColor : borderColor,
                      ),
                    ),
                    showCheckmark: false,
                    onSelected: (_) => provider.onStatusChanged(st),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard(
    BuildContext context,
    CompanyPayoutsProvider provider,
    bool isDesktop,
  ) {
    if (provider.isLoading && provider.payouts.isEmpty) {
      return const DataTableShimmer();
    }

    if (provider.errorMessage != null && provider.payouts.isEmpty) {
      return _buildErrorState(provider);
    }

    if (provider.payouts.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          if (isDesktop)
            _buildDesktopTable(context, provider)
          else
            _buildMobileList(context, provider),
          if (provider.totalPages > 1) ...[
            Divider(color: borderColor, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: BootstrapPagination(
                currentPage: provider.currentPage,
                totalPages: provider.totalPages,
                isEnabled: !provider.isPaginationLoading && !provider.isLoading,
                onPageChanged: (page) => provider.goToPage(page),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    CompanyPayoutsProvider provider,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(backgroundColor),
          dataRowMinHeight: 62,
          dataRowMaxHeight: 68,
          horizontalMargin: 20,
          columnSpacing: 20,
          columns: [
            DataColumn(
              label: AppText(
                text: "ID / Date",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textSecondaryColor,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Marketing Company",
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
                text: "PayPal Account",
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
              label: SizedBox(
                width: 200,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText(
                    text: "Actions",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textSecondaryColor,
                  ),
                ),
              ),
            ),
          ],
          rows: provider.payouts.map((payout) {
            final isUpdating = provider.isUpdating(payout.id);
            final idText = payout.autoIncrementId != null
                ? "#${payout.autoIncrementId}"
                : "#${payout.id.substring(0, 6)}";

            final canPerformActions =
                payout.status.toLowerCase() != 'paid' &&
                payout.status.toLowerCase() != 'failed';

            return DataRow(
              cells: [
                // ID / Date
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: idText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        text: _formatDate(payout.createdAt),
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                ),
                // Marketing Company
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: payout.marketingCompanyName ?? "—",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      if (payout.userEmail != null &&
                          payout.userEmail!.isNotEmpty)
                        AppText(
                          text: payout.userEmail!,
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                    ],
                  ),
                ),
                // Amount
                DataCell(
                  AppText(
                    text:
                        "${payout.currencyCode} ${payout.amount.toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                // PayPal Account
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.paypal, size: 16, color: primaryColor),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppText(
                          text: payout.accountNumber,
                          fontSize: 13,
                          color: textPrimaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadge(status: payout.status),
                      if (payout.failedReason != null &&
                          payout.failedReason!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Tooltip(
                            message: payout.failedReason!,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 11,
                                  color: errorColor,
                                ),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: AppText(
                                    text: payout.failedReason!,
                                    fontSize: 10,
                                    color: errorColor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Actions
                DataCell(
                  SizedBox(
                    width: 200,
                    child: isUpdating
                        ? const Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (canPerformActions) ...[
                                CustomButton(
                                  text: "Mark Paid",
                                  fontSize: 11,
                                  height: 28,
                                  radius: 6,
                                  fillColor: successColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  onTap: () => _confirmMarkPaid(
                                    context,
                                    provider,
                                    payout,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                CustomButton(
                                  text: "Reject",
                                  fontSize: 11,
                                  height: 28,
                                  radius: 6,
                                  isOutlined: true,
                                  buttonBorder: Border.all(color: errorColor),
                                  textColor: errorColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  onTap: () =>
                                      _openRejectDialog(context, payout),
                                ),
                                const SizedBox(width: 4),
                              ],
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                tooltip: "View Details",
                                onPressed: () =>
                                    _viewDetails(context, payout),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    CompanyPayoutsProvider provider,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: provider.payouts.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final payout = provider.payouts[index];
        final isUpdating = provider.isUpdating(payout.id);
        final idText = payout.autoIncrementId != null
            ? "#${payout.autoIncrementId}"
            : "#${payout.id.substring(0, 6)}";
        final canPerformActions =
            payout.status.toLowerCase() != 'paid' &&
            payout.status.toLowerCase() != 'failed';

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: idText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatusBadge(status: payout.status),
                      const SizedBox(width: 4),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 16,
                        ),
                        tooltip: "View Details",
                        onPressed: () => _viewDetails(context, payout),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              AppText(
                text: payout.marketingCompanyName ?? "—",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              if (payout.userEmail != null && payout.userEmail!.isNotEmpty)
                AppText(
                  text: payout.userEmail!,
                  fontSize: 12,
                  color: textSecondaryColor,
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.paypal, size: 14, color: primaryColor),
                      const SizedBox(width: 4),
                      AppText(
                        text: payout.accountNumber,
                        fontSize: 12,
                        color: textPrimaryColor,
                      ),
                    ],
                  ),
                  AppText(
                    text:
                        "${payout.currencyCode} ${payout.amount.toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AppText(
                text: _formatDate(payout.createdAt),
                fontSize: 11,
                color: textSecondaryColor,
              ),
              if (payout.failedReason != null &&
                  payout.failedReason!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: errorColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 12, color: errorColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          text: payout.failedReason!,
                          fontSize: 11,
                          color: errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (canPerformActions) ...[
                const SizedBox(height: 10),
                if (isUpdating)
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "Reject",
                        fontSize: 11,
                        height: 30,
                        radius: 6,
                        isOutlined: true,
                        buttonBorder: Border.all(color: errorColor),
                        textColor: errorColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onTap: () => _openRejectDialog(context, payout),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: "Mark Paid",
                        fontSize: 11,
                        height: 30,
                        radius: 6,
                        fillColor: successColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onTap: () =>
                            _confirmMarkPaid(context, provider, payout),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: textSecondaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No company payout requests found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text:
                "Payout requests submitted by Marketing Companies will appear here.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CompanyPayoutsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
          const SizedBox(height: 12),
          AppText(
            text: provider.errorMessage ?? "Failed to load payouts",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: "Try Again",
            height: 36,
            radius: 8,
            fontSize: 12,
            onTap: () => provider.fetchPayouts(isRefresh: true),
          ),
        ],
      ),
    );
  }
}
