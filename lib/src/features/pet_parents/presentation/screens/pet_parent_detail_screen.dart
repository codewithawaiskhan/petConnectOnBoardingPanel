import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/mini_functions.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/shimmers/profile_detail_shimmer.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../dialogs/edit_pet_parent_dialog.dart';
import '../dialogs/update_password_dialog.dart';
import '../providers/pet_parent_detail_provider.dart';
import '../providers/pet_parents_list_provider.dart';

class PetParentDetailScreen extends StatefulWidget {
  final String id;

  const PetParentDetailScreen({super.key, required this.id});

  @override
  State<PetParentDetailScreen> createState() => _PetParentDetailScreenState();
}

class _PetParentDetailScreenState extends State<PetParentDetailScreen>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetParentDetailProvider>().fetchPetParentDetail(widget.id);
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
              context.go('/pet-parents');
            }
          },
          tooltip: "Back to Pet Parents",
        ),
        title: AppText(
          text: "Pet Parent Details",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textSecondaryColor),
            tooltip: "Refresh Details",
            onPressed: () => context
                .read<PetParentDetailProvider>()
                .fetchPetParentDetail(widget.id, forceRefresh: true),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: Consumer<PetParentDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ProfileDetailShimmer(isDesktop: isDesktop);
          }

          if (provider.errorMessage != null && provider.petParent == null) {
            return _buildErrorState(provider);
          }

          final parent = provider.petParent;
          if (parent == null) {
            return _buildNotFoundState();
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(parent, isDesktop),
                const SizedBox(height: 20),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildPersonalInfoCard(parent),
                            const SizedBox(height: 20),
                            _buildWalletCard(parent),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildRegistrationActivityCard(parent),
                            const SizedBox(height: 20),
                            _buildLocationCard(parent),
                            const SizedBox(height: 20),
                            _buildActivityCard(parent),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildPersonalInfoCard(parent),
                  const SizedBox(height: 16),
                  _buildRegistrationActivityCard(parent),
                  const SizedBox(height: 16),
                  _buildLocationCard(parent),
                  const SizedBox(height: 16),
                  _buildWalletCard(parent),
                  const SizedBox(height: 16),
                  _buildActivityCard(parent),
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(PetParentItemEntity parent, bool isDesktop) {
    final displayName = parent.fullName?.trim().isNotEmpty == true
        ? parent.fullName!.trim()
        : "Not Provided";
    final initial = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : "P";
    final displayId =
        parent.longAutoIncrementId ??
        (parent.autoIncrementId != null ? "#${parent.autoIncrementId}" : "N/A");
    final displayEmail = parent.email?.trim().isNotEmpty == true
        ? parent.email!.trim()
        : "Not Provided";
    final displayPhone = parent.phone?.trim().isNotEmpty == true
        ? parent.phone!.trim()
        : "Not Provided";
    final status = parent.user?.status ?? "Active";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 540;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: AppText(
                        text: initial,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: displayName,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: AppText(
                                  text: displayId,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              StatusBadge(
                                status: status,
                                isDeleted: parent.isDeleted,
                                fontSize: 11,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                showDot: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText(
                        text: displayEmail,
                        fontSize: 13,
                        color: textSecondaryColor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText(
                        text: displayPhone,
                        fontSize: 13,
                        color: textSecondaryColor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
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
                        text: "Update Password",
                        isIcon: true,
                        icon: Icon(
                          Icons.lock_reset_rounded,
                          size: 15,
                          color: primaryColor,
                        ),
                        width: constraints.maxWidth < 360
                            ? double.infinity
                            : 170,
                        height: 36,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        radius: 8,
                        fillColor: primaryColor.withValues(alpha: 0.08),
                        textColor: primaryColor,
                        buttonBorder: Border.all(
                          color: primaryColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                        onTap: () => _showUpdatePasswordDialog(parent),
                      ),
                      CustomButton(
                        text: "Edit Details",
                        isIcon: true,
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: primaryColor,
                        ),
                        width: constraints.maxWidth < 360
                            ? double.infinity
                            : 122,
                        height: 36,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        radius: 8,
                        fillColor: primaryColor.withValues(alpha: 0.08),
                        textColor: primaryColor,
                        buttonBorder: Border.all(
                          color: primaryColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                        onTap: () => _showEditPetParentDialog(parent),
                      ),
                      CustomButton(
                        text: "Delete",
                        isIcon: true,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 15,
                          color: errorColor,
                        ),
                        width: constraints.maxWidth < 360
                            ? double.infinity
                            : 96,
                        height: 36,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        radius: 8,
                        fillColor: errorColor.withValues(alpha: 0.08),
                        textColor: errorColor,
                        buttonBorder: Border.all(
                          color: errorColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                        onTap: () => _showDeleteConfirmationDialog(parent),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: isDesktop ? 36 : 28,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: AppText(
                      text: initial,
                      fontSize: isDesktop ? 26 : 20,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 6,
                                children: [
                                  AppText(
                                    text: displayName,
                                    fontSize: isDesktop ? 22 : 18,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimaryColor,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AppText(
                                      text: displayId,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              status: status,
                              isDeleted: parent.isDeleted,
                              fontSize: 12,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              showDot: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: AppText(
                                text: displayEmail,
                                fontSize: 13,
                                color: textSecondaryColor,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: AppText(
                                text: displayPhone,
                                fontSize: 13,
                                color: textSecondaryColor,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                      text: "Update Password",
                      isIcon: true,
                      icon: Icon(
                        Icons.lock_reset_rounded,
                        size: 15,
                        color: primaryColor,
                      ),
                      width: 170,
                      height: 36,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      radius: 8,
                      fillColor: primaryColor.withValues(alpha: 0.08),
                      textColor: primaryColor,
                      buttonBorder: Border.all(
                        color: primaryColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      onTap: () => _showUpdatePasswordDialog(parent),
                    ),
                    CustomButton(
                      text: "Edit Details",
                      isIcon: true,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: primaryColor,
                      ),
                      width: 122,
                      height: 36,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      radius: 8,
                      fillColor: primaryColor.withValues(alpha: 0.08),
                      textColor: primaryColor,
                      buttonBorder: Border.all(
                        color: primaryColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      onTap: () => _showEditPetParentDialog(parent),
                    ),
                    CustomButton(
                      text: "Delete",
                      isIcon: true,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 15,
                        color: errorColor,
                      ),
                      width: 96,
                      height: 36,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      radius: 8,
                      fillColor: errorColor.withValues(alpha: 0.08),
                      textColor: errorColor,
                      buttonBorder: Border.all(
                        color: errorColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      onTap: () => _showDeleteConfirmationDialog(parent),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoCard(PetParentItemEntity parent) {
    return _buildCardContainer(
      title: "Personal Credentials & Identity",
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          _buildInfoRow(
            "Full Legal Name",
            parent.fullName?.trim().isNotEmpty == true
                ? parent.fullName!
                : "Not Provided",
          ),
          _buildInfoRow(
            "First Name",
            parent.firstName?.trim().isNotEmpty == true
                ? parent.firstName!
                : "N/A",
          ),
          _buildInfoRow(
            "Last Name",
            parent.lastName?.trim().isNotEmpty == true
                ? parent.lastName!
                : "N/A",
          ),
          _buildInfoRow(
            "Email Address",
            parent.email?.trim().isNotEmpty == true
                ? parent.email!
                : "Not Provided",
          ),
          _buildInfoRow(
            "Contact Phone",
            parent.phone?.trim().isNotEmpty == true
                ? parent.phone!
                : "Not Provided",
          ),
          _buildInfoRow(
            "Date of Birth",
            _formatDisplayDate(parent.dateOfBirth),
          ),
          _buildInfoRow(
            "Gender",
            parent.gender?.trim().isNotEmpty == true
                ? parent.gender!
                : "Not Provided",
          ),
          _buildInfoRow(
            "Blood Group",
            parent.bloodGroup?.trim().isNotEmpty == true
                ? parent.bloodGroup!
                : "Not Provided",
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationActivityCard(PetParentItemEntity parent) {
    final user = parent.user;
    final registration = user?.recordedAtRegistrationTime;
    final lat = registration?.latitude;
    final lng = registration?.longitude;
    final hasCoordinates = lat != null && lng != null;

    final String lastLoginText =
        user?.lastLoginAt != null && user!.lastLoginAt!.trim().isNotEmpty
            ? _formatDisplayDateTime(user.lastLoginAt)
            : "Never Logged In";

    final countryName = registration?.countryName?.trim();
    final countryCode = registration?.countryCode?.trim();
    final String countryText;
    if (countryName != null &&
        countryName.isNotEmpty &&
        countryCode != null &&
        countryCode.isNotEmpty) {
      countryText = "$countryName ($countryCode)";
    } else if (countryName != null && countryName.isNotEmpty) {
      countryText = countryName;
    } else if (countryCode != null && countryCode.isNotEmpty) {
      countryText = countryCode;
    } else {
      countryText = "Not Recorded";
    }

    final String deviceOsText =
        registration?.deviceOS?.trim().isNotEmpty == true
            ? registration!.deviceOS!.trim()
            : "Not Recorded";

    return _buildCardContainer(
      title: "Registration & Session Activity",
      icon: Icons.devices_other_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Last Login Time", lastLoginText),
          _buildInfoRow("Registered Device OS", deviceOsText),
          _buildInfoRow("Registration Country", countryText),
          if (hasCoordinates)
            _buildInfoRowWithWidget(
              "Registration Location",
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  AppText(
                    text: "$lat, $lng",
                    fontSize: 13,
                    color: textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomButton(
                    text: "Show on Map",
                    isIcon: true,
                    icon: Icon(
                      Icons.map_outlined,
                      size: 13,
                      color: primaryColor,
                    ),
                    width: 124,
                    height: 28,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    radius: 6,
                    fillColor: primaryColor.withValues(alpha: 0.08),
                    textColor: primaryColor,
                    buttonBorder: Border.all(
                      color: primaryColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    onTap: () {
                      final url =
                          "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
                      MiniFunctions().launchURL(url);
                    },
                  ),
                ],
              ),
            )
          else
            _buildInfoRow("Registration Coordinates", "Not Available"),
        ],
      ),
    );
  }

  Widget _buildLocationCard(PetParentItemEntity parent) {
    return _buildCardContainer(
      title: "Residence & Postal Location",
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          _buildInfoRow(
            "Street Address",
            parent.address?.trim().isNotEmpty == true
                ? parent.address!
                : "Not Provided",
          ),
          _buildInfoRow(
            "City",
            parent.city?.trim().isNotEmpty == true
                ? parent.city!
                : "Not Provided",
          ),
          _buildInfoRow(
            "State / Province",
            parent.province?.trim().isNotEmpty == true
                ? parent.province!
                : "Not Provided",
          ),
          _buildInfoRow(
            "Postal Code",
            parent.postOfficeCode?.trim().isNotEmpty == true
                ? parent.postOfficeCode!
                : "N/A",
          ),
          _buildInfoRow(
            "Country Name",
            parent.countryName?.trim().isNotEmpty == true
                ? parent.countryName!
                : "Not Provided",
          ),
          _buildInfoRow(
            "Country Code",
            parent.countryCode?.trim().isNotEmpty == true
                ? parent.countryCode!
                : "N/A",
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(PetParentItemEntity parent) {
    final walletId = parent.wallet?.trim().isNotEmpty == true
        ? parent.wallet!
        : "N/A";

    return _buildCardContainer(
      title: "Digital Wallet & Payment Reference",
      icon: Icons.account_balance_wallet_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Wallet Account ID", walletId),
          _buildInfoRow(
            "Linked User Object ID",
            parent.user?.id?.trim().isNotEmpty == true
                ? parent.user!.id!
                : "N/A",
          ),
          _buildInfoRow(
            "User Role",
            parent.user?.roles.isNotEmpty == true
                ? parent.user!.roles.join(", ")
                : "petParent",
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(PetParentItemEntity parent) {
    return _buildCardContainer(
      title: "Bookings & Engagement Metrics",
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          _buildInfoRow(
            "Appointments Booked",
            "${parent.appointmentsBookedCount}",
          ),
          _buildInfoRow("Lab Tests Booked", "${parent.labTestsBookedCount}"),
          _buildInfoRow(
            "Record Created At",
            _formatDisplayDateTime(parent.createdAt),
          ),
          _buildInfoRow(
            "Internal ID (_id)",
            parent.id.isNotEmpty ? parent.id : "N/A",
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({
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
              Expanded(
                child: AppText(
                  text: title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  fontSize: 12,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 3),
                AppText(
                  text: value,
                  fontSize: 13,
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: constraints.maxWidth * 0.42,
                ),
                child: AppText(
                  text: label,
                  fontSize: 13,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  text: value,
                  fontSize: 13,
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRowWithWidget(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  fontSize: 12,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 6),
                child,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: constraints.maxWidth * 0.42,
                ),
                child: AppText(
                  text: label,
                  fontSize: 13,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(PetParentDetailProvider provider) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              AppText(
                text: "Failed to Load Details",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: provider.errorMessage ?? "An error occurred.",
                fontSize: 13,
                color: textSecondaryColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Try Again",
                width: 120,
                height: 40,
                radius: 8,
                onTap: () => provider.fetchPetParentDetail(
                  widget.id,
                  forceRefresh: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 16),
              AppText(
                text: "Pet Parent Not Found",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text:
                    "The requested pet parent profile could not be found or has been removed.",
                fontSize: 13,
                color: textSecondaryColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Back to Directory",
                width: 160,
                height: 40,
                radius: 8,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/pet-parents');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdatePasswordDialog(PetParentItemEntity? parent) async {
    await UpdatePasswordDialog.show(
      context,
      petParentId: widget.id,
      petParentName: parent?.fullName,
    );
  }

  Future<void> _showEditPetParentDialog(PetParentItemEntity parent) async {
    final updated = await EditPetParentDialog.show(context, parent: parent);
    if (!mounted) return;
    if (updated == true) {
      context.read<PetParentDetailProvider>().fetchPetParentDetail(
        widget.id,
        forceRefresh: true,
      );
    }
  }

  void _showDeleteConfirmationDialog(PetParentItemEntity parent) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Pet Parent",
      message:
          "Are you sure you want to delete ${parent.fullName?.trim().isNotEmpty == true ? parent.fullName : 'this pet parent'}?",
      confirmText: "Delete",
      onConfirm: () async {
        if (!mounted) return;
        final provider = context.read<PetParentsListProvider>();
        final success = await provider.deletePetParent(
          context: context,
          id: parent.id,
        );
        if (success && mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/pet-parents');
          }
        }
      },
    );
  }

  String _formatDisplayDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return "Not Provided";
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
