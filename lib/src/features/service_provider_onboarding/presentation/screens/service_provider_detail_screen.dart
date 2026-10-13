import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../providers/service_provider_detail_provider.dart';

class ServiceProviderDetailScreen extends StatefulWidget {
  final String id;

  const ServiceProviderDetailScreen({super.key, required this.id});

  @override
  State<ServiceProviderDetailScreen> createState() =>
      _ServiceProviderDetailScreenState();
}

class _ServiceProviderDetailScreenState
    extends State<ServiceProviderDetailScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProviderDetailProvider>().fetchServiceProviderDetail(
        widget.id,
      );
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
              context.go('/service-providers-list');
            }
          },
          tooltip: "Back to list",
        ),
        title: AppText(
          text: "Service Provider Details",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textSecondaryColor),
            tooltip: "Refresh Details",
            onPressed: () => context
                .read<ServiceProviderDetailProvider>()
                .fetchServiceProviderDetail(widget.id, forceRefresh: true),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: Consumer<ServiceProviderDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.errorMessage != null &&
              provider.serviceProvider == null) {
            return _buildErrorState(provider);
          }

          final sp = provider.serviceProvider;
          if (sp == null) {
            return _buildNotFoundState();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(sp, isDesktop),
                const SizedBox(height: 20),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildBioCard(sp),
                            const SizedBox(height: 20),
                            _buildServicesOfferedCard(sp),
                            const SizedBox(height: 20),
                            _buildPetCategoriesCard(sp),
                            const SizedBox(height: 20),
                            _buildLicensesCard(sp),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildBusinessDetailsCard(sp),
                            const SizedBox(height: 20),
                            _buildPricingCard(sp),
                            const SizedBox(height: 20),
                            _buildServiceLocationsCard(sp),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildBioCard(sp),
                  const SizedBox(height: 16),
                  _buildBusinessDetailsCard(sp),
                  const SizedBox(height: 16),
                  _buildPricingCard(sp),
                  const SizedBox(height: 16),
                  _buildServicesOfferedCard(sp),
                  const SizedBox(height: 16),
                  _buildPetCategoriesCard(sp),
                  const SizedBox(height: 16),
                  _buildServiceLocationsCard(sp),
                  const SizedBox(height: 16),
                  _buildLicensesCard(sp),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(ServiceProviderItemEntity sp, bool isDesktop) {
    final initial = sp.fullName.isNotEmpty
        ? sp.fullName.substring(0, 1).toUpperCase()
        : "S";

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
            backgroundColor: secondaryColor.withValues(alpha: 0.12),
            child: AppText(
              text: initial,
              fontSize: isDesktop ? 28 : 22,
              fontWeight: FontWeight.w700,
              color: secondaryColor,
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
                            text: sp.fullName,
                            fontSize: isDesktop ? 20 : 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text:
                                sp.businessName ?? "Independent Care Provider",
                            fontSize: 13,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(sp.status),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (sp.longAutoIncrementId != null)
                      _buildMetaChip(
                        Icons.badge_outlined,
                        "ID: ${sp.longAutoIncrementId}",
                      ),
                    if (sp.designation != null)
                      _buildMetaChip(
                        Icons.business_center_outlined,
                        sp.designation!,
                      ),
                    if (sp.yearsOfWorkExperience != null)
                      _buildMetaChip(
                        Icons.work_history_outlined,
                        "${sp.yearsOfWorkExperience} Years Exp",
                      ),
                    if (sp.gender != null)
                      _buildMetaChip(Icons.person_outline_rounded, sp.gender!),
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
      case 'declined':
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

  Widget _buildBioCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "About the Provider",
      icon: Icons.notes_rounded,
      child: AppText(
        text: sp.bio != null && sp.bio!.isNotEmpty
            ? sp.bio!
            : "No biography provided.",
        fontSize: 13,
        height: 1.5,
        color: textPrimaryColor,
        maxLines: 10,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _buildBusinessDetailsCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "Business & Contact Information",
      icon: Icons.storefront_outlined,
      child: Column(
        children: [
          _buildInfoRow(
            "Business Name",
            sp.businessName ?? "N/A",
            icon: Icons.business_outlined,
          ),
          const Divider(height: 16),
          _buildInfoRow(
            "Business Email",
            sp.businessEmail ?? sp.email,
            icon: Icons.email_outlined,
          ),
          const Divider(height: 16),
          _buildInfoRow(
            "Business Phone",
            sp.businessPhone ?? sp.phone ?? "N/A",
            icon: Icons.phone_outlined,
          ),
          const Divider(height: 16),
          _buildInfoRow(
            "Address",
            "${sp.address ?? ''}${sp.city != null ? ', ${sp.city}' : ''}${sp.province != null ? ', ${sp.province}' : ''} ${sp.countryName ?? ''}"
                .trim(),
            icon: Icons.location_on_outlined,
          ),
          if (sp.businessZIPCode != null) ...[
            const Divider(height: 16),
            _buildInfoRow(
              "ZIP Code",
              sp.businessZIPCode.toString(),
              icon: Icons.markunread_mailbox_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingCard(ServiceProviderItemEntity sp) {
    final startFee = sp.startingPricePerAppointment?.price;
    final currency =
        sp.startingPricePerAppointment?.currencyCode ??
        sp.pricePerAppointment?.currencyCode ??
        "USD";
    final apptFee = sp.pricePerAppointment?.price;

    return _buildCard(
      title: "Pricing Structure",
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          if (startFee != null) ...[
            _buildInfoRow("Starting Price / Appt", "$currency $startFee"),
            const Divider(height: 16),
          ],
          if (apptFee != null)
            _buildInfoRow("Standard Appointment Fee", "$currency $apptFee"),
        ],
      ),
    );
  }

  Widget _buildServicesOfferedCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "Services Offered",
      icon: Icons.cleaning_services_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sp.servicesOffered.isEmpty)
            AppText(
              text: "No structured services listed.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sp.servicesOffered.map((s) {
                return Chip(
                  backgroundColor: secondaryColor.withValues(alpha: 0.08),
                  side: BorderSide(
                    color: secondaryColor.withValues(alpha: 0.2),
                  ),
                  label: AppText(
                    text: s.title ?? "Service #${s.id}",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                );
              }).toList(),
            ),
          if (sp.otherService != null && sp.otherService!.isNotEmpty) ...[
            const SizedBox(height: 14),
            AppText(
              text: "Additional Nursing / Special Care:",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 4),
            AppText(
              text: sp.otherService!,
              fontSize: 13,
              height: 1.4,
              color: textSecondaryColor,
              maxLines: 5,
              overflow: TextOverflow.visible,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPetCategoriesCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "Accepted Pet Categories",
      icon: Icons.pets_outlined,
      child: sp.petCategories.isEmpty
          ? AppText(
              text: "All pets accepted.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sp.petCategories.map((cat) {
                return Chip(
                  backgroundColor: primaryColor.withValues(alpha: 0.08),
                  side: BorderSide(color: primaryColor.withValues(alpha: 0.2)),
                  label: AppText(
                    text: cat.title ?? "Pet Category",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildServiceLocationsCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "Service Delivery Locations",
      icon: Icons.place_outlined,
      child: sp.serviceLocations.isEmpty
          ? AppText(
              text: "No locations specified.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sp.serviceLocations.map((loc) {
                return Chip(
                  backgroundColor: lightSkyBlueColor,
                  side: BorderSide(color: skyBlueColor.withValues(alpha: 0.3)),
                  label: AppText(
                    text: loc,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: skyBlueColor,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildLicensesCard(ServiceProviderItemEntity sp) {
    return _buildCard(
      title: "Credentials & Registered Licenses",
      icon: Icons.verified_outlined,
      child: sp.licenses.isEmpty
          ? AppText(
              text: "No credentials registered.",
              fontSize: 13,
              color: textSecondaryColor,
            )
          : Column(
              children: sp.licenses.map((lic) {
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
                              text: "Certificate/License: ${lic.number}",
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

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "Loading service provider profile...",
              fontSize: 14,
              color: textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ServiceProviderDetailProvider provider) {
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
              text: provider.errorMessage ?? "Failed to load provider profile",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: "Retry",
              height: 38,
              radius: 8,
              onTap: () => provider.fetchServiceProviderDetail(
                widget.id,
                forceRefresh: true,
              ),
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
              Icons.store_mall_directory_outlined,
              color: textSecondaryColor,
              size: 48,
            ),
            const SizedBox(height: 14),
            AppText(
              text: "Service provider record not found",
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
