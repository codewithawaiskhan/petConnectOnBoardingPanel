import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../company_wallet/presentation/providers/company_wallet_provider.dart';
import '../dialogs/request_paypal_redemption_dialog.dart';
import '../providers/company_redemptions_provider.dart';

class CompanyRedemptionsScreen extends StatefulWidget {
  const CompanyRedemptionsScreen({super.key});

  @override
  State<CompanyRedemptionsScreen> createState() =>
      _CompanyRedemptionsScreenState();
}

class _CompanyRedemptionsScreenState extends State<CompanyRedemptionsScreen>
    with AppColors, Constants {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
  final DateFormat _shortDateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyRedemptionsProvider>().fetchMyRedemptions(
        isRefresh: true,
      );
      // Ensure wallet balance is loaded in case user clicks Request Payout
      try {
        context.read<CompanyWalletProvider>().fetchBalance();
      } catch (_) {}
    });
  }

  Future<void> _openRequestPayoutDialog(BuildContext context) async {
    double? availableBalance;
    try {
      final walletProv = context.read<CompanyWalletProvider>();
      availableBalance = walletProv.balance?.availableBalance.amount;
    } catch (_) {}

    await RequestPayPalRedemptionDialog.show(
      context,
      availableBalance: availableBalance,
    );
  }

  Future<void> _pickFromDate(
    BuildContext context,
    CompanyRedemptionsProvider provider,
  ) async {
    final now = DateTime.now();
    final first = DateTime(2020);
    final last = provider.toDate ?? DateTime(2100);
    final initial = provider.fromDate ?? now;
    final clampedInitial = initial.isAfter(last)
        ? last
        : (initial.isBefore(first) ? first : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: first,
      lastDate: last,
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

    if (picked != null && mounted) {
      provider.applyDateRange(from: picked, to: provider.toDate);
    }
  }

  Future<void> _pickToDate(
    BuildContext context,
    CompanyRedemptionsProvider provider,
  ) async {
    final now = DateTime.now();
    final first = provider.fromDate ?? DateTime(2020);
    final last = DateTime(2100);
    final initial = provider.toDate ?? now;
    final clampedInitial = initial.isBefore(first)
        ? first
        : (initial.isAfter(last) ? last : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: first,
      lastDate: last,
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

    if (picked != null && mounted) {
      provider.applyDateRange(from: provider.fromDate, to: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<CompanyRedemptionsProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchMyRedemptions(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(context, provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildHistoryCard(context, provider, isDesktop),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    CompanyRedemptionsProvider provider,
    bool isDesktop,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Withdrawals",
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text:
                    "View and submit withdrawal requests for earned marketing referral commissions",
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
              onTap: () => provider.fetchMyRedemptions(isRefresh: true),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Request Payout (PayPal)",
              isIcon: true,
              icon: const Icon(
                Icons.payments_rounded,
                size: 16,
                color: Colors.white,
              ),
              height: 38,
              radius: 8,
              onTap: () => _openRequestPayoutDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    CompanyRedemptionsProvider provider,
    bool isDesktop,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterBar(context, provider, isDesktop),
          const Divider(height: 1),
          if (provider.isLoading && provider.redemptions.isEmpty)
            _buildTableShimmer(isDesktop)
          else if (provider.errorMessage != null &&
              provider.redemptions.isEmpty)
            _buildErrorState(provider)
          else if (provider.redemptions.isEmpty)
            _buildEmptyState()
          else ...[
            if (isDesktop)
              _buildDesktopDataTable(provider)
            else
              _buildMobileList(provider),
            const Divider(height: 1),
            _buildPaginationFooter(provider, isDesktop),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    CompanyRedemptionsProvider provider,
    bool isDesktop,
  ) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Withdrawal History",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              AppText(
                text: "Total Requests: ${provider.totalDocs}",
                fontSize: 12,
                color: textSecondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: provider.statusFilters.map((status) {
                  final isSelected = provider.selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => provider.onStatusChanged(status),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : whiteColor,
                          borderRadius: BorderRadius.circular(8),
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
              _buildDateFilterControls(
                fromDate: provider.fromDate,
                toDate: provider.toDate,
                onPickFrom: () => _pickFromDate(context, provider),
                onPickTo: () => _pickToDate(context, provider),
                onClear: () => provider.clearDateRange(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? primaryColor : borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? primaryColor : textSecondaryColor,
            ),
            const SizedBox(width: 8),
            AppText(
              text: label,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? primaryColor : textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterControls({
    required DateTime? fromDate,
    required DateTime? toDate,
    required VoidCallback onPickFrom,
    required VoidCallback onPickTo,
    required VoidCallback onClear,
  }) {
    final fromBtn = _buildDatePickerButton(
      label: fromDate != null ? _shortDateFormat.format(fromDate) : "From Date",
      isSelected: fromDate != null,
      icon: Icons.calendar_today_outlined,
      onTap: onPickFrom,
    );

    final toBtn = _buildDatePickerButton(
      label: toDate != null ? _shortDateFormat.format(toDate) : "To Date",
      isSelected: toDate != null,
      icon: Icons.event_outlined,
      onTap: onPickTo,
    );

    final hasFilter = fromDate != null || toDate != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        fromBtn,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppText(
            text: "to",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
        ),
        toBtn,
        if (hasFilter) ...[
          const SizedBox(width: 8),
          Tooltip(
            message: "Clear Dates",
            child: InkWell(
              onTap: onClear,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(Icons.close_rounded, size: 16, color: errorColor),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTableHeaderCell(
    String label, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text: label,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: textSecondaryColor,
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildTableCell({
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: alignment,
      child: child,
    );
  }

  Widget _buildDesktopDataTable(CompanyRedemptionsProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minWidth = 850;
        final double tableWidth =
            constraints.maxWidth > minWidth ? constraints.maxWidth : minWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(2.2),
                4: FlexColumnWidth(1.2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.6),
                    border: Border(bottom: BorderSide(color: borderColor)),
                  ),
                  children: [
                    _buildTableHeaderCell("Request ID"),
                    _buildTableHeaderCell("Requested On"),
                    _buildTableHeaderCell("Amount"),
                    _buildTableHeaderCell("Payout Account"),
                    _buildTableHeaderCell("Status"),
                  ],
                ),
                ...provider.redemptions.map((redemption) {
                  final idText = redemption.autoIncrementId != null
                      ? "#${redemption.autoIncrementId}"
                      : "#${redemption.id.substring(0, 6)}";

                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: borderColor)),
                    ),
                    children: [
                      _buildTableCell(
                        child: AppText(
                          text: idText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      _buildTableCell(
                        child: AppText(
                          text: _formatDate(redemption.createdAt),
                          fontSize: 12,
                          color: textPrimaryColor,
                        ),
                      ),
                      _buildTableCell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              text: "\$${redemption.amount.toStringAsFixed(2)}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            const SizedBox(width: 4),
                            AppText(
                              text: redemption.currencyCode,
                              fontSize: 11,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                      _buildTableCell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.payment_rounded,
                                    size: 13,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  AppText(
                                    text: redemption.type,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: AppText(
                                text: redemption.accountNumber,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textPrimaryColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTableCell(
                        child: StatusBadge(status: redemption.status),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileList(CompanyRedemptionsProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: provider.redemptions.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final redemption = provider.redemptions[index];
        final idText = redemption.autoIncrementId != null
            ? "#${redemption.autoIncrementId}"
            : "#${redemption.id.substring(0, 6)}";

        return Column(
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
                StatusBadge(status: redemption.status),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text:
                      "\$${redemption.amount.toStringAsFixed(2)} ${redemption.currencyCode}",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                AppText(
                  text: _formatDate(redemption.createdAt),
                  fontSize: 11,
                  color: textSecondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 13,
                  color: textSecondaryColor,
                ),
                const SizedBox(width: 4),
                AppText(
                  text: "${redemption.type}: ${redemption.accountNumber}",
                  fontSize: 12,
                  color: textSecondaryColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaginationFooter(
    CompanyRedemptionsProvider provider,
    bool isDesktop,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text:
                "Page ${provider.currentPage} of ${provider.totalPages} (${provider.totalDocs} requests)",
            fontSize: 12,
            color: textSecondaryColor,
          ),
          BootstrapPagination(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            isEnabled: !provider.isPaginationLoading && !provider.isLoading,
            onPageChanged: (page) => provider.goToPage(page),
          ),
        ],
      ),
    );
  }

  Widget _buildTableShimmer(bool isDesktop) {
    return DataTableShimmer(
      isDesktop: isDesktop,
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(1.4),
        3: FlexColumnWidth(2.2),
        4: FlexColumnWidth(1.2),
      },
      headers: const [
        "Request ID",
        "Requested On",
        "Amount",
        "Payout Account",
        "Status",
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.payments_outlined,
            size: 48,
            color: textSecondaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No Withdrawal Requests Found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text:
                "You haven't requested any payouts yet. Use the 'Request Payout (PayPal)' button above to submit a new withdrawal.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CompanyRedemptionsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: errorColor, size: 36),
          const SizedBox(height: 10),
          AppText(
            text:
                provider.errorMessage ?? "Failed to load withdrawal requests",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 14),
          CustomButton(
            text: "Retry",
            height: 34,
            radius: 6,
            onTap: () => provider.fetchMyRedemptions(isRefresh: true),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return _dateFormat.format(dt);
    } catch (_) {
      return isoString;
    }
  }
}
