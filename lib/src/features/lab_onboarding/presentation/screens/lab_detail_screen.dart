import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/mini_functions.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shared_operating_schedule_card.dart';
import '../../../../shared/presentation/widgets/shimmers/profile_detail_shimmer.dart';
import '../../domain/entities/lab_entity.dart';
import '../dialogs/edit_lab_dialog.dart';
import '../providers/lab_detail_provider.dart';
import '../providers/labs_list_provider.dart';

class LabDetailScreen extends StatefulWidget {
  final String id;

  const LabDetailScreen({super.key, required this.id});

  @override
  State<LabDetailScreen> createState() => _LabDetailScreenState();
}

class _LabDetailScreenState extends State<LabDetailScreen> with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabDetailProvider>().fetchLabDetail(widget.id);
    });
  }

  Future<void> _handleEdit(LabItemEntity lab) async {
    final updated = await EditLabDialog.show(context, lab: lab);
    if (updated == true && mounted) {
      context.read<LabDetailProvider>().fetchLabDetail(
        widget.id,
        forceRefresh: true,
      );
    }
  }

  void _showDeleteConfirmationDialog(LabItemEntity lab) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Lab",
      message:
          "Are you sure you want to delete ${lab.title.isNotEmpty ? lab.title : 'this diagnostic lab'}?",
      confirmText: "Delete",
      onConfirm: () async {
        if (!mounted) return;
        final provider = context.read<LabsListProvider>();
        final success = await provider.deleteLab(context: context, id: lab.id);
        if (success && mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/labs');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColor),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/labs');
            }
          },
          tooltip: "Back to labs list",
        ),
        title: AppText(
          text: "Diagnostic Lab Details",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textSecondaryColor),
            tooltip: "Refresh Details",
            onPressed: () => context.read<LabDetailProvider>().fetchLabDetail(
              widget.id,
              forceRefresh: true,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: Consumer<LabDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ProfileDetailShimmer(isDesktop: isDesktop);
          }

          if (provider.errorMessage != null && provider.lab == null) {
            return _buildErrorState(provider);
          }

          final lab = provider.lab;
          if (lab == null) {
            return _buildNotFoundState();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(lab, isDesktop),
                const SizedBox(height: 20),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildBioCard(lab),
                            const SizedBox(height: 20),
                            _buildLabTestCategoriesCard(lab),
                            const SizedBox(height: 20),
                            _buildPetCategoriesCard(lab),
                            const SizedBox(height: 20),
                            _buildLicensesCard(lab),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildContactLocationCard(lab),
                            const SizedBox(height: 20),
                            SharedOperatingScheduleCard(
                              availableDays: lab.availableDays,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildBioCard(lab),
                  const SizedBox(height: 16),
                  _buildContactLocationCard(lab),
                  const SizedBox(height: 16),
                  _buildLabTestCategoriesCard(lab),
                  const SizedBox(height: 16),
                  _buildPetCategoriesCard(lab),
                  const SizedBox(height: 16),
                  SharedOperatingScheduleCard(availableDays: lab.availableDays),
                  const SizedBox(height: 16),
                  _buildLicensesCard(lab),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(LabItemEntity lab, bool isDesktop) {
    final initial = lab.title.isNotEmpty
        ? lab.title.substring(0, 1).toUpperCase()
        : "L";

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isDesktop ? 36 : 28,
                backgroundColor: tertiaryColor.withValues(alpha: 0.14),
                child: AppText(
                  text: initial,
                  fontSize: isDesktop ? 26 : 20,
                  fontWeight: FontWeight.w700,
                  color: tertiaryColor,
                ),
              ),
              SizedBox(width: isDesktop ? 20 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: lab.title,
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: lab.labType ?? "Diagnostic Laboratory",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lab.designation != null &&
                        lab.designation!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: AppText(
                          text: "Designation: ${lab.designation}",
                          fontSize: 12,
                          color: textSecondaryColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                status: lab.status,
                fontSize: 12,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    size: 15,
                    color: textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: AppText(
                      text: lab.email,
                      fontSize: 12,
                      color: textSecondaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (lab.phone != null && lab.phone!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 15,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: AppText(
                        text: lab.phone!,
                        fontSize: 12,
                        color: textSecondaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (lab.city != null && lab.city!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: AppText(
                        text: lab.city!,
                        fontSize: 12,
                        color: textSecondaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: borderColor),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                CustomButton(
                  text: "Edit Details",
                  isIcon: true,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: primaryColor,
                  ),
                  height: 36,
                  width: 122,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  radius: 8,
                  fillColor: primaryColor.withValues(alpha: 0.08),
                  textColor: primaryColor,
                  buttonBorder: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  onTap: () => _handleEdit(lab),
                ),
                CustomButton(
                  text: "Delete",
                  isIcon: true,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 15,
                    color: errorColor,
                  ),
                  height: 36,
                  width: 96,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  radius: 8,
                  fillColor: errorColor.withValues(alpha: 0.08),
                  textColor: errorColor,
                  buttonBorder: Border.all(
                    color: errorColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  onTap: () =>
                      _showDeleteConfirmationDialog(lab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBioCard(LabItemEntity lab) {
    return _buildCardWrapper(
      title: "Lab Bio & Overview",
      icon: Icons.info_outline_rounded,
      child: lab.bio != null && lab.bio!.trim().isNotEmpty
          ? Row(
              children: [
                Expanded(
                  child: AppText(
                    text: lab.bio!,
                    fontSize: 13,
                    color: textPrimaryColor,
                    height: 1.6,
                    maxLines: 30,
                  ),
                ),
              ],
            )
          : AppText(
              text: "No bio or overview information provided.",
              fontSize: 13,
              color: textSecondaryColor,
            ),
    );
  }

  Widget _buildContactLocationCard(LabItemEntity lab) {
    final locationParts = [
      if (lab.address != null && lab.address!.isNotEmpty) lab.address!,
      if (lab.city != null && lab.city!.isNotEmpty) lab.city!,
      if (lab.state != null && lab.state!.isNotEmpty) lab.state!,
      if (lab.country != null && lab.country!.isNotEmpty) lab.country!,
    ].join(', ');

    return _buildCardWrapper(
      title: "Contact & Location",
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            label: "Address",
            value: locationParts.isNotEmpty ? locationParts : "Not specified",
            icon: Icons.map_outlined,
          ),
          const Divider(height: 20),
          _buildInfoRow(
            label: "Email",
            value: lab.email,
            icon: Icons.mail_outline_rounded,
          ),
          if (lab.phone != null && lab.phone!.isNotEmpty) ...[
            const Divider(height: 20),
            _buildInfoRow(
              label: "Phone",
              value: lab.phone!,
              icon: Icons.phone_outlined,
            ),
          ],
          if (lab.location != null) ...[
            if (lab.location!.calculatedLatitude != null &&
                lab.location!.calculatedLongitude != null) ...[
              const Divider(height: 20),
              _buildInfoRow(
                label: "GPS Coordinates",
                value:
                    "${lab.location!.calculatedLatitude!.toStringAsFixed(4)}, ${lab.location!.calculatedLongitude!.toStringAsFixed(4)}",
                icon: Icons.my_location_rounded,
              ),
            ],
          ],
          if (lab.createdAt != null) ...[
            const Divider(height: 20),
            _buildInfoRow(
              label: "Registered On",
              value: _formatDisplayDateTime(lab.createdAt),
              icon: Icons.calendar_today_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: textSecondaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: label,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 2),
              AppText(
                text: value,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabTestCategoriesCard(LabItemEntity lab) {
    return _buildCardWrapper(
      title: "Diagnostic Test Categories",
      icon: Icons.biotech_outlined,
      child: lab.labTestCategories.isEmpty
          ? AppText(
              text: "No test categories registered for this lab.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Wrap(
              spacing: 10,
              runSpacing: 10,
              children: lab.labTestCategories.map((cat) {
                final categoryTitle = cat.title.isNotEmpty
                    ? cat.title
                    : "Test Category";
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: tertiaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: tertiaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.science_outlined,
                        size: 14,
                        color: tertiaryColor,
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        text: categoryTitle,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildPetCategoriesCard(LabItemEntity lab) {
    return _buildCardWrapper(
      title: "Pet Species Supported",
      icon: Icons.pets_outlined,
      child: lab.petCategories.isEmpty
          ? AppText(
              text: "No pet species specified for this lab.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Wrap(
              spacing: 10,
              runSpacing: 10,
              children: lab.petCategories.map((petCat) {
                final speciesTitle = petCat.title.isNotEmpty
                    ? petCat.title
                    : "Pet Species";
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pets, size: 14, color: primaryColor),
                      const SizedBox(width: 6),
                      AppText(
                        text: speciesTitle,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildLicensesCard(LabItemEntity lab) {
    return _buildCardWrapper(
      title: "Licenses & Certifications",
      icon: Icons.verified_outlined,
      child: lab.licenses.isEmpty
          ? AppText(
              text: "No licenses or certifications recorded.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Column(
              children: lab.licenses.map((lic) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.badge_outlined,
                          size: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "License #: ${lic.number ?? 'N/A'}",
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (lic.state != null && lic.state!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: AppText(
                                  text: "State: ${lic.state}",
                                  fontSize: 11,
                                  color: textSecondaryColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (lic.expiryDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                          ),
                          child: AppText(
                            text: "Expires: ${_formatDisplayDate(lic.expiryDate)}",
                            fontSize: 11,
                            color: textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildErrorState(LabDetailProvider provider) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
            const SizedBox(height: 14),
            AppText(
              text: "Failed to load lab details",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 8),
            AppText(
              text: provider.errorMessage ?? "An unexpected error occurred.",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Retry",
              width: 120,
              height: 40,
              radius: 8,
              onTap: () =>
                  provider.fetchLabDetail(widget.id, forceRefresh: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: textSecondaryColor),
            const SizedBox(height: 14),
            AppText(
              text: "Diagnostic Lab Not Found",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 8),
            AppText(
              text:
                  "The requested diagnostic lab could not be found or has been removed.",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Back to Labs",
              width: 140,
              height: 40,
              radius: 8,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/labs');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDisplayDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("MMM dd, yyyy").format(dt);
    } catch (_) {
      final ymd = MiniFunctions().formatDateToYMD(rawDate);
      return ymd.isNotEmpty ? ymd : rawDate;
    }
  }

  String _formatDisplayDateTime(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("MMM dd, yyyy, hh:mm a").format(dt);
    } catch (_) {
      return rawDate;
    }
  }
}
