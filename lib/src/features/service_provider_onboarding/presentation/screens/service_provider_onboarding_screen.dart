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
import '../providers/service_provider_onboarding_provider.dart';

class ServiceProviderOnboardingScreen extends StatefulWidget {
  const ServiceProviderOnboardingScreen({super.key});

  @override
  State<ServiceProviderOnboardingScreen> createState() =>
      _ServiceProviderOnboardingScreenState();
}

class _ServiceProviderOnboardingScreenState
    extends State<ServiceProviderOnboardingScreen>
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

  static const List<String> _genderOptions = ['Male', 'Female', 'Other'];

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _designationController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;
  late final TextEditingController _bioController;

  late final TextEditingController _businessNameController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessPhoneController;
  late final TextEditingController _businessZipController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  late final TextEditingController _startingPriceController;
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

    _businessNameController = TextEditingController();
    _businessEmailController = TextEditingController();
    _businessPhoneController = TextEditingController();
    _businessZipController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    _startingPriceController = TextEditingController();
    _priceController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ServiceProviderOnboardingProvider>();
      if (provider.petCategories.isEmpty && !provider.isPetCategoriesLoading) {
        provider.fetchPetCategories();
      }
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

    _businessNameController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _businessZipController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    _startingPriceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Selector<ServiceProviderOnboardingProvider, String?>(
      selector: (_, p) => p.profileImageDataURI,
      builder: (context, dataUri, _) {
        Widget avatarContent;
        if (dataUri != null && dataUri.isNotEmpty) {
          try {
            final cleanBase64 = dataUri.contains(',')
                ? dataUri.split(',').last
                : dataUri;
            final bytes = base64Decode(cleanBase64);
            avatarContent = ClipOval(
              child: Image.memory(
                bytes,
                width: 80,
                height: 80,
                cacheWidth: 200,
                cacheHeight: 200,
                gaplessPlayback: true,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.account_circle,
                  color: textSecondaryColor,
                  size: 54,
                ),
              ),
            );
          } catch (_) {
            avatarContent = Icon(
              Icons.account_circle,
              color: textSecondaryColor,
              size: 54,
            );
          }
        } else {
          avatarContent = Icon(
            Icons.account_circle,
            color: textSecondaryColor,
            size: 54,
          );
        }

        return InkWell(
          onTap: () => context
              .read<ServiceProviderOnboardingProvider>()
              .pickProfileImage(),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
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
            _buildBusinessDetailsSection(context),
            const SizedBox(height: 24),
            _buildServicesAndPricingSection(context),
            const SizedBox(height: 24),
            _buildWorkingHoursSection(context),
            const SizedBox(height: 24),
            _buildDegreesSection(context),
            const SizedBox(height: 24),
            _buildLicensesSection(context),
            const SizedBox(height: 24),
            _buildWorkExperiencesSection(context),
            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerRight,
              child: Selector<ServiceProviderOnboardingProvider, bool>(
                selector: (_, p) => p.isLoading,
                builder: (context, isLoading, _) {
                  return CustomButton(
                    text: "Submit Onboarding Application",
                    isIcon: true,
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: whiteColor,
                    ),
                    isLoading: isLoading,
                    height: 48,
                    width: 290,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    onTap: () async {
                      await context
                          .read<ServiceProviderOnboardingProvider>()
                          .submitData(context);
                    },
                  );
                },
              ),
            ),
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
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 14),
              const SizedBox(width: 6),
              AppText(
                text: "Service Provider Administration",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppText(
          text: "Service Provider Onboarding",
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        AppText(
          text:
              "Complete profile verification, business registration, service offerings, and working schedules in one master entry.",
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildPersonalCredentialsSection(BuildContext context) {
    final provider = context.read<ServiceProviderOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Personal Information & Credentials",
            "Primary identification, administrative account details, and languages.",
            Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                _buildProfileAvatar(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Profile Photo",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 4),
                      Selector<ServiceProviderOnboardingProvider, String?>(
                        selector: (_, p) => p.profileImageFileName,
                        builder: (context, fileName, _) {
                          return AppText(
                            text:
                                fileName ??
                                "JPEG, PNG or WebP up to 5MB. Click button to upload.",
                            fontSize: 12,
                            color: textSecondaryColor,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "Upload Photo",
                  isIcon: true,
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: primaryColor,
                  ),
                  isOutlined: true,
                  height: 40,
                  width: 150,
                  fontSize: 13,
                  onTap: () => context
                      .read<ServiceProviderOnboardingProvider>()
                      .pickProfileImage(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildResponsiveRow([
            _buildField(
              label: "Full Name *",
              child: CustomTextField(
                controller: _nameController,
                hintText: "Enter full legal name",
                onChanged: (val) => provider.fullName = val,
              ),
            ),
            _buildField(
              label: "Email Address *",
              child: CustomTextField(
                controller: _emailController,
                hintText: "Enter official email address",
                textInputType: TextInputType.emailAddress,
                onChanged: (val) => provider.email = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Phone Number *",
              child: CustomTextField(
                controller: _phoneController,
                hintText: "Enter phone number",
                textInputType: TextInputType.phone,
                onChanged: (val) => provider.phone = val,
              ),
            ),
            _buildField(
              label: "Designation / Title",
              child: CustomTextField(
                controller: _designationController,
                hintText: "Enter professional designation",
                onChanged: (val) => provider.designation = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Country Code",
              child: CustomTextField(
                controller: _countryCodeController,
                hintText: "Enter country code",
                onChanged: (val) => provider.countryCode = val,
              ),
            ),
            _buildField(
              label: "Country Name",
              child: CustomTextField(
                controller: _countryNameController,
                hintText: "Enter country name",
                onChanged: (val) => provider.countryName = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Password *",
              child: CustomTextField(
                controller: _passwordController,
                hintText: "Enter password",
                isObSecure: true,
                onChanged: (val) => provider.password = val,
              ),
            ),
            _buildField(
              label: "Confirm Password *",
              child: CustomTextField(
                controller: _confirmPasswordController,
                hintText: "Confirm password",
                isObSecure: true,
                onChanged: (val) => provider.confirmPassword = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Gender",
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Selector<ServiceProviderOnboardingProvider, String>(
                  selector: (_, p) => p.gender,
                  builder: (context, gender, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: gender,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondaryColor,
                        ),
                        items: _genderOptions.map((g) {
                          return DropdownMenuItem<String>(
                            value: g,
                            child: AppText(text: g, fontSize: 14),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            context
                                .read<ServiceProviderOnboardingProvider>()
                                .setGender(val);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildField(
              label: "Time Zone",
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Selector<ServiceProviderOnboardingProvider, String>(
                  selector: (_, p) => p.timeZone,
                  builder: (context, currentTimeZone, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _timeZones.contains(currentTimeZone)
                            ? currentTimeZone
                            : _timeZones.first,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondaryColor,
                        ),
                        items: _timeZones.map((tz) {
                          return DropdownMenuItem<String>(
                            value: tz,
                            child: AppText(text: tz, fontSize: 13),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            context
                                .read<ServiceProviderOnboardingProvider>()
                                .setTimeZone(val);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildField(
            label: "Known Languages",
            child: Consumer<ServiceProviderOnboardingProvider>(
              builder: (context, p, _) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.allLanguages.map((lang) {
                    final isSelected = p.knownLanguages.contains(lang);
                    return FilterChip(
                      label: AppText(
                        text: lang,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? primaryColor : textPrimaryColor,
                      ),
                      selected: isSelected,
                      selectedColor: primaryColor.withValues(alpha: 0.12),
                      backgroundColor: backgroundColor,
                      checkmarkColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? primaryColor : borderColor,
                        ),
                      ),
                      onSelected: (_) => p.toggleLanguage(lang),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildField(
            label: "Professional Bio / Summary *",
            child: CustomTextField(
              controller: _bioController,
              hintText: "Enter professional bio and summary...",
              maxLines: 4,
              onChanged: (val) => provider.bio = val,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsSection(BuildContext context) {
    final provider = context.read<ServiceProviderOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Business & Location Details",
            "Organization name, contact details, service coordinates, and facility photo.",
            Icons.store_mall_directory_outlined,
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Selector<ServiceProviderOnboardingProvider, String?>(
                  selector: (_, p) => p.businessImageDataURI,
                  builder: (context, dataUri, _) {
                    return _buildImagePreview(
                      dataUri: dataUri,
                      width: 80,
                      height: 60,
                      radius: 8,
                      fallbackIcon: Icons.storefront_outlined,
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Business Facility / Storefront Photo",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 4),
                      Selector<ServiceProviderOnboardingProvider, String?>(
                        selector: (_, p) => p.businessImageFileName,
                        builder: (context, fileName, _) {
                          return AppText(
                            text:
                                fileName ??
                                "JPEG or PNG up to 5MB. Click button to upload.",
                            fontSize: 12,
                            color: textSecondaryColor,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "Upload Photo",
                  isIcon: true,
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: primaryColor,
                  ),
                  isOutlined: true,
                  height: 40,
                  width: 150,
                  fontSize: 13,
                  onTap: () => context
                      .read<ServiceProviderOnboardingProvider>()
                      .pickBusinessImage(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildResponsiveRow([
            _buildField(
              label: "Business / Organization Name *",
              child: CustomTextField(
                controller: _businessNameController,
                hintText: "Enter registered business name",
                onChanged: (val) => provider.businessName = val,
              ),
            ),
            _buildField(
              label: "Business Email *",
              child: CustomTextField(
                controller: _businessEmailController,
                hintText: "Enter business email address",
                textInputType: TextInputType.emailAddress,
                onChanged: (val) => provider.businessEmail = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Business Phone *",
              child: CustomTextField(
                controller: _businessPhoneController,
                hintText: "Enter business phone number",
                textInputType: TextInputType.phone,
                onChanged: (val) => provider.businessPhone = val,
              ),
            ),
            _buildField(
              label: "Business ZIP Code *",
              child: CustomTextField(
                controller: _businessZipController,
                hintText: "Enter postal ZIP code",
                onChanged: (val) => provider.businessZIPCode = val,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildField(
              label: "Latitude",
              child: CustomTextField(
                controller: _latitudeController,
                hintText: "Enter latitude coordinate",
                onChanged: (val) => provider.latitude = val,
              ),
            ),
            _buildField(
              label: "Longitude",
              child: CustomTextField(
                controller: _longitudeController,
                hintText: "Enter longitude coordinate",
                onChanged: (val) => provider.longitude = val,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildServicesAndPricingSection(BuildContext context) {
    final provider = context.read<ServiceProviderOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Services, Taxonomies & Pricing",
            "Pet species treated, speciality filtering, service catalog, delivery locations, and appointment rates.",
            Icons.price_check_outlined,
          ),
          const SizedBox(height: 20),

          _buildField(
            label: "Pet Categories Handled *",
            child: Consumer<ServiceProviderOnboardingProvider>(
              builder: (context, p, _) {
                if (p.isPetCategoriesLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                if (p.petCategories.isEmpty) {
                  return AppText(
                    text: "No pet categories found.",
                    color: textSecondaryColor,
                    fontSize: 13,
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.petCategories.map((cat) {
                    final isSelected = p.selectedPetCategories.contains(cat.id);
                    return FilterChip(
                      label: AppText(
                        text: cat.title,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? primaryColor : textPrimaryColor,
                      ),
                      selected: isSelected,
                      selectedColor: primaryColor.withValues(alpha: 0.12),
                      backgroundColor: backgroundColor,
                      checkmarkColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? primaryColor : borderColor,
                        ),
                      ),
                      onSelected: (_) => p.togglePetCategory(cat.id),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          Consumer<ServiceProviderOnboardingProvider>(
            builder: (context, p, _) {
              final currentSpecialityId = p.selectedSpecialityId;
              final hasValidSpeciality =
                  currentSpecialityId != null &&
                  p.specialities.any((s) => s.id == currentSpecialityId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        text: "Select Service Speciality Filter *",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      if (p.isSpecialitiesLoading) ...[
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
                          text: p.isSpecialitiesLoading
                              ? "Loading specialities..."
                              : "Select speciality to filter services",
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
                            p.selectSpeciality(val);
                          }
                        },
                        items: p.specialities.map((spec) {
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

                  if (p.selectedSpecialityId != null) ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        AppText(
                          text: "Services Offered *",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        if (p.isServicesLoading) ...[
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
                          "Select the specialized care and grooming services you offer.",
                      fontSize: 12,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 12),
                    if (p.isServicesLoading)
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
                              text:
                                  "Loading services for selected speciality...",
                              fontSize: 13,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      )
                    else if (p.services.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: AppText(
                          text: "No services found for this speciality.",
                          fontSize: 13,
                          color: textSecondaryColor,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: p.services.map((service) {
                          final isSelected = p.selectedServices.contains(
                            service.id,
                          );
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => p.toggleServiceSelection(service.id),
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
                                  color: isSelected
                                      ? primaryColor
                                      : borderColor,
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
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          _buildField(
            label: "Service Delivery Locations *",
            child: Consumer<ServiceProviderOnboardingProvider>(
              builder: (context, p, _) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: p.availableLocations.map((loc) {
                    final isSelected = p.selectedServiceLocations.contains(loc);
                    return FilterChip(
                      label: AppText(
                        text: loc,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? primaryColor : textPrimaryColor,
                      ),
                      selected: isSelected,
                      selectedColor: primaryColor.withValues(alpha: 0.12),
                      backgroundColor: backgroundColor,
                      checkmarkColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? primaryColor : borderColor,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      onSelected: (_) => p.toggleServiceLocation(loc),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          _buildResponsiveRow([
            _buildField(
              label: "Starting Price Per Appointment (USD)",
              child: CustomTextField(
                controller: _startingPriceController,
                hintText: "Enter starting price",
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (val) {
                  provider.startingPricePerAppointment = num.tryParse(val) ?? 0;
                },
              ),
            ),
            _buildField(
              label: "Standard Fee Per Appointment (USD) *",
              child: CustomTextField(
                controller: _priceController,
                hintText: "Enter standard appointment price",
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (val) {
                  provider.pricePerAppointment = num.tryParse(val) ?? 0;
                },
              ),
            ),
          ]),
        ],
      ),
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
          Consumer<ServiceProviderOnboardingProvider>(
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
                  "Educational Degrees & Certifications",
                  "Academic credentials, diplomas, and vocational pet care certifications.",
                  Icons.school_outlined,
                ),
              ),
              CustomButton(
                text: "Add Degree",
                isIcon: true,
                icon: Icon(Icons.add_rounded, size: 16, color: primaryColor),
                isOutlined: true,
                height: 38,
                width: 140,
                fontSize: 13,
                onTap: () => context
                    .read<ServiceProviderOnboardingProvider>()
                    .addDegree(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<ServiceProviderOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.degrees.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final degree = provider.degrees[index];
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
                            _buildImagePreview(
                              dataUri: degree.degreeImageDataURI,
                              width: 50,
                              height: 50,
                              fallbackIcon: Icons.description_outlined,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text:
                                        degree.fileName ??
                                        "Upload Degree / Certificate Photo",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                  const SizedBox(height: 2),
                                  AppText(
                                    text: "JPG, PNG or PDF document",
                                    fontSize: 11,
                                    color: textSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Upload",
                              isIcon: true,
                              icon: Icon(
                                Icons.upload_file_outlined,
                                size: 15,
                                color: primaryColor,
                              ),
                              isOutlined: true,
                              height: 36,
                              width: 110,
                              fontSize: 12,
                              onTap: () => provider.pickDegreeImage(index),
                            ),
                            if (provider.degrees.length > 1) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red[400],
                                  size: 20,
                                ),
                                onPressed: () => provider.removeDegree(index),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildResponsiveRow([
                          _buildField(
                            label: "Degree / Certificate Title",
                            child: CustomTextField(
                              hintText: "Enter certificate or degree title",
                              onChanged: (val) => degree.degreeTitle = val,
                            ),
                          ),
                          _buildField(
                            label: "Institution / Academy",
                            child: CustomTextField(
                              hintText: "Enter issuing institution name",
                              onChanged: (val) => degree.institutionTitle = val,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildResponsiveRow([
                          _buildField(
                            label: "Duration",
                            child: CustomTextField(
                              hintText: "Enter program duration",
                              onChanged: (val) => degree.duration = val,
                            ),
                          ),
                          _buildField(
                            label: "Start Date",
                            child: CustomDatePickerField(
                              initialValue: degree.startDate,
                              hintText: "YYYY-MM-DD",
                              onChanged: (val) => degree.startDate = val,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable: degree.isCurrentlyStudyingNotifier,
                          builder: (context, isStudying, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isStudying,
                                      activeColor: primaryColor,
                                      onChanged: (val) {
                                        provider.toggleDegreeCurrentlyStudying(
                                          index,
                                          val ?? false,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    AppText(
                                      text: "Currently studying here",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                if (!isStudying) ...[
                                  const SizedBox(height: 8),
                                  _buildField(
                                    label: "End Date",
                                    child: CustomDatePickerField(
                                      initialValue: degree.endDate,
                                      hintText: "YYYY-MM-DD",
                                      onChanged: (val) => degree.endDate = val,
                                    ),
                                  ),
                                ],
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
                  "Professional Licenses & Permits",
                  "Government or municipal animal care licenses and state board registrations.",
                  Icons.card_membership_outlined,
                ),
              ),
              CustomButton(
                text: "Add License",
                isIcon: true,
                icon: Icon(Icons.add_rounded, size: 16, color: primaryColor),
                isOutlined: true,
                height: 38,
                width: 140,
                fontSize: 13,
                onTap: () => context
                    .read<ServiceProviderOnboardingProvider>()
                    .addLicense(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<ServiceProviderOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.licenses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final license = provider.licenses[index];
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
                            _buildImagePreview(
                              dataUri: license.licenseImageDataURI,
                              width: 50,
                              height: 50,
                              fallbackIcon: Icons.verified_user_outlined,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text:
                                        license.fileName ??
                                        "Upload License Document Photo",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                  const SizedBox(height: 2),
                                  AppText(
                                    text:
                                        "Official certification / permit proof",
                                    fontSize: 11,
                                    color: textSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Upload",
                              isIcon: true,
                              icon: Icon(
                                Icons.upload_file_outlined,
                                size: 15,
                                color: primaryColor,
                              ),
                              isOutlined: true,
                              height: 36,
                              width: 110,
                              fontSize: 12,
                              onTap: () => provider.pickLicenseImage(index),
                            ),
                            if (provider.licenses.length > 1) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red[400],
                                  size: 20,
                                ),
                                onPressed: () => provider.removeLicense(index),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildResponsiveRow([
                          _buildField(
                            label: "State / Region",
                            child: CustomTextField(
                              hintText: "Enter state or province",
                              onChanged: (val) => license.state = val,
                            ),
                          ),
                          _buildField(
                            label: "State Abbreviation",
                            child: CustomTextField(
                              hintText: "Enter state abbreviation",
                              onChanged: (val) =>
                                  license.stateAbbreviation = val,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildResponsiveRow([
                          _buildField(
                            label: "License / Registration Number",
                            child: CustomTextField(
                              hintText: "Enter license number",
                              onChanged: (val) => license.licenseNumber = val,
                            ),
                          ),
                          _buildField(
                            label: "Expiry Date",
                            child: CustomDatePickerField(
                              initialValue: license.licenseExpiryDate,
                              hintText: "YYYY-MM-DD",
                              onChanged: (val) =>
                                  license.licenseExpiryDate = val,
                            ),
                          ),
                        ]),
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
                  "Work & Employment Experience",
                  "Previous veterinary clinics, pet spas, animal shelters, or grooming centers.",
                  Icons.work_history_outlined,
                ),
              ),
              CustomButton(
                text: "Add Experience",
                isIcon: true,
                icon: Icon(Icons.add_rounded, size: 16, color: primaryColor),
                isOutlined: true,
                height: 38,
                width: 155,
                fontSize: 13,
                onTap: () => context
                    .read<ServiceProviderOnboardingProvider>()
                    .addWorkExperience(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<ServiceProviderOnboardingProvider>(
            builder: (context, provider, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.workExperiences.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final job = provider.workExperiences[index];
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
                            _buildImagePreview(
                              dataUri: job.jobImageDataURI,
                              width: 50,
                              height: 50,
                              fallbackIcon: Icons.badge_outlined,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text:
                                        job.fileName ??
                                        "Upload Experience Letter Photo",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                  const SizedBox(height: 2),
                                  AppText(
                                    text:
                                        "Certificate of employment or experience letter",
                                    fontSize: 11,
                                    color: textSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Upload",
                              isIcon: true,
                              icon: Icon(
                                Icons.upload_file_outlined,
                                size: 15,
                                color: primaryColor,
                              ),
                              isOutlined: true,
                              height: 36,
                              width: 110,
                              fontSize: 12,
                              onTap: () => provider.pickJobImage(index),
                            ),
                            if (provider.workExperiences.length > 1) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red[400],
                                  size: 20,
                                ),
                                onPressed: () =>
                                    provider.removeWorkExperience(index),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildResponsiveRow([
                          _buildField(
                            label: "Job Title",
                            child: CustomTextField(
                              hintText: "Enter job or role title",
                              onChanged: (val) => job.jobTitle = val,
                            ),
                          ),
                          _buildField(
                            label: "Organization / Company Name",
                            child: CustomTextField(
                              hintText: "Enter organization name",
                              onChanged: (val) =>
                                  job.jobOrganizationTitle = val,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildResponsiveRow([
                          _buildField(
                            label: "Years of Experience",
                            child: CustomTextField(
                              hintText: "Enter years of experience",
                              textInputType: TextInputType.number,
                              onChanged: (val) =>
                                  job.jobYearsOfExperience = val,
                            ),
                          ),
                          _buildField(
                            label: "Organization Address",
                            child: CustomTextField(
                              hintText: "Enter organization physical address",
                              onChanged: (val) =>
                                  job.jobOrganizationAddress = val,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildField(
                          label: "Start Date",
                          child: CustomDatePickerField(
                            initialValue: job.jobStartDate,
                            hintText: "YYYY-MM-DD",
                            onChanged: (val) => job.jobStartDate = val,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable: job.isCurrentlyWorkingNotifier,
                          builder: (context, isWorking, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isWorking,
                                      activeColor: primaryColor,
                                      onChanged: (val) {
                                        provider.toggleJobCurrentlyWorking(
                                          index,
                                          val ?? false,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    AppText(
                                      text: "Currently working here",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                if (!isWorking) ...[
                                  const SizedBox(height: 8),
                                  _buildField(
                                    label: "End Date",
                                    child: CustomDatePickerField(
                                      initialValue: job.jobEndDate,
                                      hintText: "YYYY-MM-DD",
                                      onChanged: (val) => job.jobEndDate = val,
                                    ),
                                  ),
                                ],
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

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildResponsiveRow(List<Widget> children) {
    if (context.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: c,
                ),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: children
          .map(
            (c) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
          )
          .toList(),
    );
  }
}
