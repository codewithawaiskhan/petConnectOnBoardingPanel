import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../company_redemptions/presentation/dialogs/request_paypal_redemption_dialog.dart';
import '../../domain/entities/commission_ledger_entry_entity.dart';
import '../../domain/entities/referral_balance_entity.dart';
import '../providers/company_wallet_provider.dart';

class CompanyWalletScreen extends StatefulWidget {
  const CompanyWalletScreen({super.key});

  @override
  State<CompanyWalletScreen> createState() => _CompanyWalletScreenState();
}

class _CompanyWalletScreenState extends State<CompanyWalletScreen>
    with AppColors, Constants {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
  final DateFormat _shortDateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyWalletProvider>().init();
    });
  }

  Future<void> _pickFromDate(
    BuildContext context,
    CompanyWalletProvider provider,
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
    CompanyWalletProvider provider,
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

  Future<void> _showRequestWithdrawalPlaceholder(
    BuildContext context,
    CurrencyAmountEntity? availableBalance,
  ) async {
    await RequestPayPalRedemptionDialog.show(
      context,
      availableBalance: availableBalance?.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<CompanyWalletProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.init(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(context, provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildBalanceCards(context, provider, isDesktop),
                  const SizedBox(height: 24),
                  _buildLedgerCard(context, provider, isDesktop),
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
    CompanyWalletProvider provider,
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
                text: "Wallet & Ledger",
                fontSize: isDesktop ? 22 : 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text:
                    "Manage your company referral wallet balance and commission ledger history",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CustomButton(
          text: "Refresh",
          isOutlined: true,
          isIcon: true,
          icon: Icon(Icons.refresh_rounded, size: 16, color: primaryColor),
          height: 38,
          radius: 8,
          onTap: () => provider.init(),
        ),
      ],
    );
  }

  Widget _buildBalanceCards(
    BuildContext context,
    CompanyWalletProvider provider,
    bool isDesktop,
  ) {
    final balance = provider.balance;
    final isLoading = provider.isLoadingBalance && balance == null;

    final availAmount = balance?.availableBalance.amount ?? 0.0;
    final availCurrency = balance?.availableBalance.currencyCode ?? 'USD';

    final resAmount = balance?.reservedBalance.amount ?? 0.0;
    final resCurrency = balance?.reservedBalance.currencyCode ?? 'USD';

    final lifeAmount = balance?.lifetimeEarned.amount ?? 0.0;
    final lifeCurrency = balance?.lifetimeEarned.currencyCode ?? 'USD';

    final redeemedAmount = balance?.lifetimeRedeemed.amount ?? 0.0;
    final redeemedCurrency = balance?.lifetimeRedeemed.currencyCode ?? 'USD';

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 1100 ? 4 : (width > 600 ? 2 : 1);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isDesktop ? 2.0 : 1.8,
          children: [
            // Available Balance Card
            _buildMetricCard(
              title: "Available Balance",
              amount: "\$${availAmount.toStringAsFixed(2)}",
              currency: availCurrency,
              subtitle: "Ready for withdrawal",
              icon: Icons.account_balance_wallet_rounded,
              themeColor: successColor,
              isLoading: isLoading,
              actionWidget: CustomButton(
                text: "Request Withdrawal",
                fontSize: 11,
                height: 30,
                radius: 6,
                isIcon: true,
                icon: const Icon(
                  Icons.arrow_outward_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                fillColor: successColor,
                onTap: () => _showRequestWithdrawalPlaceholder(
                  context,
                  balance?.availableBalance,
                ),
              ),
            ),
            // Reserved / Pending Balance Card
            _buildMetricCard(
              title: "Pending / Reserved",
              amount: "\$${resAmount.toStringAsFixed(2)}",
              currency: resCurrency,
              subtitle: "Payouts in-transit / locked",
              icon: Icons.hourglass_top_rounded,
              themeColor: yellowColor,
              isLoading: isLoading,
            ),
            // Total Lifetime Earned Card
            _buildMetricCard(
              title: "Total Lifetime Earned",
              amount: "\$${lifeAmount.toStringAsFixed(2)}",
              currency: lifeCurrency,
              subtitle: "All-time referrals earned",
              icon: Icons.trending_up_rounded,
              themeColor: primaryColor,
              isLoading: isLoading,
            ),
            // Lifetime Redeemed Card
            _buildMetricCard(
              title: "Lifetime Redeemed",
              amount: "\$${redeemedAmount.toStringAsFixed(2)}",
              currency: redeemedCurrency,
              subtitle: "Successfully withdrawn",
              icon: Icons.payments_rounded,
              themeColor: textSecondaryColor,
              isLoading: isLoading,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required String currency,
    required String subtitle,
    required IconData icon,
    required Color themeColor,
    required bool isLoading,
    Widget? actionWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: themeColor, size: 18),
              ),
            ],
          ),
          if (isLoading)
            LinearProgressIndicator(
              color: themeColor,
              backgroundColor: themeColor.withValues(alpha: 0.1),
            )
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AppText(
                  text: amount,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: themeColor,
                ),
                const SizedBox(width: 6),
                AppText(
                  text: currency,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondaryColor,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    text: subtitle,
                    fontSize: 11,
                    color: textSecondaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actionWidget != null) ...[
                  const SizedBox(width: 8),
                  actionWidget,
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLedgerCard(
    BuildContext context,
    CompanyWalletProvider provider,
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
          // Filter & Search Controls Header
          _buildLedgerHeaderAndFilters(context, provider, isDesktop),
          const Divider(height: 1),
          // Content
          if (provider.isLoadingLedger && provider.entries.isEmpty)
            _buildTableShimmer(isDesktop)
          else if (provider.ledgerError != null && provider.entries.isEmpty)
            _buildErrorState(provider)
          else if (provider.entries.isEmpty)
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

  Widget _buildLedgerHeaderAndFilters(
    BuildContext context,
    CompanyWalletProvider provider,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Commission Ledger",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    text:
                        "Showing ${provider.totalDocs} recorded financial transactions",
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Entry Type Filter Chips
              Row(
                mainAxisSize: MainAxisSize.min,
                children: provider.entryTypeOptions.map((type) {
                  final isSelected = provider.selectedEntryType == type;
                  final label = type == 'All'
                      ? 'All Types'
                      : (type == 'credit' ? 'Credits (+)' : 'Debits (-)');

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => provider.onEntryTypeChanged(type),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? primaryColor : borderColor,
                          ),
                        ),
                        child: AppText(
                          text: label,
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
              // Date Range Pickers
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _pickFromDate(context, provider),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              text: provider.fromDate != null
                                  ? _shortDateFormat.format(provider.fromDate!)
                                  : "From Date",
                              fontSize: 12,
                              color: provider.fromDate != null
                                  ? textPrimaryColor
                                  : textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppText(text: "→", fontSize: 12, color: textSecondaryColor),
                    InkWell(
                      onTap: () => _pickToDate(context, provider),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              text: provider.toDate != null
                                  ? _shortDateFormat.format(provider.toDate!)
                                  : "To Date",
                              fontSize: 12,
                              color: provider.toDate != null
                                  ? textPrimaryColor
                                  : textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.fromDate != null || provider.toDate != null)
                InkWell(
                  onTap: () => provider.clearDateRange(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded, size: 14, color: errorColor),
                        const SizedBox(width: 4),
                        AppText(
                          text: "Clear Dates",
                          fontSize: 12,
                          color: errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDataTable(CompanyWalletProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 900),
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 64,
          horizontalMargin: 20,
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: AppText(
                text: "Date & Time",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Type",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Description",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Amount",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Subscription Details",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            DataColumn(
              label: AppText(
                text: "Status",
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          rows: provider.entries.map((entry) {
            return DataRow(
              cells: [
                // Date
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: _formatDate(entry.createdAt),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      if (entry.autoIncrementId != null)
                        AppText(
                          text: "#${entry.autoIncrementId}",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                    ],
                  ),
                ),
                // Type
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: entry.isCredit
                          ? lightGreenColor
                          : peachColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          entry.isCredit
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          size: 12,
                          color: entry.isCredit ? successColor : errorColor,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          text: entry.isCredit ? "Credit" : "Debit",
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: entry.isCredit ? successColor : errorColor,
                        ),
                      ],
                    ),
                  ),
                ),
                // Description
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: _buildDescription(entry),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      if (entry.productId != null &&
                          entry.productId!.isNotEmpty)
                        AppText(
                          text: "Product: ${entry.productId}",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                    ],
                  ),
                ),
                // Amount
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text:
                            "${entry.isCredit ? '+' : '-'} \$${entry.amount.toStringAsFixed(2)}",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: entry.isCredit ? successColor : errorColor,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        text: entry.currencyCode,
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                ),
                // Subscription / User
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (entry.subscriptionPrice != null)
                        AppText(
                          text:
                              "\$${entry.subscriptionPrice!.toStringAsFixed(2)} ${entry.subscriptionCurrency ?? ''} (${entry.subscriptionType ?? 'Plan'})",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textPrimaryColor,
                        )
                      else
                        AppText(
                          text: "Direct Commission",
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      if (entry.userEmail != null &&
                          entry.userEmail!.isNotEmpty)
                        AppText(
                          text: entry.userEmail!,
                          fontSize: 11,
                          color: textSecondaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // Status
                DataCell(
                  entry.isRefunded
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: peachColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppText(
                            text: "Refunded",
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: errorColor,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: lightGreenColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppText(
                            text: "Settled",
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: successColor,
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

  Widget _buildMobileList(CompanyWalletProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: provider.entries.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final entry = provider.entries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: entry.isCredit
                            ? lightGreenColor
                            : peachColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: entry.isCredit ? "+ Credit" : "- Debit",
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: entry.isCredit ? successColor : errorColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (entry.isRefunded)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: peachColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppText(
                          text: "Refunded",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: errorColor,
                        ),
                      ),
                  ],
                ),
                AppText(
                  text:
                      "${entry.isCredit ? '+' : '-'} \$${entry.amount.toStringAsFixed(2)} ${entry.currencyCode}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: entry.isCredit ? successColor : errorColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              text: _buildDescription(entry),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: _formatDate(entry.createdAt),
                  fontSize: 11,
                  color: textSecondaryColor,
                ),
                if (entry.subscriptionPrice != null)
                  AppText(
                    text:
                        "Sub: \$${entry.subscriptionPrice!.toStringAsFixed(2)}",
                    fontSize: 11,
                    color: textSecondaryColor,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaginationFooter(
    CompanyWalletProvider provider,
    bool isDesktop,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text:
                "Page ${provider.currentPage} of ${provider.totalPages} (${provider.totalDocs} entries)",
            fontSize: 12,
            color: textSecondaryColor,
          ),
          BootstrapPagination(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            isEnabled:
                !provider.isPaginationLoading && !provider.isLoadingLedger,
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
        0: FlexColumnWidth(1.8),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(2.2),
        3: FlexColumnWidth(1.4),
        4: FlexColumnWidth(2.0),
        5: FlexColumnWidth(1.2),
      },
      headers: const [
        "Date & Time",
        "Type",
        "Description",
        "Amount",
        "Subscription Details",
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
            Icons.receipt_long_outlined,
            size: 48,
            color: textSecondaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No Ledger Entries Found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text:
                "When marketing referrals purchase subscriptions or trigger renewals, commission records will appear here.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CompanyWalletProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: errorColor, size: 36),
          const SizedBox(height: 10),
          AppText(
            text:
                provider.ledgerError ?? "Failed to load commission ledger data",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 14),
          CustomButton(
            text: "Retry",
            height: 34,
            radius: 6,
            onTap: () => provider.fetchLedgerEntries(isRefresh: true),
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

  String _buildDescription(CommissionLedgerEntryEntity entry) {
    if (entry.isRenewal) {
      return "Commission - Renewal Purchase";
    }
    if (entry.sourcePurchaseType == "INITIAL_PURCHASE") {
      return "Commission - Initial Purchase";
    }
    if (entry.entryType.toLowerCase() == 'debit') {
      return "Wallet Payout / Debit";
    }
    return "Referral Commission Credit";
  }
}
