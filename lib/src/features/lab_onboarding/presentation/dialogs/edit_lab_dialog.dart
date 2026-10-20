import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_country_picker_field.dart';
import '../../../../core/presentation/widgets/app_logo.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/mini_functions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/custom_date_picker_field.dart';
import '../../../../shared/taxonomy/domain/entities/pet_category_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/lab_entity.dart';
import '../../domain/entities/update_lab_entity.dart';
import '../../domain/usecases/lab_onboarding_usecases.dart';
import '../providers/labs_list_provider.dart';

class _EditLabLicenseItem {
  String? licenseImageDataURI;
  String? fileName;
  final String? existingImageUrl;
  final TextEditingController licenseNumberController;
  final TextEditingController stateController;
  final TextEditingController stateAbbrController;
  final TextEditingController expiryDateController;

  _EditLabLicenseItem({
    String? licenseNumber,
    String? state,
    String? stateAbbreviation,
    String? expiryDate,
    this.existingImageUrl,
  })  : licenseNumberController =
            TextEditingController(text: licenseNumber ?? ''),
        stateController = TextEditingController(text: state ?? ''),
        stateAbbrController =
            TextEditingController(text: stateAbbreviation ?? ''),
        expiryDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(expiryDate),
        );

  void dispose() {
    licenseNumberController.dispose();
    stateController.dispose();
    stateAbbrController.dispose();
    expiryDateController.dispose();
  }

  UpdateLabLicenseEntity? toEntity() {
    final number = licenseNumberController.text.trim();
    final stateVal = stateController.text.trim();
    final stateAbbr = stateAbbrController.text.trim();
    final expiry = expiryDateController.text.trim();

    if (number.isEmpty &&
        stateVal.isEmpty &&
        stateAbbr.isEmpty &&
        expiry.isEmpty &&
        licenseImageDataURI == null) {
      return null;
    }

    return UpdateLabLicenseEntity(
      licenseNumber: number.isNotEmpty ? number : null,
      state: stateVal.isNotEmpty ? stateVal : null,
      stateAbbreviation: stateAbbr.isNotEmpty ? stateAbbr : null,
      licenseExpiryDate: expiry.isNotEmpty ? expiry : null,
      licenseImageDataURI: licenseImageDataURI,
    );
  }
}

class _EditLabDayScheduleItem {
  final int dayIndex;
  final String dayName;
  bool isAvailable;
  String openTime;
  String closeTime;

  _EditLabDayScheduleItem({
    required this.dayIndex,
    required this.dayName,
    required this.isAvailable,
    required this.openTime,
    required this.closeTime,
  });

  String get openMinutes {
    final parts = openTime.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return (h * 60 + m).toString();
    }
    return '540';
  }

  String get closeMinutes {
    final parts = closeTime.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return (h * 60 + m).toString();
    }
    return '1020';
  }

  UpdateLabAvailableDayEntity toEntity() {
    return UpdateLabAvailableDayEntity(
      isAvailable: isAvailable,
      openTime: isAvailable ? openTime : null,
      closeTime: isAvailable ? closeTime : null,
      open: isAvailable ? openMinutes : null,
      close: isAvailable ? closeMinutes : null,
    );
  }
}

class EditLabDialog extends StatefulWidget {
  final LabItemEntity lab;

  const EditLabDialog({super.key, required this.lab});

  static Future<bool?> show(
    BuildContext context, {
    required LabItemEntity lab,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditLabDialog(lab: lab),
    );
  }

  @override
  State<EditLabDialog> createState() => _EditLabDialogState();
}

class _EditLabDialogState extends State<EditLabDialog> with AppColors {
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

  static const List<String> _availableLabTypes = [
    'Veterinary Diagnostic Lab',
    'Clinical Pathology Lab',
    'Molecular & Genetic Lab',
    'Microbiology Lab',
    'Toxicology Lab',
    'General Veterinary Reference Lab',
  ];

