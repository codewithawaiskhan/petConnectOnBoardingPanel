import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shared_operating_schedule_card.dart';
import '../../../../shared/presentation/widgets/shimmers/profile_detail_shimmer.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../providers/vet_detail_provider.dart';

class VetDetailScreen extends StatefulWidget {
  final String id;

  const VetDetailScreen({super.key, required this.id});

  @override
  State<VetDetailScreen> createState() => _VetDetailScreenState();
}

class _VetDetailScreenState extends State<VetDetailScreen> with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VetDetailProvider>().fetchDoctorDetail(widget.id);
    });
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
              context.go('/vets-list');
            }
          },
          tooltip: "Back to list",
        ),
        title: AppText(
          text: "Doctor Details",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textSecondaryColor),
            tooltip: "Refresh Details",
            onPressed: () => context
                .read<VetDetailProvider>()
                .fetchDoctorDetail(widget.id, forceRefresh: true),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: Consumer<VetDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ProfileDetailShimmer(isDesktop: isDesktop);
          }

          if (provider.errorMessage != null && provider.doctor == null) {
            return _buildErrorState(provider);
          }

          final doctor = provider.doctor;
          if (doctor == null) {
            return _buildNotFoundState();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(doctor, isDesktop),
                const SizedBox(height: 20),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildBioCard(doctor),
                            const SizedBox(height: 20),
                            _buildSpecialitiesCard(doctor),
                            const SizedBox(height: 20),
                            _buildServicesCard(doctor),
                            const SizedBox(height: 20),
                            _buildLicensesCard(doctor),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildContactCard(doctor),
                            const SizedBox(height: 20),
                            _buildPricingCard(doctor),
                            const SizedBox(height: 20),
                            _buildClinicsCard(doctor),
                            const SizedBox(height: 20),
                            SharedOperatingScheduleCard(
                              availableDays: doctor.availableDays,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildBioCard(doctor),
                  const SizedBox(height: 16),
                  _buildContactCard(doctor),
                  const SizedBox(height: 16),
                  _buildPricingCard(doctor),
                  const SizedBox(height: 16),
                  _buildSpecialitiesCard(doctor),
                  const SizedBox(height: 16),
                  _buildServicesCard(doctor),
                  const SizedBox(height: 16),
                  _buildLicensesCard(doctor),
                  const SizedBox(height: 16),
                  _buildClinicsCard(doctor),
                  const SizedBox(height: 16),
                  SharedOperatingScheduleCard(
                    availableDays: doctor.availableDays,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(DoctorItemEntity doctor, bool isDesktop) {
    final initial = doctor.fullName.isNotEmpty
        ? doctor.fullName.substring(0, 1).toUpperCase()
        : "D";

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isDesktop ? 36 : 28,
            backgroundColor: primaryColor.withValues(alpha: 0.12),
            child: AppText(
              text: initial,
              fontSize: isDesktop ? 28 : 22,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
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
                            text: doctor.fullName,
                            fontSize: isDesktop ? 20 : 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: doctor.designation ?? "Veterinary Doctor",
                            fontSize: 13,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(doctor.status),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (doctor.longAutoIncrementId != null)
                      _buildMetaChip(
                        Icons.badge_outlined,
                        "ID: ${doctor.longAutoIncrementId}",
                      ),
                    if (doctor.yearsOfWorkExperience != null)
                      _buildMetaChip(
                        Icons.work_history_outlined,
                        "${doctor.yearsOfWorkExperience} Years Exp",
                      ),
                    if (doctor.gender != null)
                      _buildMetaChip(
                        Icons.person_outline_rounded,
                        doctor.gender!,
                      ),
                    if (doctor.timeZone != null)
                      _buildMetaChip(Icons.schedule_rounded, doctor.timeZone!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textSecondaryColor),
        const SizedBox(width: 4),
        AppText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: AppText(
        text: status,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
    );
  }

  Widget _buildBioCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Biography",
      icon: Icons.notes_rounded,
      child: AppText(
        text: doctor.bio != null && doctor.bio!.isNotEmpty
            ? doctor.bio!
            : "No biography provided.",
        fontSize: 13,
        height: 1.5,
        color: textPrimaryColor,
        maxLines: 10,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _buildContactCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Contact & Location",
      icon: Icons.contact_mail_outlined,
      child: Column(
        children: [
          _buildInfoRow("Email", doctor.email, icon: Icons.email_outlined),
          const Divider(height: 16),
          _buildInfoRow(
            "Phone",
            doctor.phone ?? "N/A",
            icon: Icons.phone_outlined,
          ),
          const Divider(height: 16),
          _buildInfoRow(
            "Location",
            "${doctor.city ?? ''}${doctor.province != null ? ', ${doctor.province}' : ''} ${doctor.countryName ?? doctor.countryCode ?? ''}"
                .trim(),
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(DoctorItemEntity doctor) {
    final fee = doctor.pricePerAppointment?.price;
    final currency = doctor.pricePerAppointment?.currencyCode ?? "USD";

    return _buildCard(
      title: "Appointment Pricing",
      icon: Icons.payments_outlined,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: "Standard Consultation Fee",
            fontSize: 13,
            color: textSecondaryColor,
          ),
          AppText(
            text: fee != null ? "$currency $fee" : "Not Set",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialitiesCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Specialities",
      icon: Icons.medical_services_outlined,
      child: doctor.specialities.isEmpty
          ? AppText(
              text: "No specialities listed.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctor.specialities.map((s) {
                return Chip(
                  backgroundColor: primaryColor.withValues(alpha: 0.08),
                  side: BorderSide(color: primaryColor.withValues(alpha: 0.2)),
                  label: AppText(
                    text: s.title,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildServicesCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Services Offered",
      icon: Icons.healing_outlined,
      child: doctor.services.isEmpty
          ? AppText(
              text: "No services listed.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Column(
              children: doctor.services.map((s) {
                final displayName =
                    (s.serviceName != null && s.serviceName!.isNotEmpty)
                    ? s.serviceName!
                    : (s.serviceId != null
                          ? "Service #${s.serviceId}"
                          : "Service #${s.id}");

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          text: displayName,
                          fontSize: 13,
                          color: textPrimaryColor,
                        ),
                      ),
                      if (s.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            text: s.status!,
                            fontSize: 10,
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

  Widget _buildLicensesCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Licenses & Verification",
      icon: Icons.verified_outlined,
      child: doctor.licenses.isEmpty
          ? AppText(
              text: "No licenses recorded.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Column(
              children: doctor.licenses.map((lic) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text:
                                "${lic.state ?? 'State'} (${lic.stateAbbreviation ?? ''})",
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          if (lic.number != null)
                            AppText(
                              text: "License #: ${lic.number}",
                              fontSize: 11,
                              color: textSecondaryColor,
                            ),
                        ],
                      ),
                      if (lic.expiryDate != null)
                        AppText(
                          text: "Expires: ${lic.expiryDate!.substring(0, 10)}",
                          fontSize: 11,
                          color: textSecondaryColor,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildClinicsCard(DoctorItemEntity doctor) {
    return _buildCard(
      title: "Affiliated Clinics",
      icon: Icons.local_hospital_outlined,
      child: doctor.clinics.isEmpty
          ? AppText(
              text: "No clinics linked.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Column(
              children: doctor.clinics.map((c) {
                final clinicTitle = (c.title != null && c.title!.isNotEmpty)
                    ? c.title!
                    : "Clinic #${c.id}";
                final locationParts = [
                  if (c.address != null && c.address!.isNotEmpty) c.address!,
                  if (c.city != null && c.city!.isNotEmpty) c.city!,
                  if (c.province != null && c.province!.isNotEmpty) c.province!,
                ].join(", ");

                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: clinicTitle,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                            if (locationParts.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              AppText(
                                text: locationParts,
                                fontSize: 11,
                                color: textSecondaryColor,
                              ),
                            ],
                            if (c.phone != null && c.phone!.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              AppText(
                                text: "Phone: ${c.phone!}",
                                fontSize: 11,
                                color: textSecondaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (c.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                          ),
                          child: AppText(
                            text: c.status!,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
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

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: textSecondaryColor),
          const SizedBox(width: 8),
        ],
        AppText(text: label, fontSize: 12, color: textSecondaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: AppText(
            text: value.isNotEmpty ? value : "N/A",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
            textAlign: TextAlign.end,
            maxLines: 4,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(VetDetailProvider provider) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: errorColor, size: 48),
            const SizedBox(height: 14),
            AppText(
              text: provider.errorMessage ?? "Failed to load doctor profile",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: "Retry",
              height: 38,
              radius: 8,
              onTap: () =>
                  provider.fetchDoctorDetail(widget.id, forceRefresh: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              color: textSecondaryColor,
              size: 48,
            ),
            const SizedBox(height: 14),
            AppText(
              text: "Doctor record not found",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
