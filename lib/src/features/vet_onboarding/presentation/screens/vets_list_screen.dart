import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../providers/vets_list_provider.dart';

class VetsListScreen extends StatefulWidget {
  const VetsListScreen({super.key});

  @override
  State<VetsListScreen> createState() => _VetsListScreenState();
}

class _VetsListScreenState extends State<VetsListScreen> with AppColors {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VetsListProvider>();
      if (provider.doctors.isEmpty) {
        provider.fetchDoctors(isRefresh: true);
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
      body: Consumer<VetsListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchDoctors(isRefresh: true),
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
                    _buildLoadingState()
                  else if (provider.errorMessage != null &&
                      provider.doctors.isEmpty)
                    _buildErrorState(provider)
                  else if (provider.doctors.isEmpty)
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

  Widget _buildHeader(VetsListProvider provider, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Registered Veterinarians",
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 4),
            AppText(
              text: "Total Doctors: ${provider.totalDocs}",
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
          onTap: () => provider.fetchDoctors(isRefresh: true),
        ),
      ],
    );
  }

  Widget _buildFilterBar(VetsListProvider provider, bool isDesktop) {
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
                  hintText: "Search doctor by name, email, phone...",
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

  Widget _buildDesktopDataTable(VetsListProvider provider) {
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
            2: FlexColumnWidth(1.4),
            3: FlexColumnWidth(1.1),
            4: FlexColumnWidth(1.1),
            5: FlexColumnWidth(0.9),
            6: FlexColumnWidth(0.8),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: backgroundColor),
              children: [
                _buildHeaderCell("Doctor"),
                _buildHeaderCell("Contact"),
                _buildHeaderCell("Designation / Category"),
                _buildHeaderCell("Fee / Appt"),
                _buildHeaderCell("Status"),
                _buildHeaderCell("Experience"),
                _buildHeaderCell("Action"),
              ],
            ),
            ...provider.doctors.map((doctor) {
              return TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                children: [
                  _buildDoctorCell(doctor),
                  _buildContactCell(doctor),
                  _buildDesignationCell(doctor),
                  _buildFeeCell(doctor),
                  _buildStatusCell(doctor.status),
                  _buildExperienceCell(doctor),
                  _buildActionCell(doctor),
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

  Widget _buildDoctorCell(DoctorItemEntity doctor) {
    final initial = doctor.fullName.isNotEmpty
        ? doctor.fullName.substring(0, 1).toUpperCase()
        : "D";

    return InkWell(
      onTap: () => context.push('/vets/${doctor.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: primaryColor.withValues(alpha: 0.12),
              child: AppText(
                text: initial,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: doctor.fullName,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  if (doctor.longAutoIncrementId != null)
                    AppText(
                      text: doctor.longAutoIncrementId!,
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

  Widget _buildContactCell(DoctorItemEntity doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(text: doctor.email, fontSize: 12, color: textPrimaryColor),
          if (doctor.phone != null && doctor.phone!.isNotEmpty)
            AppText(
              text: doctor.phone!,
              fontSize: 11,
              color: textSecondaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildDesignationCell(DoctorItemEntity doctor) {
    final spec = doctor.specialities.isNotEmpty
        ? doctor.specialities.first.title
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: doctor.designation ?? "General Vet",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          if (spec != null)
            AppText(text: spec, fontSize: 11, color: textSecondaryColor),
        ],
      ),
    );
  }

  Widget _buildFeeCell(DoctorItemEntity doctor) {
    final fee = doctor.pricePerAppointment?.price;
    final currency = doctor.pricePerAppointment?.currencyCode ?? "USD";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text: fee != null ? "$currency $fee" : "N/A",
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'approved':
        bg = lightGreenColor;
        fg = successColor;
        break;
      case 'pending':
        bg = lightYellowColor;
        fg = yellowColor;
        break;
      case 'in review':
        bg = lightSkyBlueColor;
        fg = skyBlueColor;
        break;
      case 'declined':
      case 'blocked':
        bg = peachColor;
        fg = errorColor;
        break;
      default:
        bg = borderColor;
        fg = textSecondaryColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            text: status,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceCell(DoctorItemEntity doctor) {
    final exp = doctor.yearsOfWorkExperience;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text: exp != null ? "$exp yrs" : "N/A",
        fontSize: 12,
        color: textPrimaryColor,
      ),
    );
  }

  Widget _buildActionCell(DoctorItemEntity doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: primaryColor,
        ),
        tooltip: "View Doctor Details",
        onPressed: () => context.push('/vets/${doctor.id}'),
      ),
    );
  }

  Widget _buildMobileList(VetsListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.doctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doctor = provider.doctors[index];
        return InkWell(
          onTap: () => context.push('/vets/${doctor.id}'),
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
                      backgroundColor: primaryColor.withValues(alpha: 0.12),
                      child: AppText(
                        text: doctor.fullName.isNotEmpty
                            ? doctor.fullName.substring(0, 1).toUpperCase()
                            : "D",
                        fontSize: 16,
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
                            text: doctor.fullName,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                          if (doctor.designation != null)
                            AppText(
                              text: doctor.designation!,
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                        ],
                      ),
                    ),
                    _buildStatusCell(doctor.status),
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
                          text: "Email",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                        AppText(
                          text: doctor.email,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    if (doctor.pricePerAppointment?.price != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            text: "Fee",
                            fontSize: 11,
                            color: textSecondaryColor,
                          ),
                          AppText(
                            text:
                                "${doctor.pricePerAppointment!.currencyCode ?? 'USD'} ${doctor.pricePerAppointment!.price}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
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

  Widget _buildPaginationControls(VetsListProvider provider, bool isDesktop) {
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

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
          ),
          const SizedBox(height: 16),
          AppText(
            text: "Loading registered doctors...",
            fontSize: 13,
            color: textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(VetsListProvider provider) {
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
            text: provider.errorMessage ?? "Failed to load doctors",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Try Again",
            height: 36,
            radius: 8,
            onTap: () => provider.fetchDoctors(isRefresh: true),
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
          Icon(
            Icons.person_search_rounded,
            color: textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          AppText(
            text: "No veterinarians found",
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
}