  static const List<String> _availableServiceLocations = ['Home', 'Office'];

  static const List<String> _availableTurnAroundTimes = [
    'Same Day',
    '24 Hours',
    '2-3 Days',
    '3-5 Days',
    'Depends on test',
  ];

  static const List<String> _daysNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Lab Info & Credentials Controllers
  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessPhoneController;
  late final TextEditingController _designationController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _bioController;

  // Location Controllers
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _provinceController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;

  String _selectedLabType = 'Veterinary Diagnostic Lab';
  String _selectedTimeZone = 'America/New_York';
  String _selectedTurnAroundTime = '2-3 Days';

  String? _profileImageDataURI;
  String? _profileImageFileName;

  final List<String> _selectedServiceLocations = ['Home', 'Office'];

  // Taxonomies
  List<PetCategoryEntity> _availablePetCategories = [];
  bool _isPetCategoriesLoading = false;
  final List<String> _selectedPetCategoryIds = [];

  List<LabTestCategoryEntity> _availableLabTestCategories = [];
  bool _isLabTestCategoriesLoading = false;
  final List<String> _selectedLabTestCategoryIds = [];

  // Repeatable sections
  final List<_EditLabLicenseItem> _licenses = [];
  final List<_EditLabDayScheduleItem> _availableDays = [];

