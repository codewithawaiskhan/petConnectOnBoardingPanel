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
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/assignment_request_entity.dart';
import '../providers/assignment_requests_provider.dart';

class AssignmentRequestsScreen extends StatefulWidget {
  const AssignmentRequestsScreen({super.key});

  @override
  State<AssignmentRequestsScreen> createState() =>
      _AssignmentRequestsScreenState();
}

class _AssignmentRequestsScreenState extends State<AssignmentRequestsScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AssignmentRequestsProvider>();
      if (provider.requests.isEmpty) {
        provider.fetchRequests(isRefresh: true);
      }
    });
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

  void _confirmStatusUpdate(
    AssignmentRequestEntity request,
    String newStatus,
  ) {
    final actionVerb = newStatus == 'Approved' ? 'approve' : 'decline';
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "${newStatus == 'Approved' ? 'Approve' : 'Decline'} Assignment",
      message: "Are you sure you want to $actionVerb this assignment?",
      confirmText: newStatus == 'Approved' ? 'Approve' : 'Decline',
      cancelText: "Cancel",
      onConfirm: () async {
        if (!mounted) return;
        await context.read<AssignmentRequestsProvider>().updateRequestStatus(
          request.id,
          newStatus,
          context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<AssignmentRequestsProvider>(
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
        0: FlexColumnWidth(2.0),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
      },
      headers: const [
        "Company Name",
        "Influencer Name & Email",
        "Requested On",
        "Status",
        "Actions",
      ],
    );
  }

  Widget _buildHeader(AssignmentRequestsProvider provider, bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Influencer Assignment Requests",
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 170,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: provider.selectedStatus,
                    items: provider.statusFilters.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: AppText(
                          text: status == 'All' ? 'All Statuses' : status,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textPrimaryColor,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.onStatusChanged(val);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 220,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CustomButton(
                text: "Refresh",
                isIcon: true,
                icon: Icon(Icons.refresh_rounded, size: 16, color: whiteColor),
                height: 38,
                radius: 8,
                onTap: () => provider.fetchRequests(isRefresh: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCell(
    AssignmentRequestsProvider provider,
    AssignmentRequestEntity request,
  ) {
    final isSubmitted = request.status.trim().toLowerCase() == 'submitted';
    if (!isSubmitted) {
      return AppText(
        text: "—",
        fontSize: 13,
        color: textSecondaryColor,
      );
    }

    if (provider.isUpdating(request.id)) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: primaryColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(
            Icons.check_circle_outline_rounded,
            size: 20,
            color: successColor,
          ),
          tooltip: "Approve Request",
          splashRadius: 18,
          onPressed: () => _confirmStatusUpdate(request, 'Approved'),
        ),
        const SizedBox(width: 4),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(
            Icons.cancel_outlined,
            size: 20,
            color: errorColor,
          ),
          tooltip: "Decline Request",
          splashRadius: 18,
          onPressed: () => _confirmStatusUpdate(request, 'Declined'),
        ),
      ],
    );
  }

  Widget _buildDesktopDataTable(AssignmentRequestsProvider provider) {
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
                      text: "Company Name",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Influencer Name & Email",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                  DataColumn(
                    label: AppText(
                      text: "Requested On",
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
                  final companyName =
                      request.marketingCompany?.displayName.isNotEmpty == true
                          ? request.marketingCompany!.displayName
                          : "—";
                  final primaryUser =
                      request.users.isNotEmpty ? request.users.first : null;
                  final influencerName =
                      primaryUser?.fullName.isNotEmpty == true
                          ? primaryUser!.fullName
                          : "—";
                  final influencerEmail =
                      primaryUser?.email.isNotEmpty == true
                          ? primaryUser!.email
                          : "—";
                  final extraCount =
                      request.users.length > 1 ? request.users.length - 1 : 0;
                  final timeStr = _formatTime(request.createdAt);

                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.business_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                  text: "Request #${request.autoIncrementId}",
                                  fontSize: 11,
                                  color: textSecondaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: influencerName,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                                if (extraCount > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: AppText(
                                      text: "+$extraCount more",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            AppText(
                              text: influencerEmail,
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ],
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
                        _buildActionsCell(provider, request),
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

  Widget _buildMobileList(AssignmentRequestsProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = provider.requests[index];
        final companyName =
            request.marketingCompany?.displayName.isNotEmpty == true
                ? request.marketingCompany!.displayName
                : "—";
        final primaryUser =
            request.users.isNotEmpty ? request.users.first : null;
        final influencerName = primaryUser?.fullName.isNotEmpty == true
            ? primaryUser!.fullName
            : "—";
        final influencerEmail = primaryUser?.email.isNotEmpty == true
            ? primaryUser!.email
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: companyName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        AppText(
                          text: "Request #${request.autoIncrementId}",
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: request.status),
                ],
              ),
              const Divider(height: 20),
              AppText(
                text: influencerName,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              AppText(
                text: influencerEmail,
                fontSize: 12,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: _formatDate(request.createdAt),
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                  _buildActionsCell(provider, request),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(AssignmentRequestsProvider provider) {
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

  Widget _buildErrorState(AssignmentRequestsProvider provider) {
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
            text: provider.errorMessage ?? "Failed to load assignment requests",
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

  Widget _buildEmptyState(AssignmentRequestsProvider provider) {
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
            Icons.group_add_outlined,
            color: textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No assignment requests found",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: provider.selectedStatus != 'All'
                ? "Try selecting a different status filter."
                : "Influencer assignment requests will appear here.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

