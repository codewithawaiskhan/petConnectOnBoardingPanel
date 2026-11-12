import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/bootstrap_pagination.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../marketing_companies/presentation/providers/marketing_company_list_provider.dart';
import '../../domain/entities/commission_settings_entity.dart';
import '../dialogs/create_company_policy_dialog.dart';
import '../dialogs/create_global_settings_dialog.dart';
import '../providers/commission_settings_provider.dart';

class CommissionSettingsScreen extends StatefulWidget {
  const CommissionSettingsScreen({super.key});

  @override
  State<CommissionSettingsScreen> createState() =>
      _CommissionSettingsScreenState();
}

class _CommissionSettingsScreenState extends State<CommissionSettingsScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = context.read<CommissionSettingsProvider>();
      if (settingsProvider.globalSettings == null) {
        settingsProvider.fetchGlobalSettings();
      }
      if (settingsProvider.companyPolicies.isEmpty) {
        settingsProvider.fetchCompanyPolicies(isRefresh: true);
      }

      final companiesProvider = context.read<MarketingCompanyListProvider>();
      if (companiesProvider.companies.isEmpty) {
        companiesProvider.fetchCompanies(isRefresh: true);
      }
    });
  }

  String _formatDate(String dateStr) {
    if (dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatShortDate(String dateStr) {
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24.0 : 16.0,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: primaryColor,
                unselectedLabelColor: textSecondaryColor,
                indicatorColor: primaryColor,
                indicatorWeight: 2.5,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.public_rounded, size: 18),
                    iconMargin: EdgeInsets.only(bottom: 4),
                    text: "Global Settings",
                  ),
                  Tab(
                    icon: Icon(Icons.business_center_outlined, size: 18),
                    iconMargin: EdgeInsets.only(bottom: 4),
                    text: "Company Policies",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGlobalSettingsTab(isDesktop),
                  _buildCompanyPoliciesTab(isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalSettingsTab(bool isDesktop) {
    return Consumer<CommissionSettingsProvider>(
      builder: (context, provider, _) {
        final settings = provider.globalSettings;

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => provider.fetchGlobalSettings(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                              text: "Global Renewal & Commission Settings",
                              fontSize: isDesktop ? 20 : 17,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              text:
                                  "Default influencer rewards and marketing company commission rates",
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
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: primaryColor,
                            ),
                            height: 38,
                            radius: 8,
                            onTap: () => provider.fetchGlobalSettings(),
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: "Create New Version",
                            isIcon: true,
                            icon: Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: whiteColor,
                            ),
                            height: 38,
                            radius: 8,
                            onTap: () => CreateGlobalSettingsDialog.show(
                              context,
                              currentSettings: settings,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.isLoadingGlobalSettings)
                  DataTableShimmer(
                    isDesktop: isDesktop,
                    rowCount: 3,
                    headers: const [
                      "Setting",
                      "Status",
                      "Value",
                      "Effective From",
                    ],
                  )
                else if (provider.globalErrorMessage != null &&
                    settings == null)
                  _buildErrorCard(
                    message: provider.globalErrorMessage!,
                    onRetry: () => provider.fetchGlobalSettings(),
                  )
                else if (settings == null)
                  _buildEmptyCard(
                    icon: Icons.tune_rounded,
                    title: "No Global Settings Found",
                    subtitle:
                        "Create your first global commission & referral reward version.",
                  )
                else
                  _buildGlobalSettingsCards(settings, isDesktop),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlobalSettingsCards(
    RenewalCommissionSettingsEntity settings,
    bool isDesktop,
  ) {
    final firstRewardText = settings.isReferralRewardOnFirstPurchaseEnabled
        ? "${settings.referralRewardOnFirstPurchase?.currencyCode ?? 'USD'} ${settings.referralRewardOnFirstPurchase?.amount ?? 0}"
        : "Disabled";
    final renewalRewardText = settings.isReferralRewardOnRenewalEnabled
        ? "${settings.referralRewardOnRenewal?.currencyCode ?? 'USD'} ${settings.referralRewardOnRenewal?.amount ?? 0}"
        : "Disabled";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          text: "Version ${settings.version}",
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const StatusBadge(status: "Active"),
                    ],
                  ),
                  AppText(
                    text: "Effective: ${_formatDate(settings.effectiveFrom)}",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTwoCol = constraints.maxWidth >= 700;
                  final rewardCard = _buildInfoGroupCard(
                    title: "Influencer Referral Rewards",
                    icon: Icons.card_giftcard_rounded,
                    rows: [
                      _InfoRowData(
                        label: "First Purchase Reward",
                        value: firstRewardText,
                        isEnabled:
                            settings.isReferralRewardOnFirstPurchaseEnabled,
                      ),
                      _InfoRowData(
                        label: "Renewal Reward",
                        value: renewalRewardText,
                        isEnabled: settings.isReferralRewardOnRenewalEnabled,
                      ),
                    ],
                  );
                  final commissionCard = _buildInfoGroupCard(
                    title: "Default Company Commissions",
                    icon: Icons.percent_rounded,
                    rows: [
                      _InfoRowData(
                        label: "First Purchase Commission",
                        value: "${settings.commissionRateOnFirstPurchase}%",
                        isEnabled: settings.isCommissionOnFirstPurchaseEnabled,
                      ),
                      _InfoRowData(
                        label: "Renewal Commission",
                        value: "${settings.commissionRateOnRenewal}%",
                        isEnabled: settings.isCommissionOnRenewalEnabled,
                      ),
                    ],
                  );

                  if (isTwoCol) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: rewardCard),
                        const SizedBox(width: 16),
                        Expanded(child: commissionCard),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      rewardCard,
                      const SizedBox(height: 16),
                      commissionCard,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnabledBadge(bool isEnabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isEnabled ? lightGreenColor : borderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isEnabled ? successColor : textSecondaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          AppText(
            text: isEnabled ? "Enabled" : "Disabled",
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isEnabled ? successColor : textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGroupCard({
    required String title,
    required IconData icon,
    required List<_InfoRowData> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: primaryColor),
              const SizedBox(width: 8),
              AppText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          r.isEnabled
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 16,
                          color: r.isEnabled ? successColor : textSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: AppText(
                            text: r.label,
                            fontSize: 13,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildEnabledBadge(r.isEnabled),
                  const SizedBox(width: 10),
                  AppText(
                    text: r.value,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: r.isEnabled ? primaryColor : textSecondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyPoliciesTab(bool isDesktop) {
    final companiesProvider = context.watch<MarketingCompanyListProvider>();
    final companies = companiesProvider.companies;

    return Consumer<CommissionSettingsProvider>(
      builder: (context, provider, _) {
        final effectiveSelectedId =
            (provider.selectedCompanyId != null &&
                    companies.any((c) => c.id == provider.selectedCompanyId))
                ? provider.selectedCompanyId
                : null;

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => provider.fetchCompanyPolicies(
            companyId: provider.selectedCompanyId,
            isRefresh: true,
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                              text: "Company Commission Policies",
                              fontSize: isDesktop ? 20 : 17,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              text: "Total Policies: ${provider.totalDocs}",
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
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: primaryColor,
                            ),
                            height: 38,
                            radius: 8,
                            onTap: () => provider.fetchCompanyPolicies(
                              companyId: provider.selectedCompanyId,
                              isRefresh: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: "Assign New Policy",
                            isIcon: true,
                            icon: Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: whiteColor,
                            ),
                            height: 38,
                            radius: 8,
                            onTap: () => CreateCompanyPolicyDialog.show(
                              context,
                              initialCompanyId: provider.selectedCompanyId,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 10),
                      AppText(
                        text: "Filter by Company:",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String?>(
                              isExpanded: true,
                              value: effectiveSelectedId,
                              hint: AppText(
                                text: "All Companies",
                                fontSize: 13,
                                color: textPrimaryColor,
                              ),
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: AppText(
                                    text: "All Companies",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimaryColor,
                                  ),
                                ),
                                ...companies.map((c) {
                                  return DropdownMenuItem<String?>(
                                    value: c.id,
                                    child: AppText(
                                      text: c.longAutoIncrementId.isNotEmpty
                                          ? "${c.displayName} (${c.longAutoIncrementId})"
                                          : c.displayName,
                                      fontSize: 13,
                                      color: textPrimaryColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (val) =>
                                  provider.setSelectedCompany(val),
                              buttonStyleData: ButtonStyleData(
                                height: 42,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 260,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (provider.selectedCompanyId != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: errorColor,
                          ),
                          tooltip: "Clear Company Filter",
                          onPressed: () => provider.setSelectedCompany(null),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.isLoadingCompanyPolicies)
                  _buildPoliciesShimmer(isDesktop)
                else if (provider.policiesErrorMessage != null &&
                    provider.companyPolicies.isEmpty)
                  _buildErrorCard(
                    message: provider.policiesErrorMessage!,
                    onRetry: () => provider.fetchCompanyPolicies(
                      companyId: provider.selectedCompanyId,
                      isRefresh: true,
                    ),
                  )
                else if (provider.companyPolicies.isEmpty)
                  _buildEmptyCard(
                    icon: Icons.percent_rounded,
                    title: "No Company Policies Found",
                    subtitle:
                        "Assign a custom commission policy to a marketing company.",
                  )
                else ...[
                  if (provider.isPaginationLoading)
                    _buildPoliciesShimmer(isDesktop)
                  else if (isDesktop)
                    _buildPoliciesDesktopTable(provider)
                  else
                    _buildPoliciesMobileList(provider),
                  const SizedBox(height: 24),
                  _buildPaginationControls(provider),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPoliciesShimmer(bool isDesktop) {
    return DataTableShimmer(
      isDesktop: isDesktop,
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1.3),
        2: FlexColumnWidth(1.3),
        3: FlexColumnWidth(1.3),
        4: FlexColumnWidth(1.3),
        5: FlexColumnWidth(1.6),
      },
      headers: const [
        "Company Name",
        "First Purchase Rate (%)",
        "Renewal Rate (%)",
        "First Purchase Enabled",
        "Renewal Enabled",
        "Effective From",
      ],
    );
  }

  Widget _buildPoliciesDesktopTable(CommissionSettingsProvider provider) {
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
                columnSpacing: 22,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: AppText(
                      text: "Company Name",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "First Purchase Rate (%)",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Renewal Rate (%)",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "First Purchase Enabled",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Renewal Enabled",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Effective From",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
                rows: provider.companyPolicies.map((policy) {
                  final companyName =
                      policy.company?.displayName.isNotEmpty == true
                          ? policy.company!.displayName
                          : "—";

                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: companyName,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                            AppText(
                              text: "Version ${policy.version}",
                              fontSize: 11,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        AppText(
                          text: "${policy.commissionRateOnFirstPurchase}%",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      DataCell(
                        AppText(
                          text: "${policy.commissionRateOnRenewal}%",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      DataCell(
                        _buildEnabledBadge(
                          policy.isCommissionOnFirstPurchaseEnabled,
                        ),
                      ),
                      DataCell(
                        _buildEnabledBadge(
                          policy.isCommissionOnRenewalEnabled,
                        ),
                      ),
                      DataCell(
                        AppText(
                          text: _formatShortDate(policy.effectiveFrom),
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

  Widget _buildPoliciesMobileList(CommissionSettingsProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.companyPolicies.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final policy = provider.companyPolicies[index];
        final companyName = policy.company?.displayName.isNotEmpty == true
            ? policy.company!.displayName
            : "—";

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      text: companyName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppText(
                    text: "v${policy.version}",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text:
                        "First Purchase: ${policy.commissionRateOnFirstPurchase}%",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  _buildEnabledBadge(policy.isCommissionOnFirstPurchaseEnabled),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Renewal: ${policy.commissionRateOnRenewal}%",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  _buildEnabledBadge(policy.isCommissionOnRenewalEnabled),
                ],
              ),
              const SizedBox(height: 8),
              AppText(
                text: "Effective: ${_formatShortDate(policy.effectiveFrom)}",
                fontSize: 11,
                color: textSecondaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(CommissionSettingsProvider provider) {
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
                    "Showing page ${provider.currentPage} of ${provider.totalPages > 0 ? provider.totalPages : 1} (${provider.totalDocs} policies)",
                fontFamily: fontPoppins,
                fontSize: 12,
                color: textSecondaryColor,
              ),
              ItemsPerPageDropdown(
                currentLimit: provider.limit,
                isEnabled:
                    !provider.isPaginationLoading &&
                    !provider.isLoadingCompanyPolicies,
                onLimitChanged: (newLimit) => provider.setLimit(newLimit),
              ),
            ],
          );

          final pagination = BootstrapPagination(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            isEnabled:
                !provider.isPaginationLoading &&
                !provider.isLoadingCompanyPolicies,
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

  Widget _buildErrorCard({
    required String message,
    required VoidCallback onRetry,
  }) {
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
            text: message,
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
            onTap: onRetry,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
          Icon(icon, color: textSecondaryColor, size: 48),
          const SizedBox(height: 12),
          AppText(
            text: title,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: subtitle,
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoRowData {
  final String label;
  final String value;
  final bool isEnabled;

  const _InfoRowData({
    required this.label,
    required this.value,
    required this.isEnabled,
  });
}