  @override
  void initState() {
    super.initState();
    final l = widget.lab;

    _titleController = TextEditingController(text: l.title);
    _emailController = TextEditingController(text: l.email);
    _phoneController = TextEditingController(text: l.phone ?? '');
    _businessEmailController = TextEditingController(text: l.email);
    _businessPhoneController = TextEditingController(text: l.phone ?? '');
    _designationController = TextEditingController(
      text: l.designation ?? 'Lab Director / Chief Pathologist',
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _bioController = TextEditingController(text: l.bio ?? '');

    _addressController = TextEditingController(
      text: l.address ?? l.location?.address ?? '',
    );
    _cityController = TextEditingController(text: l.city ?? '');
    _stateController = TextEditingController(text: l.state ?? '');
    _provinceController = TextEditingController(text: l.state ?? '');
    _zipCodeController = TextEditingController();
    _latitudeController = TextEditingController(
      text: l.location?.calculatedLatitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: l.location?.calculatedLongitude?.toString() ?? '',
    );
    _countryCodeController = TextEditingController(text: 'US');
    _countryNameController = TextEditingController(
      text: l.country ?? 'United States',
    );

    if (l.labType != null && _availableLabTypes.contains(l.labType)) {
      _selectedLabType = l.labType!;
    }

    // Populate Licenses
    if (l.licenses.isNotEmpty) {
      for (final lic in l.licenses) {
        _licenses.add(
          _EditLabLicenseItem(
            licenseNumber: lic.number,
            state: lic.state,
            expiryDate: lic.expiryDate,
            existingImageUrl: lic.image,
          ),
        );
      }
    } else {
      _licenses.add(_EditLabLicenseItem());
    }

    // Populate Operating Schedule (7 days)
    _initSchedule(l.availableDays);

    // Fetch taxonomies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTaxonomies();
    });
  }

  void _initSchedule(List<LabAvailableDayEntity> existingDays) {
    _availableDays.clear();
    for (int i = 0; i < 7; i++) {
      final name = _daysNames[i];
      LabAvailableDayEntity? matched;
      for (final d in existingDays) {
        if (d.day?.toLowerCase() == name.toLowerCase()) {
          matched = d;
          break;
        }
      }
      if (matched == null && i < existingDays.length) {
        matched = existingDays[i];
      }

      if (matched != null) {
        _availableDays.add(
          _EditLabDayScheduleItem(
            dayIndex: i,
            dayName: name,
            isAvailable: matched.isAvailable,
            openTime: matched.openTime ?? '09:00',
            closeTime: matched.closeTime ?? '17:00',
          ),
        );
      } else {
        _availableDays.add(
          _EditLabDayScheduleItem(
            dayIndex: i,
            dayName: name,
            isAvailable: i != 0,
            openTime: '09:00',
            closeTime: '17:00',
          ),
        );
      }
    }
  }

  Future<void> _fetchTaxonomies() async {
    setState(() {
      _isPetCategoriesLoading = true;
      _isLabTestCategoriesLoading = true;
    });

    try {
      final petCats = await sl<TaxonomyUseCases>().getPetCategories();
      if (mounted) {
        setState(() {
          _availablePetCategories = petCats;
          for (final existing in widget.lab.petCategories) {
            final existingId = existing.id ?? existing.petCategory;
            for (final cat in petCats) {
              if (cat.id == existingId ||
                  cat.title.toLowerCase() == existing.title.toLowerCase()) {
                if (!_selectedPetCategoryIds.contains(cat.id)) {
                  _selectedPetCategoryIds.add(cat.id);
                }
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching pet categories: $e");
    } finally {
      if (mounted) setState(() => _isPetCategoriesLoading = false);
    }

    try {
      final testCatsResp =
          await sl<LabOnboardingUseCases>().getLabTestCategories(pageSize: 100);
      if (mounted) {
        setState(() {
          _availableLabTestCategories = testCatsResp.docs;
          for (final existing in widget.lab.labTestCategories) {
            final existingId = existing.id ?? existing.labTestCategory;
            for (final cat in testCatsResp.docs) {
              if (cat.id == existingId ||
                  cat.title.toLowerCase() == existing.title.toLowerCase()) {
                if (!_selectedLabTestCategoryIds.contains(cat.id)) {
                  _selectedLabTestCategoryIds.add(cat.id);
                }
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching lab test categories: $e");
    } finally {
      if (mounted) setState(() => _isLabTestCategoriesLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );
      if (picked != null && picked.files.isNotEmpty) {
        final platformFile = picked.files.first;
        final bytes = platformFile.bytes;
        if (bytes != null) {
          final base64String = base64Encode(bytes);
          final extension = (platformFile.extension ?? 'jpeg').toLowerCase();
          final mime = 'image/$extension';
          setState(() {
            _profileImageDataURI = 'data:$mime;base64,$base64String';
            _profileImageFileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) showToast(context, "Failed to pick image: $e", isError: true);
    }
  }

  Future<void> _pickLicenseImage(_EditLabLicenseItem item) async {
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
        withData: true,
      );
      if (picked != null && picked.files.isNotEmpty) {
        final platformFile = picked.files.first;
        final bytes = platformFile.bytes;
        if (bytes != null) {
          final base64String = base64Encode(bytes);
          final extension = (platformFile.extension ?? 'jpeg').toLowerCase();
          final mime =
              extension == 'pdf' ? 'application/pdf' : 'image/$extension';
          setState(() {
            item.licenseImageDataURI = 'data:$mime;base64,$base64String';
            item.fileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) showToast(context, "Failed to pick file: $e", isError: true);
    }
  }

  Future<void> _selectDayTime(
    _EditLabDayScheduleItem day,
    bool isOpenTime,
  ) async {
    final currentTimeStr = isOpenTime ? day.openTime : day.closeTime;
    final parts = currentTimeStr.split(':');
    final initialHour = parts.length == 2 ? int.tryParse(parts[0]) ?? 9 : 9;
    final initialMinute = parts.length == 2 ? int.tryParse(parts[1]) ?? 0 : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      setState(() {
        if (isOpenTime) {
          day.openTime = '$hourStr:$minuteStr';
        } else {
          day.closeTime = '$hourStr:$minuteStr';
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _designationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

    for (final lic in _licenses) {
      lic.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit(LabsListProvider provider) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showToast(context, "Laboratory Name is required", isError: true);
      return;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showToast(context, "Official Email is required", isError: true);
      return;
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      showToast(context, "Phone Number is required", isError: true);
      return;
    }

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (password.isNotEmpty && password != confirmPassword) {
      showToast(context, "Passwords do not match", isError: true);
      return;
    }

    final address = _addressController.text.trim();
    if (address.isEmpty) {
      showToast(context, "Street Address is required", isError: true);
      return;
    }

    final city = _cityController.text.trim();
    if (city.isEmpty) {
      showToast(context, "City is required", isError: true);
      return;
    }

    final zipCode = _zipCodeController.text.trim();
    if (zipCode.isEmpty) {
      showToast(context, "ZIP Code is required", isError: true);
      return;
    }

    final latitude = _latitudeController.text.trim();
    final longitude = _longitudeController.text.trim();

    final validLicenses = _licenses
        .map((l) => l.toEntity())
        .whereType<UpdateLabLicenseEntity>()
        .toList();

    final availableDays = _availableDays.map((d) => d.toEntity()).toList();

    final entity = UpdateLabEntity(
      profileImageDataURI: _profileImageDataURI,
      title: title,
      fullName: title,
      email: email,
      phone: phone,
      businessEmail: _businessEmailController.text.trim().isNotEmpty
          ? _businessEmailController.text.trim()
          : null,
      businessPhone: _businessPhoneController.text.trim().isNotEmpty
          ? _businessPhoneController.text.trim()
          : null,
      designation: _designationController.text.trim().isNotEmpty
          ? _designationController.text.trim()
          : null,
      labType: _selectedLabType,
      password: password.isNotEmpty ? password : null,
      bio: _bioController.text.trim().isNotEmpty
          ? _bioController.text.trim()
          : null,
      address: address,
      city: city,
      province: _provinceController.text.trim().isNotEmpty
          ? _provinceController.text.trim()
          : (_stateController.text.trim().isNotEmpty
              ? _stateController.text.trim()
              : null),
      countryCode: _countryCodeController.text.trim().isNotEmpty
          ? _countryCodeController.text.trim()
          : 'US',
      countryName: _countryNameController.text.trim().isNotEmpty
          ? _countryNameController.text.trim()
          : 'United States',
      zipCode: zipCode,
      latitude: latitude.isNotEmpty ? latitude : null,
      longitude: longitude.isNotEmpty ? longitude : null,
      timeZone: _selectedTimeZone,
      averageTurnAroundTime: _selectedTurnAroundTime,
      serviceLocations: _selectedServiceLocations.isNotEmpty
          ? _selectedServiceLocations
          : null,
      licenses: validLicenses.isNotEmpty ? validLicenses : null,
      petCategories: _selectedPetCategoryIds.isNotEmpty
          ? _selectedPetCategoryIds
          : null,
      labTestCategories: _selectedLabTestCategoryIds.isNotEmpty
          ? _selectedLabTestCategoryIds
          : null,
      availableDays: availableDays,
    );

    final success = await provider.updateLab(
      context: context,
      id: widget.lab.id,
      entity: entity,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  // Exact Onboarding Layout Components
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
    if (children.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _buildImagePreview({
    required String? dataUri,
    required String? existingNetworkUrl,
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
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Icon(fallbackIcon, size: 28, color: textSecondaryColor),
          ),
        );
      } catch (_) {}
    }

    if (existingNetworkUrl != null && existingNetworkUrl.isNotEmpty) {
      final fullUrl = MiniFunctions.getImageUrl(existingNetworkUrl);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          fullUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
                Icon(fallbackIcon, size: 28, color: textSecondaryColor),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Icon(fallbackIcon, color: primaryColor, size: 28),
      ),
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
          text: "Edit Diagnostic Lab Details",
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        AppText(
          text:
              "Update head office credentials, laboratory accreditations, test catalog specialities, and operating schedules in one master entry.",
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  // SECTION 1: Laboratory Information & Credentials
  Widget _buildLabInfoSection() {
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

          // Logo / Emblem Upload Banner (Exact Onboarding UI)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                _buildImagePreview(
                  dataUri: _profileImageDataURI,
                  existingNetworkUrl: widget.lab.image,
                  width: 70,
                  height: 70,
                  radius: 35,
                  fallbackIcon: Icons.biotech_rounded,
                ),
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
                      AppText(
                        text: _profileImageFileName ??
                            "JPEG, PNG or WebP up to 5MB. Click button to upload.",
                        fontSize: 12,
                        color: textSecondaryColor,
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
                  onTap: _pickProfileImage,
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLabType,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textSecondaryColor,
                    ),
                    items: _availableLabTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: AppText(text: type, fontSize: 13),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLabType = val);
                      }
                    },
                  ),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _timeZones.contains(_selectedTimeZone)
                        ? _selectedTimeZone
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
                        setState(() => _selectedTimeZone = val);
                      }
                    },
                  ),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTurnAroundTime,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textSecondaryColor,
                    ),
                    items: _availableTurnAroundTimes.map((tat) {
                      return DropdownMenuItem<String>(
                        value: tat,
                        child: AppText(text: tat, fontSize: 13),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedTurnAroundTime = val);
                      }
                    },
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Portal Access Password",
              child: CustomTextField(
                controller: _passwordController,
                hintText: "Leave blank to keep current password",
                isObSecure: true,
              ),
            ),
            _buildField(
              label: "Confirm Password",
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

  // SECTION 2: Physical Facility & Geographic Location
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
              label: "Latitude Coordinate",
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
              label: "Longitude Coordinate",
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
              label: "Country",
              child: AppCountryPickerField(
                countryCodeController: _countryCodeController,
                countryNameController: _countryNameController,
                onCountryChanged: (name, code) {
                  setState(() {});
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // SECTION 3: Service & Sample Collection Locations
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

          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _availableServiceLocations.map((loc) {
              final isSelected = _selectedServiceLocations.contains(loc);
              return FilterChip(
                avatar: Icon(
                  loc == 'Home' ? Icons.home_outlined : Icons.business_outlined,
                  size: 16,
                  color: isSelected ? primaryColor : textSecondaryColor,
                ),
                label: AppText(
                  text: loc,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedServiceLocations.add(loc);
                    } else {
                      _selectedServiceLocations.remove(loc);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // SECTION 4: Accreditations & State Licenses
  Widget _buildLicensesSection() {
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
                onTap: () {
                  setState(() => _licenses.add(_EditLabLicenseItem()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _licenses.length,
            separatorBuilder: (context, index) => const Divider(height: 32),
            itemBuilder: (context, index) {
              final license = _licenses[index];
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
                      if (_licenses.length > 1)
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          tooltip: "Remove License",
                          onPressed: () {
                            setState(() {
                              final removed = _licenses.removeAt(index);
                              removed.dispose();
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildResponsiveRow([
                    _buildField(
                      label: "License / Permit Number *",
                      child: CustomTextField(
                        controller: license.licenseNumberController,
                        hintText: "e.g. VET-LAB-9921",
                      ),
                    ),
                    _buildField(
                      label: "State / Jurisdiction",
                      child: CustomTextField(
                        controller: license.stateController,
                        hintText: "e.g. Texas",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildResponsiveRow([
                    _buildField(
                      label: "State Abbreviation",
                      child: CustomTextField(
                        controller: license.stateAbbrController,
                        hintText: "e.g. TX",
                      ),
                    ),
                    _buildField(
                      label: "Expiry Date",
                      child: CustomDatePickerField(
                        controller: license.expiryDateController,
                        hintText: "YYYY-MM-DD",
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
                        _buildImagePreview(
                          dataUri: license.licenseImageDataURI,
                          existingNetworkUrl: license.existingImageUrl,
                          width: 44,
                          height: 44,
                          radius: 6,
                          fallbackIcon: Icons.file_present_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: license.fileName ??
                                    ((license.existingImageUrl != null &&
                                            license.existingImageUrl!.isNotEmpty)
                                        ? "Current Certificate Document Attached"
                                        : "Attach certificate document (PDF, JPG, PNG)"),
                                fontSize: 13,
                                color: textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: "Official accreditation or board proof",
                                fontSize: 11,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: "Upload File",
                          height: 36,
                          width: 120,
                          fontSize: 12,
                          isOutlined: true,
                          onTap: () => _pickLicenseImage(license),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // SECTION 5: Diagnostic Test Catalog Specialties
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

          if (_isLabTestCategoriesLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AppText(
                text: "Loading diagnostic test categories...",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            )
          else if (_availableLabTestCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AppText(
                text: "No diagnostic test categories available.",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _availableLabTestCategories.map((cat) {
                final isSelected =
                    _selectedLabTestCategoryIds.contains(cat.id);
                return FilterChip(
                  label: AppText(
                    text: cat.title,
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
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedLabTestCategoryIds.add(cat.id);
                      } else {
                        _selectedLabTestCategoryIds.remove(cat.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // SECTION 6: Supported Animal / Pet Species
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

          if (_isPetCategoriesLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AppText(
                text: "Loading animal categories...",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            )
          else if (_availablePetCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AppText(
                text: "No animal categories available.",
                fontSize: 13,
                color: textSecondaryColor,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _availablePetCategories.map((pet) {
                final isSelected = _selectedPetCategoryIds.contains(pet.id);
                return FilterChip(
                  label: AppText(
                    text: pet.title,
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
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPetCategoryIds.add(pet.id);
                      } else {
                        _selectedPetCategoryIds.remove(pet.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // SECTION 7: Weekly Operating Schedule
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

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availableDays.length,
            separatorBuilder: (context, index) => const Divider(height: 18),
            itemBuilder: (context, index) {
              final day = _availableDays[index];
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
                    onChanged: (val) {
                      setState(() => day.isAvailable = val ?? false);
                    },
                  ),
                  AppText(
                    text: day.isAvailable ? "Open" : "Closed",
                    fontSize: 12,
                    color: day.isAvailable ? primaryColor : textSecondaryColor,
                  ),
                  const Spacer(),
                  if (day.isAvailable) ...[
                    InkWell(
                      onTap: () => _selectDayTime(day, true),
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
                      onTap: () => _selectDayTime(day, false),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth >= 1100 ? 980.0 : (screenWidth * 0.94);
    final dialogHeight = screenHeight * 0.92;

    return Consumer<LabsListProvider>(
      builder: (context, provider, _) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: backgroundColor,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeader(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: provider.isUpdating
                          ? null
                          : () => Navigator.of(context).pop(),
                      tooltip: "Close",
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Scrollable Form Sections (Exact 7 Onboarding Sections)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabInfoSection(),
                        const SizedBox(height: 24),
                        _buildLocationSection(),
                        const SizedBox(height: 24),
                        _buildServiceLocationsSection(),
                        const SizedBox(height: 24),
                        _buildLicensesSection(),
                        const SizedBox(height: 24),
                        _buildDiagnosticCategoriesSection(),
                        const SizedBox(height: 24),
                        _buildPetCategoriesSection(),
                        const SizedBox(height: 24),
                        _buildOperatingScheduleSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Dialog Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: "Cancel",
                      isOutlined: true,
                      height: 42,
                      width: 110,
                      fontSize: 13,
                      radius: 8,
                      onTap: provider.isUpdating
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 14),
                    CustomButton(
                      text: "Save & Update Lab",
                      isLoading: provider.isUpdating,
                      height: 42,
                      width: 200,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      radius: 8,
                      onTap: () => _handleSubmit(provider),
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
}
