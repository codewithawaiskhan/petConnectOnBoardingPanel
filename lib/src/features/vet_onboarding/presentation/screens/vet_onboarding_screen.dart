import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../shared/presentation/widgets/custom_date_picker_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../providers/doctor_onboarding_provider.dart';

class VetOnboardingScreen extends StatefulWidget {
  const VetOnboardingScreen({super.key});

  @override
  State<VetOnboardingScreen> createState() => _VetOnboardingScreenState();
}

class _VetOnboardingScreenState extends State<VetOnboardingScreen>
    with AppColors {
  static const List<String> _timeZones = [
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Europe/Berlin',
    'Asia/Karachi',
    'Asia/Dubai',
    'Asia/Kolkata',
    'Asia/Singapore',
    'Asia/Tokyo',
    'Australia/Sydney',
    'UTC',
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _designationController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _designationController = TextEditingController();
    _countryCodeController = TextEditingController();
    _countryNameController = TextEditingController();
    _bioController = TextEditingController();
    _priceController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DoctorOnboardingProvider>();
      if (provider.specialities.isEmpty && !provider.isSpecialitiesLoading) {
        provider.fetchSpecialities();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _designationController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _bioController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Selector<DoctorOnboardingProvider, String?>(
      selector: (_, p) => p.profileImageDataURI,
      builder: (context, profileImageDataURI, _) {
        Widget avatarContent;

        if (profileImageDataURI != null && profileImageDataURI.isNotEmpty) {
          try {
            final cleanBase64 = profileImageDataURI.contains(',')
                ? profileImageDataURI.split(',').last
                : profileImageDataURI;
            final bytes = base64Decode(cleanBase64);
            avatarContent = ClipOval(
              child: Image.memory(
                bytes,
                width: 72,
                height: 72,
                cacheWidth: 200,
                cacheHeight: 200,
                gaplessPlayback: true,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.account_circle,
                  color: textSecondaryColor,
                  size: 48,
                ),
              ),
            );
          } catch (_) {
            avatarContent = Icon(
              Icons.account_circle,
              color: textSecondaryColor,
              size: 48,
            );
          }
        } else {
          avatarContent = Icon(
            Icons.account_circle,
            color: textSecondaryColor,
            size: 48,
          );
        }

        return InkWell(
          onTap: () =>
              context.read<DoctorOnboardingProvider>().pickProfileImage(),
          borderRadius: BorderRadius.circular(36),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Center(child: avatarContent),
          ),
        );
      },
    );
  }

  Widget _buildImagePreview({
    required String? dataUri,
    required double width,
    required double height,
    double radius = 10,
    required IconData fallbackIcon,
  }) {
    if (dataUri != null && dataUri.isNotEmpty) {
      try {
        final cleanBase64 = dataUri.contains(',')
            ? dataUri.split(',').last
            : dataUri;
        final bytes = base64Decode(cleanBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            cacheWidth: 200,
            cacheHeight: 200,
            gaplessPlayback: true,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                Icons.insert_drive_file_outlined,
                color: primaryColor,
                size: height * 0.45,
              ),
            ),
          ),
        );
      } catch (_) {}
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: Icon(fallbackIcon, color: textSecondaryColor, size: height * 0.45),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPersonalCredentialsSection(context),
            const SizedBox(height: 24),
            _buildProfessionalBioSection(context),
            const SizedBox(height: 24),
            _buildWorkingHoursSection(context),
            const SizedBox(height: 24),
            _buildDegreesSection(context),
            const SizedBox(height: 24),
            _buildClinicsSection(context),
            const SizedBox(height: 24),
            _buildLicensesSection(context),
            const SizedBox(height: 24),
            _buildWorkExperiencesSection(context),
            const SizedBox(height: 32),
            _buildSubmitSection(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppText(
                text: subtitle,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: textSecondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 14),
              const SizedBox(width: 6),
              AppText(
                text: "DOCTOR & VET ONBOARDING",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppText(
          text: "Register Veterinary Practice Profile",
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        AppText(
          text:
              "Provide your professional credentials, medical licenses, clinics, and consultation availability.",
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildPersonalCredentialsSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Account & Personal Information",
            "Enter your official veterinary contact credentials and profile avatar.",
            Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              _buildProfileAvatar(context),
              const SizedBox(width: 16),
              Selector<DoctorOnboardingProvider, String?>(
                selector: (_, p) => p.profileImageFileName,
                builder: (context, fileName, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(
                        text: fileName != null
                            ? "Change Avatar"
                            : "Upload Profile Photo",
                        width: 220,
                        height: 42,
                        fontSize: 13,
                        isOutlined: true,
                        textColor: primaryColor,
                        isIcon: true,
                        icon: Icon(
                          fileName != null
                              ? Icons.check_circle_rounded
                              : Icons.upload_file_rounded,
                          color: primaryColor,
                          size: 18,
                        ),
                        onTap: () => context
                            .read<DoctorOnboardingProvider>()
                            .pickProfileImage(),
                      ),
                      if (fileName != null) ...[
                        const SizedBox(height: 4),
                        AppText(
                          text: fileName,
                          fontSize: 12,
                          color: primaryColor,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 650;
              final provider = context.read<DoctorOnboardingProvider>();
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _nameController,
                          title: "Full Name *",
                          hintText: "Enter full name",
                          onChanged: (val) => provider.fullName = val,
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 16),
                      if (isDesktop)
                        Expanded(
                          child: CustomTextField(
                            controller: _designationController,
                            title: "Designation",
                            hintText: "Enter designation (e.g. Chief Surgeon)",
                            onChanged: (val) => provider.designation = val,
                          ),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _designationController,
                      title: "Designation",
                      hintText: "Enter designation (e.g. Chief Surgeon)",
                      onChanged: (val) => provider.designation = val,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _emailController,
                          title: "Email Address *",
                          hintText: "Enter email address",
                          textInputType: TextInputType.emailAddress,
                          onChanged: (val) => provider.email = val,
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 16),
                      if (isDesktop)
                        Expanded(
                          child: CustomTextField(
                            controller: _phoneController,
                            title: "Phone Number *",
                            hintText: "Enter phone number",
                            textInputType: TextInputType.phone,
                            onChanged: (val) => provider.phone = val,
                          ),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _phoneController,
                      title: "Phone Number *",
                      hintText: "Enter phone number",
                      textInputType: TextInputType.phone,
                      onChanged: (val) => provider.phone = val,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _countryNameController,
                          title: "Country Name *",
                          hintText: "Enter country name",
                          onChanged: (val) => provider.countryName = val,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 150,
                        child: CustomTextField(
                          controller: _countryCodeController,
                          title: "Country Code *",
                          hintText: "Enter country code",
                          onChanged: (val) => provider.countryCode = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _passwordController,
                          title: "Password *",
                          hintText: "Enter password",
                          isObSecure: true,
                          onChanged: (val) => provider.password = val,
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 16),
                      if (isDesktop)
                        Expanded(
                          child: CustomTextField(
                            controller: _confirmPasswordController,
                            title: "Confirm Password *",
                            hintText: "Confirm password",
                            isObSecure: true,
                            onChanged: (val) => provider.confirmPassword = val,
                          ),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      title: "Confirm Password *",
                      hintText: "Confirm password",
                      isObSecure: true,
                      onChanged: (val) => provider.confirmPassword = val,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalBioSection(BuildContext context) {
    final provider = context.read<DoctorOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Practice Bio & Consultation Pricing",
            "Describe your veterinary background, consultation fee, and timezone.",
            Icons.medical_services_outlined,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _bioController,
            title: "Professional Bio *",
            hintText: "Enter professional bio and background...",
            maxLines: 4,
            onChanged: (val) => provider.bio = val,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _priceController,
                  title: "Fee Per Appointment (USD)",
                  hintText: "Enter consultation fee",
                  textInputType: TextInputType.number,
                  onChanged: (val) {
                    final p = num.tryParse(val);
                    if (p != null) provider.price = p;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeZoneDropdown(context)),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          _buildSpecialityAndServicesSection(),
        ],
      ),
    );
  }

  Widget _buildSpecialityAndServicesSection() {
    return Consumer<DoctorOnboardingProvider>(
      builder: (context, provider, _) {
        final currentSpecialityId = provider.selectedSpecialityId;
        final hasValidSpeciality =
            currentSpecialityId != null &&
            provider.specialities.any((s) => s.id == currentSpecialityId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText(
                  text: "Primary Speciality *",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
                if (provider.isSpecialitiesLoading) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: primaryColor,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: hasValidSpeciality ? currentSpecialityId : null,
                  hint: AppText(
                    text: provider.isSpecialitiesLoading
                        ? "Loading specialities..."
                        : "Select medical speciality",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textSecondaryColor,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      provider.selectSpeciality(val);
                    }
                  },
                  items: provider.specialities.map((spec) {
                    return DropdownMenuItem<String>(
                      value: spec.id,
                      child: AppText(
                        text: spec.title,
                        fontSize: 13,
                        color: textPrimaryColor,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (provider.selectedSpecialityId != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  AppText(
                    text: "Services Offered *",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  if (provider.isServicesLoading) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              AppText(
                text:
                    "Select the clinical procedures and consultation services you offer.",
                fontSize: 12,
                color: textSecondaryColor,
              ),
              const SizedBox(height: 12),
              if (provider.isServicesLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppText(
                        text: "Loading services for selected speciality...",
                        fontSize: 13,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                )
              else if (provider.services.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AppText(
                    text: "No services available for this speciality yet.",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: provider.services.map((service) {
                    final isSelected = provider.selectedServices.contains(
                      service.id,
                    );
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => provider.toggleServiceSelection(service.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withValues(alpha: 0.1)
                              : whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? primaryColor : borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              size: 16,
                              color: isSelected
                                  ? primaryColor
                                  : textSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              text: service.title,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? primaryColor
                                  : textPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTimeZoneDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Time Zone",
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        Selector<DoctorOnboardingProvider, String>(
          selector: (_, p) => p.timeZone,
          builder: (context, timeZone, _) {
            final validZone = _timeZones.contains(timeZone)
                ? timeZone
                : _timeZones.first;
            return Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: validZone,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textSecondaryColor,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<DoctorOnboardingProvider>().setTimeZone(val);
                    }
                  },
                  items: _timeZones.map((tz) {
                    return DropdownMenuItem<String>(
                      value: tz,
                      child: AppText(
                        text: tz,
                        fontSize: 13,
                        color: textPrimaryColor,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkingHoursSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Weekly Schedule (Available Days)",
            "Specify open and close hours for all 7 days of the week (Sunday through Saturday).",
            Icons.access_time_rounded,
          ),
          const SizedBox(height: 16),
          Consumer<DoctorOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.availableDays.length,
                separatorBuilder: (context, index) => const Divider(height: 18),
                itemBuilder: (context, index) {
                  final day = provider.availableDays[index];
                  return Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: AppText(
                          text: day.dayName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: day.isAvailable
                              ? textPrimaryColor
                              : textSecondaryColor,
                        ),
                      ),
                      Checkbox(
                        value: day.isAvailable,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            provider.toggleDayAvailability(index, val ?? false),
                      ),
                      AppText(
                        text: day.isAvailable ? "Open" : "Closed",
                        fontSize: 12,
                        color: day.isAvailable
                            ? primaryColor
                            : textSecondaryColor,
                      ),
                      const Spacer(),
                      if (day.isAvailable) ...[
                        InkWell(
                          onTap: () =>
                              provider.selectDayTime(context, index, true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                AppText(
                                  text: day.openTime,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AppText(
                            text: "to",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              provider.selectDayTime(context, index, false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                AppText(
                                  text: day.closeTime,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDegreesSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  "Academic Degrees & Certifications",
                  "Add your medical diplomas, universities, and graduation certificates.",
                  Icons.school_outlined,
                ),
              ),
              CustomButton(
                text: "Add Degree",
                width: 150,
                height: 38,
                fontSize: 12,
                isOutlined: true,
                textColor: primaryColor,
                isIcon: true,
                icon: Icon(Icons.add_rounded, color: primaryColor, size: 18),
                onTap: () =>
                    context.read<DoctorOnboardingProvider>().addDegree(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<DoctorOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.degrees.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = provider.degrees[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Degree #${index + 1}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            if (provider.degrees.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => provider.removeDegree(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildImagePreview(
                              dataUri: item.degreeImageDataURI,
                              width: 64,
                              height: 64,
                              radius: 10,
                              fallbackIcon: Icons.school_outlined,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomButton(
                                  text: item.fileName != null
                                      ? "Change Certificate"
                                      : "Upload Degree Proof",
                                  width: 220,
                                  height: 38,
                                  fontSize: 12,
                                  isOutlined: true,
                                  textColor: item.fileName != null
                                      ? successColor
                                      : primaryColor,
                                  isIcon: true,
                                  icon: Icon(
                                    item.fileName != null
                                        ? Icons.check_circle_rounded
                                        : Icons.upload_file_rounded,
                                    color: item.fileName != null
                                        ? successColor
                                        : primaryColor,
                                    size: 16,
                                  ),
                                  onTap: () => provider.pickDegreeImage(index),
                                ),
                                if (item.fileName != null) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: item.fileName!,
                                    fontSize: 12,
                                    color: successColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.degreeTitle,
                                title: "Degree Title *",
                                hintText: "Enter degree title",
                                onChanged: (val) => item.degreeTitle = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.institutionTitle,
                                title: "Institution / University *",
                                hintText: "Enter university / institution",
                                onChanged: (val) => item.institutionTitle = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable: item.isCurrentlyStudyingNotifier,
                          builder: (context, isCurrentlyStudying, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isCurrentlyStudying,
                                      activeColor: primaryColor,
                                      onChanged: (val) => provider
                                          .toggleDegreeCurrentlyStudying(
                                            index,
                                            val ?? false,
                                          ),
                                    ),
                                    AppText(
                                      text: "Currently studying here",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        initialValue: item.duration,
                                        title: "Duration (Years) *",
                                        hintText: "Enter duration in years",
                                        onChanged: (val) => item.duration = val,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: CustomDatePickerField(
                                        initialValue: item.startDate,
                                        title: "Start Date *",
                                        hintText: "YYYY-MM-DD",
                                        onChanged: (val) =>
                                            item.startDate = val,
                                      ),
                                    ),
                                    if (!isCurrentlyStudying) ...[
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: CustomDatePickerField(
                                          initialValue: item.endDate ?? '',
                                          title: "End Date *",
                                          hintText: "YYYY-MM-DD",
                                          onChanged: (val) =>
                                              item.endDate = val,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClinicsSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  "Veterinary Clinics & Hospital Facilities",
                  "Register your clinic facilities, location coordinates, and contacts.",
                  Icons.local_hospital_outlined,
                ),
              ),
              CustomButton(
                text: "Add Clinic",
                width: 150,
                height: 38,
                fontSize: 12,
                isOutlined: true,
                textColor: primaryColor,
                isIcon: true,
                icon: Icon(Icons.add_rounded, color: primaryColor, size: 18),
                onTap: () =>
                    context.read<DoctorOnboardingProvider>().addClinic(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<DoctorOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.clinics.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = provider.clinics[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Clinic #${index + 1}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            if (provider.clinics.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => provider.removeClinic(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildImagePreview(
                              dataUri: item.clinicImageDataURI,
                              width: 64,
                              height: 64,
                              radius: 10,
                              fallbackIcon: Icons.local_hospital_outlined,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomButton(
                                  text: item.fileName != null
                                      ? "Change Photo"
                                      : "Upload Clinic Photo",
                                  width: 220,
                                  height: 38,
                                  fontSize: 12,
                                  isOutlined: true,
                                  textColor: item.fileName != null
                                      ? successColor
                                      : primaryColor,
                                  isIcon: true,
                                  icon: Icon(
                                    item.fileName != null
                                        ? Icons.check_circle_rounded
                                        : Icons.add_photo_alternate_rounded,
                                    color: item.fileName != null
                                        ? successColor
                                        : primaryColor,
                                    size: 16,
                                  ),
                                  onTap: () => provider.pickClinicImage(index),
                                ),
                                if (item.fileName != null) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: item.fileName!,
                                    fontSize: 12,
                                    color: successColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.title,
                                title: "Clinic / Hospital Name *",
                                hintText: "Enter clinic name",
                                onChanged: (val) => item.title = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.clinicPhone,
                                title: "Clinic Phone *",
                                hintText: "Enter clinic phone",
                                onChanged: (val) => item.clinicPhone = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.address,
                                title: "Address *",
                                hintText: "Enter clinic address",
                                onChanged: (val) => item.address = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.city,
                                title: "City *",
                                hintText: "Enter city",
                                onChanged: (val) => item.city = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.province,
                                title: "State / Province *",
                                hintText: "Enter state / province",
                                onChanged: (val) => item.province = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.latitude,
                                title: "Latitude",
                                hintText: "Enter latitude (optional)",
                                onChanged: (val) => item.latitude = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.longitude,
                                title: "Longitude",
                                hintText: "Enter longitude (optional)",
                                onChanged: (val) => item.longitude = val,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLicensesSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  "State Veterinary Medical Licenses",
                  "Add veterinary license numbers, issuing states, and expiration dates.",
                  Icons.verified_user_outlined,
                ),
              ),
              CustomButton(
                text: "Add License",
                width: 150,
                height: 38,
                fontSize: 12,
                isOutlined: true,
                textColor: primaryColor,
                isIcon: true,
                icon: Icon(Icons.add_rounded, color: primaryColor, size: 18),
                onTap: () =>
                    context.read<DoctorOnboardingProvider>().addLicense(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<DoctorOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.licenses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = provider.licenses[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "License #${index + 1}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            if (provider.licenses.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => provider.removeLicense(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildImagePreview(
                              dataUri: item.licenseImageDataURI,
                              width: 64,
                              height: 64,
                              radius: 10,
                              fallbackIcon: Icons.verified_user_outlined,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomButton(
                                  text: item.fileName != null
                                      ? "Change Certificate"
                                      : "Upload License Certificate",
                                  width: 240,
                                  height: 38,
                                  fontSize: 12,
                                  isOutlined: true,
                                  textColor: item.fileName != null
                                      ? successColor
                                      : primaryColor,
                                  isIcon: true,
                                  icon: Icon(
                                    item.fileName != null
                                        ? Icons.check_circle_rounded
                                        : Icons.verified_user_rounded,
                                    color: item.fileName != null
                                        ? successColor
                                        : primaryColor,
                                    size: 16,
                                  ),
                                  onTap: () => provider.pickLicenseImage(index),
                                ),
                                if (item.fileName != null) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: item.fileName!,
                                    fontSize: 12,
                                    color: successColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.licenseNumber,
                                title: "License Number *",
                                hintText: "Enter license number",
                                onChanged: (val) => item.licenseNumber = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.state,
                                title: "State *",
                                hintText: "Enter issuing state",
                                onChanged: (val) => item.state = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            SizedBox(
                              width: 140,
                              child: CustomTextField(
                                initialValue: item.stateAbbreviation,
                                title: "Abbreviation *",
                                hintText: "Enter abbreviation",
                                onChanged: (val) =>
                                    item.stateAbbreviation = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomDatePickerField(
                          initialValue: item.licenseExpiryDate,
                          title: "Expiry Date (ISO 8601) *",
                          hintText: "YYYY-MM-DD",
                          onChanged: (val) => item.licenseExpiryDate = val,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperiencesSection(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  "Work & Clinical Experience",
                  "List past or current positions, clinics, and years of experience.",
                  Icons.business_center_outlined,
                ),
              ),
              CustomButton(
                text: "Add Experience",
                width: 170,
                height: 38,
                fontSize: 12,
                isOutlined: true,
                textColor: primaryColor,
                isIcon: true,
                icon: Icon(Icons.add_rounded, color: primaryColor, size: 18),
                onTap: () => context
                    .read<DoctorOnboardingProvider>()
                    .addWorkExperience(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<DoctorOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.workExperiences.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = provider.workExperiences[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Experience #${index + 1}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            if (provider.workExperiences.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    provider.removeWorkExperience(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildImagePreview(
                              dataUri: item.jobImageDataURI,
                              width: 64,
                              height: 64,
                              radius: 10,
                              fallbackIcon: Icons.badge_outlined,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomButton(
                                  text: item.fileName != null
                                      ? "Change Document"
                                      : "Upload Employment Proof",
                                  width: 235,
                                  height: 38,
                                  fontSize: 12,
                                  isOutlined: true,
                                  textColor: item.fileName != null
                                      ? successColor
                                      : primaryColor,
                                  isIcon: true,
                                  icon: Icon(
                                    item.fileName != null
                                        ? Icons.check_circle_rounded
                                        : Icons.badge_rounded,
                                    color: item.fileName != null
                                        ? successColor
                                        : primaryColor,
                                    size: 16,
                                  ),
                                  onTap: () => provider.pickJobImage(index),
                                ),
                                if (item.fileName != null) ...[
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: item.fileName!,
                                    fontSize: 12,
                                    color: successColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.jobTitle,
                                title: "Job Title *",
                                hintText: "Enter job title",
                                onChanged: (val) => item.jobTitle = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.jobOrganizationTitle,
                                title: "Organization Name *",
                                hintText: "Enter organization name",
                                onChanged: (val) =>
                                    item.jobOrganizationTitle = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.jobYearsOfExperience,
                                title: "Years of Experience *",
                                hintText: "Enter years of experience",
                                onChanged: (val) =>
                                    item.jobYearsOfExperience = val,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                initialValue: item.jobOrganizationAddress,
                                title: "Organization Address *",
                                hintText: "Enter organization address",
                                onChanged: (val) =>
                                    item.jobOrganizationAddress = val,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable: item.isCurrentlyWorkingNotifier,
                          builder: (context, isCurrentlyWorking, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isCurrentlyWorking,
                                      activeColor: primaryColor,
                                      onChanged: (val) =>
                                          provider.toggleJobCurrentlyWorking(
                                            index,
                                            val ?? false,
                                          ),
                                    ),
                                    AppText(
                                      text: "Currently working here",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomDatePickerField(
                                        initialValue: item.jobStartDate,
                                        title: "Start Date *",
                                        hintText: "YYYY-MM-DD",
                                        onChanged: (val) =>
                                            item.jobStartDate = val,
                                      ),
                                    ),
                                    if (!isCurrentlyWorking) ...[
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: CustomDatePickerField(
                                          initialValue: item.jobEndDate ?? '',
                                          title: "End Date *",
                                          hintText: "YYYY-MM-DD",
                                          onChanged: (val) =>
                                              item.jobEndDate = val,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSection(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Selector<DoctorOnboardingProvider, bool>(
        selector: (_, p) => p.isLoading,
        builder: (context, isLoading, _) {
          return CustomButton(
            text: "Submit Onboarding Application",
            width: 290,
            height: 48,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            textColor: whiteColor,
            fillColor: primaryColor,
            isLoading: isLoading,
            isIcon: true,
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            onTap: () =>
                context.read<DoctorOnboardingProvider>().submitData(context),
          );
        },
      ),
    );
  }
}
