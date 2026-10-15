import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../shared/presentation/widgets/custom_date_picker_field.dart';
import '../providers/lab_onboarding_provider.dart';

class LabOnboardingScreen extends StatefulWidget {
  const LabOnboardingScreen({super.key});

  @override
  State<LabOnboardingScreen> createState() => _LabOnboardingScreenState();
}

class _LabOnboardingScreenState extends State<LabOnboardingScreen>
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

  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessPhoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _designationController;
  late final TextEditingController _bioController;

  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _provinceController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _businessEmailController = TextEditingController();
    _businessPhoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _designationController = TextEditingController();
    _bioController = TextEditingController();

    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _provinceController = TextEditingController();
    _zipCodeController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _countryCodeController = TextEditingController(text: 'US');
    _countryNameController = TextEditingController(text: 'United States');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LabOnboardingProvider>();
      if (!provider.isDataLoaded) {
        provider.loadTaxonomyData();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _designationController.dispose();
    _bioController.dispose();

    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _provinceController.dispose();
    _zipCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    super.dispose();
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Selector<LabOnboardingProvider, String?>(
      selector: (_, p) => p.profileImageBase64,
      builder: (context, base64Uri, _) {
        Widget avatarContent;
        if (base64Uri != null && base64Uri.isNotEmpty) {
          try {
            final cleanBase64 = base64Uri.contains(',')
                ? base64Uri.split(',').last
                : base64Uri;
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
                  Icons.biotech_rounded,
                  color: primaryColor,
                  size: 44,
                ),
              ),
            );
          } catch (_) {
            avatarContent = Icon(
              Icons.biotech_rounded,
              color: primaryColor,
              size: 44,
            );
          }
        } else {
          avatarContent = Icon(
            Icons.biotech_rounded,
            color: primaryColor,
            size: 44,
          );
        }

        return InkWell(
          onTap: () => context.read<LabOnboardingProvider>().pickProfileImage(),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Center(child: avatarContent),
          ),
        );
      },
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
        const SizedBox(height: 8),
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
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: c,
            ),
          )
          .toList(),
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
                text: "Diagnostic Lab Administration",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppText(
          text: "Diagnostic Lab Onboarding",
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        AppText(
          text:
              "Register head office credentials, laboratory accreditations, test catalog specialities, and operating schedules in one master entry.",
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildLabInfoSection(BuildContext context) {
    final provider = context.read<LabOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Laboratory Information & Credentials",
            "Official lab brand name, contact details, account credentials, and logo.",
            Icons.biotech_rounded,
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
                        text: "Laboratory Logo / Emblem",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 4),
                      Selector<LabOnboardingProvider, String?>(
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
                  text: "Upload Logo",
                  isIcon: true,
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: primaryColor,
                  ),
                  isOutlined: true,
                  height: 40,
                  width: 140,
                  fontSize: 13,
                  onTap: () => provider.pickProfileImage(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildResponsiveRow([
            _buildField(
              label: "Laboratory Name *",
              child: CustomTextField(
                controller: _titleController,
                hintText: "e.g. Apex Animal Reference Laboratory",
              ),
            ),
            _buildField(
              label: "Official Email Address *",
              child: CustomTextField(
                controller: _emailController,
                hintText: "lab@example.com",
                textInputType: TextInputType.emailAddress,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Contact Phone Number *",
              child: CustomTextField(
                controller: _phoneController,
                hintText: "+1 (555) 000-0000",
                textInputType: TextInputType.phone,
              ),
            ),
            _buildField(
              label: "Designation / Role",
              child: CustomTextField(
                controller: _designationController,
                hintText: "e.g. Lab Director / Chief Pathologist",
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Business Email (Public / Invoices)",
              child: CustomTextField(
                controller: _businessEmailController,
                hintText: "e.g. contact@labfacility.com",
                textInputType: TextInputType.emailAddress,
              ),
            ),
            _buildField(
              label: "Business Phone (Direct Line)",
              child: CustomTextField(
                controller: _businessPhoneController,
                hintText: "e.g. +1 (845) 282-5469",
                textInputType: TextInputType.phone,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Lab Category / Type",
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Selector<LabOnboardingProvider, String>(
                  selector: (_, p) => p.selectedLabType,
                  builder: (context, currentType, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentType,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondaryColor,
                        ),
                        items: provider.availableLabTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: AppText(text: type, fontSize: 13),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            provider.setLabType(val);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildField(
              label: "Operating Time Zone",
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Selector<LabOnboardingProvider, String>(
                  selector: (_, p) => p.selectedTimeZone,
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
                            provider.setTimeZone(val);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildField(
              label: "Average Turnaround Time",
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Selector<LabOnboardingProvider, String>(
                  selector: (_, p) => p.selectedTurnAroundTime,
                  builder: (context, currentTAT, _) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentTAT,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondaryColor,
                        ),
                        items: provider.availableTurnAroundTimes.map((tat) {
                          return DropdownMenuItem<String>(
                            value: tat,
                            child: AppText(text: tat, fontSize: 13),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            provider.setTurnAroundTime(val);
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

          _buildResponsiveRow([
            _buildField(
              label: "Portal Access Password *",
              child: CustomTextField(
                controller: _passwordController,
                hintText: "Enter password (min 6 characters)",
                isObSecure: true,
              ),
            ),
            _buildField(
              label: "Confirm Password *",
              child: CustomTextField(
                controller: _confirmPasswordController,
                hintText: "Re-enter password",
                isObSecure: true,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildField(
            label: "Laboratory Overview / Bio",
            child: CustomTextField(
              controller: _bioController,
              hintText:
                  "Describe diagnostic capabilities, sample turnaround times, test equipment, and clinical focus...",
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Physical Facility & Geographic Location",
            "Central testing facility address, GPS latitude/longitude coordinates, and country routing.",
            Icons.location_on_outlined,
          ),
          const SizedBox(height: 20),

          _buildResponsiveRow([
            _buildField(
              label: "Street Address *",
              child: CustomTextField(
                controller: _addressController,
                hintText: "e.g. 4 Some Lane, Suite 100",
              ),
            ),
            _buildField(
              label: "City *",
              child: CustomTextField(
                controller: _cityController,
                hintText: "e.g. New York",
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "State / Province",
              child: CustomTextField(
                controller: _stateController,
                hintText: "e.g. New York",
              ),
            ),
            _buildField(
              label: "ZIP / Postal Code *",
              child: CustomTextField(
                controller: _zipCodeController,
                hintText: "e.g. 10980",
                textInputType: TextInputType.number,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Latitude Coordinate *",
              child: CustomTextField(
                controller: _latitudeController,
                hintText: "e.g. 41.239233",
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
            _buildField(
              label: "Longitude Coordinate *",
              child: CustomTextField(
                controller: _longitudeController,
                hintText: "e.g. -74.056260",
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Country Code *",
              child: CustomTextField(
                controller: _countryCodeController,
                hintText: "e.g. US or PK",
              ),
            ),
            _buildField(
              label: "Country Name *",
              child: CustomTextField(
                controller: _countryNameController,
                hintText: "e.g. United States",
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildServiceLocationsSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Service & Sample Collection Locations",
            "Select all service fulfillment methods supported for sample pickup and intake.",
            Icons.local_shipping_outlined,
          ),
          const SizedBox(height: 20),

          Consumer<LabOnboardingProvider>(
            builder: (context, p, _) {
              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: p.availableServiceLocations.map((loc) {
                  final isSelected = p.selectedServiceLocations.contains(loc);
                  return FilterChip(
                    avatar: Icon(
                      loc == 'Home'
                          ? Icons.home_outlined
                          : Icons.business_outlined,
                      size: 16,
                      color: isSelected ? primaryColor : textSecondaryColor,
                    ),
                    label: AppText(
                      text: loc,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
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
                    onSelected: (_) => p.toggleServiceLocation(loc),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLicensesSection(BuildContext context) {
    final provider = context.read<LabOnboardingProvider>();
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  "Accreditations & State Licenses",
                  "Clinical laboratory certifications, CLIA IDs, and state veterinary board permits.",
                  Icons.verified_outlined,
                ),
              ),
              CustomButton(
                text: "Add License",
                isIcon: true,
                icon: Icon(Icons.add, size: 16, color: primaryColor),
                isOutlined: true,
                height: 38,
                width: 140,
                fontSize: 13,
                onTap: () => provider.addLicense(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Consumer<LabOnboardingProvider>(
            builder: (context, p, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: p.licenses.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final license = p.licenses[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "License / Certification #${index + 1}",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          if (p.licenses.length > 1)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.shade400,
                                size: 20,
                              ),
                              tooltip: "Remove License",
                              onPressed: () => p.removeLicense(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildResponsiveRow([
                        _buildField(
                          label: "License / Permit Number *",
                          child: CustomTextField(
                            hintText: "e.g. VET-LAB-9921",
                            onChanged: (val) => license.licenseNumber = val,
                          ),
                        ),
                        _buildField(
                          label: "State / Jurisdiction",
                          child: CustomTextField(
                            hintText: "e.g. Texas",
                            onChanged: (val) => license.state = val,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _buildResponsiveRow([
                        _buildField(
                          label: "State Abbreviation",
                          child: CustomTextField(
                            hintText: "e.g. TX",
                            onChanged: (val) =>
                                license.stateAbbreviation = val,
                          ),
                        ),
                        _buildField(
                          label: "Expiry Date",
                          child: CustomDatePickerField(
                            hintText: "YYYY-MM-DD",
                            onChanged: (val) => license.licenseExpiryDate = val,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.file_present_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppText(
                                text:
                                    license.fileName ??
                                    "Attach certificate document (PDF, JPG, PNG)",
                                fontSize: 13,
                                color: license.fileName != null
                                    ? textPrimaryColor
                                    : textSecondaryColor,
                              ),
                            ),
                            CustomButton(
                              text: "Upload File",
                              height: 36,
                              width: 120,
                              fontSize: 12,
                              isOutlined: true,
                              onTap: () => p.pickLicenseImage(index),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildDiagnosticCategoriesSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Diagnostic Test Catalog Specialties",
            "Select all clinical testing categories offered by this laboratory.",
            Icons.science_outlined,
          ),
          const SizedBox(height: 20),

          Consumer<LabOnboardingProvider>(
            builder: (context, p, _) {
              if (p.availableLabTestCategories.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: AppText(
                    text: "Loading diagnostic test categories...",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 10,
                children: p.availableLabTestCategories.map((cat) {
                  final isSelected = p.selectedLabTestCategoryIds.contains(
                    cat.id,
                  );
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
                    onSelected: (_) => p.toggleLabTestCategory(cat.id),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPetCategoriesSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Supported Animal / Pet Species",
            "Select all pet and animal classifications supported for sample diagnostics.",
            Icons.pets_rounded,
          ),
          const SizedBox(height: 20),

          Consumer<LabOnboardingProvider>(
            builder: (context, p, _) {
              if (p.availablePetCategories.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: AppText(
                    text: "Loading animal categories...",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 10,
                children: p.availablePetCategories.map((pet) {
                  final isSelected = p.selectedPetCategoryIds.contains(pet.id);
                  return FilterChip(
                    label: AppText(
                      text: pet.title,
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
                    onSelected: (_) => p.togglePetCategory(pet.id),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingScheduleSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Weekly Operating Schedule",
            "Specify sample receiving and operating hours for each day of the week (Sunday through Saturday).",
            Icons.access_time_rounded,
          ),
          const SizedBox(height: 20),

          Consumer<LabOnboardingProvider>(
            builder: (context, p, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: p.availableDays.length,
                separatorBuilder: (context, index) => const Divider(height: 18),
                itemBuilder: (context, index) {
                  final day = p.availableDays[index];
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
                            p.toggleDayAvailability(index, val ?? false),
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
                          onTap: () => p.selectDayTime(context, index, true),
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
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => p.selectDayTime(context, index, false),
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
                  _buildLabInfoSection(context),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildServiceLocationsSection(),
                  const SizedBox(height: 24),
                  _buildLicensesSection(context),
                  const SizedBox(height: 24),
                  _buildDiagnosticCategoriesSection(),
                  const SizedBox(height: 24),
                  _buildPetCategoriesSection(),
                  const SizedBox(height: 24),
                  _buildOperatingScheduleSection(),
                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Selector<LabOnboardingProvider, bool>(
                      selector: (_, p) => p.isLoading,
                      builder: (context, isLoading, _) {
                        return CustomButton(
                          text: "Submit Lab Onboarding Application",
                          isIcon: true,
                          icon: Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: whiteColor,
                          ),
                          isLoading: isLoading,
                          height: 48,
                          width: 310,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          onTap: () async {
                            final success = await context
                                .read<LabOnboardingProvider>()
                                .submitLab(
                                  context,
                                  title: _titleController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  businessEmail: _businessEmailController.text,
                                  businessPhone: _businessPhoneController.text,
                                  countryCode: _countryCodeController.text,
                                  countryName: _countryNameController.text,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  bio: _bioController.text,
                                  address: _addressController.text,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  province: _provinceController.text,
                                  zipCode: _zipCodeController.text,
                                  latitude: _latitudeController.text,
                                  longitude: _longitudeController.text,
                                  designation: _designationController.text,
                                );
                            if (success) {
                              _titleController.clear();
                              _emailController.clear();
                              _phoneController.clear();
                              _businessEmailController.clear();
                              _businessPhoneController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                              _bioController.clear();
                              _addressController.clear();
                              _cityController.clear();
                              _stateController.clear();
                              _provinceController.clear();
                              _zipCodeController.clear();
                              _latitudeController.clear();
                              _longitudeController.clear();
                              _countryCodeController.text = 'US';
                              _countryNameController.text = 'United States';
                              _designationController.clear();
                            }
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
}
