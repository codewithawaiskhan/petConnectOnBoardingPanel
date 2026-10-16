import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/mini_functions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/custom_date_picker_field.dart';
import '../../../../shared/taxonomy/domain/entities/pet_category_entity.dart';
import '../../../../shared/taxonomy/domain/entities/service_entity.dart';
import '../../../../shared/taxonomy/domain/entities/speciality_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../../domain/entities/doctor_onboarding_entity.dart';
import '../../domain/entities/update_doctor_entity.dart';
import '../providers/vets_list_provider.dart';

class _VetLicenseItem {
  final TextEditingController numberController;
  final TextEditingController stateController;
  final TextEditingController stateAbbrController;
  final TextEditingController expiryDateController;
  String? licenseImageDataURI;
  String? fileName;
  final String? existingImageUrl;

  _VetLicenseItem({
    String? number,
    String? state,
    String? stateAbbreviation,
    String? expiryDate,
    this.existingImageUrl,
  })  : numberController = TextEditingController(text: number ?? ''),
        stateController = TextEditingController(text: state ?? ''),
        stateAbbrController = TextEditingController(
          text: stateAbbreviation ?? '',
        ),
        expiryDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(expiryDate),
        );

  void dispose() {
    numberController.dispose();
    stateController.dispose();
    stateAbbrController.dispose();
    expiryDateController.dispose();
  }

  UpdateDoctorLicenseEntity? toEntity() {
    final number = numberController.text.trim();
    final state = stateController.text.trim();
    final stateAbbr = stateAbbrController.text.trim();
    final expiry = expiryDateController.text.trim();
    if (number.isEmpty &&
        state.isEmpty &&
        stateAbbr.isEmpty &&
        expiry.isEmpty &&
        licenseImageDataURI == null) {
      return null;
    }
    return UpdateDoctorLicenseEntity(
      licenseNumber: number.isNotEmpty ? number : null,
      state: state.isNotEmpty ? state : null,
      stateAbbreviation: stateAbbr.isNotEmpty ? stateAbbr : null,
      licenseExpiryDate: expiry.isNotEmpty ? expiry : null,
      licenseImageDataURI: licenseImageDataURI,
    );
  }
}

class _VetDaySchedule {
  final int dayIndex;
  final String dayName;
  bool isAvailable;
  String openTime;
  String closeTime;

  _VetDaySchedule({
    required this.dayIndex,
    required this.dayName,
    this.isAvailable = true,
    this.openTime = '09:30',
    this.closeTime = '17:30',
  });

  String get openMinutes {
    final parts = openTime.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return (h * 60 + m).toString();
    }
    return '570';
  }

  String get closeMinutes {
    final parts = closeTime.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return (h * 60 + m).toString();
    }
    return '1050';
  }

  UpdateDoctorAvailableDayEntity toEntity() {
    return UpdateDoctorAvailableDayEntity(
      isAvailable: isAvailable,
      openTime: isAvailable ? openTime : null,
      closeTime: isAvailable ? closeTime : null,
      open: isAvailable ? openMinutes : null,
      close: isAvailable ? closeMinutes : null,
    );
  }
}

class EditVetDialog extends StatefulWidget {
  final DoctorItemEntity doctor;

  const EditVetDialog({super.key, required this.doctor});

  static Future<bool?> show(
    BuildContext context, {
    required DoctorItemEntity doctor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditVetDialog(doctor: doctor),
    );
  }

  @override
  State<EditVetDialog> createState() => _EditVetDialogState();
}

class _EditVetDialogState extends State<EditVetDialog> with AppColors {
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

  static const List<String> _daysNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _designationController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;
  late final TextEditingController _priceController;
  late final TextEditingController _currencyCodeController;
  late final TextEditingController _languagesController;
  late final TextEditingController _bioController;

  String? _selectedGender;
  String _selectedTimeZone = 'America/New_York';
  String? _selectedImageDataURI;
  String? _profileImageFileName;
  bool _isPickingImage = false;

  final List<_VetLicenseItem> _licenses = [];
  final List<_VetDaySchedule> _schedules = [];

  List<PetCategoryEntity> _petCategories = [];
  bool _isLoadingPetCategories = false;
  final Set<String> _selectedPetCategoryIds = {};

  List<SpecialityEntity> _specialities = [];
  bool _isLoadingSpecialities = false;
  String? _selectedSpecialityId;

  List<ServiceEntity> _services = [];
  bool _isLoadingServices = false;
  final Set<String> _selectedServiceIds = {};

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;

    _fullNameController = TextEditingController(text: d.fullName);
    _emailController = TextEditingController(text: d.email);
    _phoneController = TextEditingController(text: d.phone ?? '');
    _designationController = TextEditingController(text: d.designation ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _cityController = TextEditingController(text: d.city ?? '');
    _provinceController = TextEditingController(text: d.province ?? '');
    _countryCodeController = TextEditingController(text: d.countryCode ?? 'US');
    _countryNameController = TextEditingController(
      text: d.countryName ?? 'United States',
    );
    _priceController = TextEditingController(
      text: d.pricePerAppointment?.price?.toString() ?? '',
    );
    _currencyCodeController = TextEditingController(
      text: d.pricePerAppointment?.currencyCode ?? 'USD',
    );
    _selectedTimeZone = (d.timeZone != null && _timeZones.contains(d.timeZone))
        ? d.timeZone!
        : 'America/New_York';
    _languagesController = TextEditingController(
      text: d.knownLanguages.join(', '),
    );
    _bioController = TextEditingController(text: d.bio ?? '');
    _selectedGender = (d.gender != null && d.gender!.isNotEmpty)
        ? d.gender
        : 'Male';

    // Populate Licenses
    if (d.licenses.isNotEmpty) {
      for (final lic in d.licenses) {
        _licenses.add(
          _VetLicenseItem(
            number: lic.number,
            state: lic.state,
            stateAbbreviation: lic.stateAbbreviation,
            expiryDate: lic.expiryDate,
            existingImageUrl: lic.image,
          ),
        );
      }
    } else {
      _licenses.add(_VetLicenseItem());
    }

    // Populate Available Days
    _initSchedules(d.availableDays);

    // Fetch Taxonomy
    _fetchPetCategories();
    _fetchSpecialities();
  }

  void _initSchedules(List<AvailableDayEntity> existingDays) {
    _schedules.clear();
    for (int i = 0; i < 7; i++) {
      final name = _daysNames[i];
      AvailableDayEntity? matched;
      for (final d in existingDays) {
        if (d.dayIndex == i) {
          matched = d;
          break;
        }
      }
      if (matched == null && i < existingDays.length) {
        matched = existingDays[i];
      }

      if (matched != null) {
        _schedules.add(
          _VetDaySchedule(
            dayIndex: i,
            dayName: name,
            isAvailable: matched.isAvailable,
            openTime: matched.openTime ?? '09:30',
            closeTime: matched.closeTime ?? '17:30',
          ),
        );
      } else {
        _schedules.add(
          _VetDaySchedule(
            dayIndex: i,
            dayName: name,
            isAvailable: i != 0,
            openTime: '09:30',
            closeTime: '17:30',
          ),
        );
      }
    }
  }

  Future<void> _fetchPetCategories() async {
    setState(() => _isLoadingPetCategories = true);
    try {
      final categories = await sl<TaxonomyUseCases>().getPetCategories();
      if (mounted) {
        setState(() {
          _petCategories = categories;
          for (final existing in widget.doctor.petCategories) {
            for (final cat in categories) {
              if (cat.id == existing ||
                  cat.title.toLowerCase() == existing.toLowerCase()) {
                _selectedPetCategoryIds.add(cat.id);
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching pet categories: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPetCategories = false);
    }
  }

  Future<void> _fetchSpecialities() async {
    setState(() => _isLoadingSpecialities = true);
    try {
      final specs = await sl<TaxonomyUseCases>().getSpecialities();
      if (mounted) {
        setState(() {
          _specialities = specs;
          if (widget.doctor.specialities.isNotEmpty) {
            final existingSpec = widget.doctor.specialities.first;
            for (final s in specs) {
              if (s.id == existingSpec.id ||
                  s.title.toLowerCase() == existingSpec.title.toLowerCase()) {
                _selectedSpecialityId = s.id;
                break;
              }
            }
            _selectedSpecialityId ??= existingSpec.id;
          } else if (specs.isNotEmpty) {
            _selectedSpecialityId = specs.first.id;
          }
        });

        if (_selectedSpecialityId != null) {
          await _fetchServices(_selectedSpecialityId!);
        }
      }
    } catch (e) {
      debugPrint('Error fetching specialities: $e');
    } finally {
      if (mounted) setState(() => _isLoadingSpecialities = false);
    }
  }

  Future<void> _fetchServices(String specialityId) async {
    setState(() => _isLoadingServices = true);
    try {
      final srvs = await sl<TaxonomyUseCases>().getServices(
        specialityObjectId: specialityId,
      );
      if (mounted) {
        setState(() {
          _services = srvs;
          for (final existing in widget.doctor.services) {
            for (final s in srvs) {
              if (s.id == existing.id ||
                  s.id == existing.serviceId ||
                  (existing.serviceName != null &&
                      s.title.toLowerCase() ==
                          existing.serviceName!.toLowerCase())) {
                _selectedServiceIds.add(s.id);
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching services: $e');
    } finally {
      if (mounted) setState(() => _isLoadingServices = false);
    }
  }

  void _onSpecialitySelected(String? newId) {
    if (newId == null || newId == _selectedSpecialityId) return;
    setState(() {
      _selectedSpecialityId = newId;
      _selectedServiceIds.clear();
      _services.clear();
    });
    _fetchServices(newId);
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
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
            _selectedImageDataURI = 'data:$mime;base64,$base64String';
            _profileImageFileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, "Failed to pick image: $e", isError: true);
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _pickLicenseImage(_VetLicenseItem item) async {
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
          final mime = extension == 'pdf'
              ? 'application/pdf'
              : 'image/$extension';
          setState(() {
            item.licenseImageDataURI = 'data:$mime;base64,$base64String';
            item.fileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, "Failed to pick file: $e", isError: true);
      }
    }
  }

  Future<void> _pickScheduleTime(
    _VetDaySchedule schedule,
    bool isOpenTime,
  ) async {
    final currentTimeStr = isOpenTime ? schedule.openTime : schedule.closeTime;
    final parts = currentTimeStr.split(':');
    final initialHour = parts.length == 2 ? int.tryParse(parts[0]) ?? 9 : 9;
    final initialMinute = parts.length == 2 ? int.tryParse(parts[1]) ?? 30 : 30;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isOpenTime) {
          schedule.openTime = formatted;
        } else {
          schedule.closeTime = formatted;
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _priceController.dispose();
    _currencyCodeController.dispose();
    _languagesController.dispose();
    _bioController.dispose();
    for (final lic in _licenses) {
      lic.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit(VetsListProvider provider) async {
    final fullName = _fullNameController.text.trim();
    if (fullName.isEmpty) {
      showToast(context, "Full Name is required", isError: true);
      return;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showToast(context, "Email is required", isError: true);
      return;
    }

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (password.isNotEmpty && password != confirmPassword) {
      showToast(context, "Passwords do not match", isError: true);
      return;
    }

    final phone = _phoneController.text.trim();
    final designation = _designationController.text.trim();
    final city = _cityController.text.trim();
    final province = _provinceController.text.trim();
    final countryCode = _countryCodeController.text.trim();
    final countryName = _countryNameController.text.trim();
    final bio = _bioController.text.trim();
    final priceText = _priceController.text.trim();
    final currency = _currencyCodeController.text.trim();

    final validLicenses = _licenses
        .map((l) => l.toEntity())
        .whereType<UpdateDoctorLicenseEntity>()
        .toList();

    final availableDays = _schedules.map((s) => s.toEntity()).toList();

    final langs = _languagesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final entity = UpdateDoctorEntity(
      profileImageDataURI: _selectedImageDataURI,
      fullName: fullName,
      email: email,
      phone: phone.isNotEmpty ? phone : null,
      designation: designation.isNotEmpty ? designation : null,
      password: password.isNotEmpty ? password : null,
      gender: _selectedGender,
      city: city.isNotEmpty ? city : null,
      province: province.isNotEmpty ? province : null,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      countryName: countryName.isNotEmpty ? countryName : null,
      timeZone: _selectedTimeZone,
      bio: bio.isNotEmpty ? bio : null,
      knownLanguages: langs.isNotEmpty ? langs : null,
      pricePerAppointment: priceText.isNotEmpty
          ? UpdateDoctorPriceEntity(
              price: num.tryParse(priceText) ?? 0,
              currencyCode: currency.isNotEmpty ? currency : 'USD',
            )
          : null,
      licenses: validLicenses.isNotEmpty ? validLicenses : null,
      petCategories: _selectedPetCategoryIds.isNotEmpty
          ? _selectedPetCategoryIds.toList()
          : null,
      specialityObjectId: _selectedSpecialityId,
      servicesOffered: _selectedServiceIds.isNotEmpty
          ? _selectedServiceIds.toList()
          : null,
      availableDays: availableDays,
    );

    final success = await provider.updateDoctor(
      context: context,
      id: widget.doctor.id,
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
        const SizedBox(height: 6),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_note_rounded, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              AppText(
                text: "Edit Veterinarian Profile",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppText(
          text: widget.doctor.fullName.isNotEmpty
              ? "Update ${widget.doctor.fullName}"
              : "Update Veterinarian Profile",
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 4),
        AppText(
          text:
              "Update professional credentials, practice details, licenses, and consultation availability.",
          fontSize: 13,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    Widget avatarContent;

    if (_selectedImageDataURI != null && _selectedImageDataURI!.isNotEmpty) {
      try {
        final cleanBase64 = _selectedImageDataURI!.contains(',')
            ? _selectedImageDataURI!.split(',').last
            : _selectedImageDataURI!;
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
            errorBuilder: (_, _, _) => Icon(
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
    } else if (widget.doctor.user?.image != null &&
        widget.doctor.user!.image!.trim().isNotEmpty) {
      final imageUrl = MiniFunctions.getImageUrl(widget.doctor.user!.image!);
      avatarContent = ClipOval(
        child: Image.network(
          imageUrl,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(
            Icons.account_circle,
            color: textSecondaryColor,
            size: 48,
          ),
        ),
      );
    } else {
      final initial = widget.doctor.fullName.isNotEmpty
          ? widget.doctor.fullName.substring(0, 1).toUpperCase()
          : "D";
      avatarContent = CircleAvatar(
        radius: 36,
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        child: AppText(
          text: initial,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: primaryColor,
        ),
      );
    }

    return Row(
      children: [
        InkWell(
          onTap: _isPickingImage ? null : _pickImage,
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
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(
              text: _profileImageFileName != null ||
                      _selectedImageDataURI != null ||
                      (widget.doctor.user?.image != null &&
                          widget.doctor.user!.image!.isNotEmpty)
                  ? "Change Avatar"
                  : "Upload Profile Photo",
              width: 220,
              height: 42,
              fontSize: 13,
              isOutlined: true,
              textColor: primaryColor,
              isIcon: true,
              icon: Icon(
                _selectedImageDataURI != null
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                color: primaryColor,
                size: 18,
              ),
              onTap: _isPickingImage ? null : _pickImage,
            ),
            if (_profileImageFileName != null) ...[
              const SizedBox(height: 4),
              AppText(
                text: _profileImageFileName!,
                fontSize: 12,
                color: primaryColor,
              ),
            ],
          ],
        ),
      ],
    );
  }

  // SECTION 1: Personal Credentials & Identity
  Widget _buildPersonalCredentialsSection() {
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
          _buildProfileAvatar(),
          const SizedBox(height: 20),
          _buildResponsiveRow([
            CustomTextField(
              controller: _fullNameController,
              title: "Full Name *",
              hintText: "Enter full name",
            ),
            CustomTextField(
              controller: _designationController,
              title: "Designation",
              hintText: "Enter designation (e.g. Chief Veterinary Surgeon)",
            ),
          ]),
          const SizedBox(height: 14),
          _buildResponsiveRow([
            CustomTextField(
              controller: _emailController,
              title: "Email Address *",
              hintText: "Enter official email",
              textInputType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: _phoneController,
              title: "Phone Number *",
              hintText: "Enter phone number",
              textInputType: TextInputType.phone,
            ),
          ]),
          const SizedBox(height: 14),
          _buildResponsiveRow([
            CustomTextField(
              controller: _countryNameController,
              title: "Country Name *",
              hintText: "Enter country name",
            ),
            CustomTextField(
              controller: _countryCodeController,
              title: "Country Code *",
              hintText: "e.g. US",
            ),
          ]),
          const SizedBox(height: 14),
          _buildResponsiveRow([
            CustomTextField(
              controller: _cityController,
              title: "City",
              hintText: "Enter city",
            ),
            CustomTextField(
              controller: _provinceController,
              title: "State / Province",
              hintText: "Enter state or province",
            ),
          ]),
          const SizedBox(height: 14),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _genderOptions.contains(_selectedGender)
                        ? _selectedGender
                        : _genderOptions.first,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textSecondaryColor,
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedGender = val);
                      }
                    },
                    items: _genderOptions.map((g) {
                      return DropdownMenuItem<String>(
                        value: g,
                        child: AppText(
                          text: g,
                          fontSize: 13,
                          color: textPrimaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            CustomTextField(
              controller: _languagesController,
              title: "Known Languages",
              hintText: "e.g. English, Spanish (comma separated)",
            ),
          ]),
          const SizedBox(height: 14),
          _buildResponsiveRow([
            CustomTextField(
              controller: _passwordController,
              title: "New Password (Optional)",
              hintText: "Leave blank to keep current password",
              isObSecure: true,
            ),
            CustomTextField(
              controller: _confirmPasswordController,
              title: "Confirm Password",
              hintText: "Re-enter new password",
              isObSecure: true,
            ),
          ]),
        ],
      ),
    );
  }

  // SECTION 2: Professional Profile & Bio
  Widget _buildProfessionalBioSection() {
    final hasValidSpeciality = _selectedSpecialityId != null &&
        _specialities.any((s) => s.id == _selectedSpecialityId);

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
            title: "Professional Bio",
            hintText: "Enter professional bio and background...",
            maxLines: 4,
          ),
          const SizedBox(height: 14),
          _buildResponsiveRow([
            CustomTextField(
              controller: _priceController,
              title: "Fee Per Appointment (USD)",
              hintText: "e.g. 50",
              textInputType: TextInputType.number,
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
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedTimeZone = val);
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
              ),
            ),
          ]),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Primary Speciality
          Row(
            children: [
              AppText(
                text: "Primary Speciality *",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              if (_isLoadingSpecialities) ...[
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
                value: hasValidSpeciality ? _selectedSpecialityId : null,
                hint: AppText(
                  text: _isLoadingSpecialities
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
                onChanged: _onSpecialitySelected,
                items: _specialities.map((spec) {
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

          if (_selectedSpecialityId != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                AppText(
                  text: "Services Offered",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
                if (_isLoadingServices) ...[
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
            if (_isLoadingServices)
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
            else if (_services.isEmpty)
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
                children: _services.map((service) {
                  final isSelected = _selectedServiceIds.contains(service.id);
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedServiceIds.remove(service.id);
                        } else {
                          _selectedServiceIds.add(service.id);
                        }
                      });
                    },
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
                            color: isSelected ? primaryColor : textSecondaryColor,
                          ),
                          const SizedBox(width: 6),
                          AppText(
                            text: service.title,
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? primaryColor : textPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }

  // SECTION 3: Supported Animal / Pet Species
  Widget _buildPetCategoriesSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Supported Animal / Pet Species",
            "Select all pet and animal classifications treated in your veterinary practice.",
            Icons.pets_rounded,
          ),
          const SizedBox(height: 20),
          if (_isLoadingPetCategories)
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
                    text: "Loading animal classifications...",
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                ],
              ),
            )
          else if (_petCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
              children: _petCategories.map((pet) {
                final isSelected = _selectedPetCategoryIds.contains(pet.id);
                return FilterChip(
                  label: AppText(
                    text: pet.title,
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
                  "Add your certified state veterinary board credentials and license documentation.",
                  Icons.verified_user_outlined,
                ),
              ),
              CustomButton(
                text: "Add License",
                width: 130,
                height: 38,
                fontSize: 12,
                isOutlined: true,
                textColor: primaryColor,
                isIcon: true,
                icon: Icon(Icons.add_rounded, size: 16, color: primaryColor),
                onTap: () {
                  setState(() {
                    _licenses.add(_VetLicenseItem());
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _licenses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final lic = _licenses[index];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "License #${index + 1}",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        if (_licenses.length > 1)
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: errorColor,
                              size: 20,
                            ),
                            tooltip: "Remove License",
                            onPressed: () {
                              setState(() {
                                lic.dispose();
                                _licenses.removeAt(index);
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildResponsiveRow([
                      CustomTextField(
                        controller: lic.numberController,
                        title: "License Number",
                        hintText: "e.g. VET-2024-8841",
                      ),
                      CustomTextField(
                        controller: lic.stateController,
                        title: "License State",
                        hintText: "e.g. California",
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildResponsiveRow([
                      CustomTextField(
                        controller: lic.stateAbbrController,
                        title: "State Abbreviation",
                        hintText: "e.g. CA",
                      ),
                      CustomDatePickerField(
                        controller: lic.expiryDateController,
                        title: "License Expiry Date",
                        hintText: "YYYY-MM-DD",
                      ),
                    ]),
                    const SizedBox(height: 14),

                    // Certificate Upload Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            lic.licenseImageDataURI != null
                                ? Icons.check_circle_rounded
                                : (lic.existingImageUrl != null &&
                                        lic.existingImageUrl!.isNotEmpty
                                    ? Icons.file_present_rounded
                                    : Icons.upload_file_rounded),
                            color: lic.licenseImageDataURI != null
                                ? Colors.green
                                : primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: lic.fileName ??
                                      (lic.licenseImageDataURI != null
                                          ? "New Document Selected"
                                          : (lic.existingImageUrl != null &&
                                                  lic.existingImageUrl!
                                                      .isNotEmpty
                                              ? "License Document Attached"
                                              : "Upload License Document")),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                ),
                                AppText(
                                  text: "Supported: JPG, PNG, PDF (Max 5MB)",
                                  fontSize: 11,
                                  color: textSecondaryColor,
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            text: lic.licenseImageDataURI != null
                                ? "Change"
                                : (lic.existingImageUrl != null &&
                                        lic.existingImageUrl!.isNotEmpty
                                    ? "Update File"
                                    : "Upload File"),
                            height: 34,
                            width: 110,
                            fontSize: 12,
                            isOutlined: true,
                            textColor: primaryColor,
                            onTap: () => _pickLicenseImage(lic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SECTION 5: Weekly Operating Schedule
  Widget _buildWorkingHoursSection() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Weekly Schedule (Available Days)",
            "Specify open and close hours for all 7 days of the week (Sunday through Saturday).",
            Icons.access_time_rounded,
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _schedules.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final schedule = _schedules[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: schedule.isAvailable ? whiteColor : backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: schedule.isAvailable ? borderColor : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: AppText(
                        text: schedule.dayName,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: schedule.isAvailable
                            ? textPrimaryColor
                            : textSecondaryColor,
                      ),
                    ),
                    Switch(
                      value: schedule.isAvailable,
                      activeTrackColor: primaryColor.withValues(alpha: 0.5),
                      activeThumbColor: primaryColor,
                      onChanged: (val) {
                        setState(() => schedule.isAvailable = val);
                      },
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      text: schedule.isAvailable ? "Open" : "Closed",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: schedule.isAvailable
                          ? primaryColor
                          : textSecondaryColor,
                    ),
                    const Spacer(),
                    if (schedule.isAvailable) ...[
                      InkWell(
                        onTap: () => _pickScheduleTime(schedule, true),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(6),
                            color: backgroundColor,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              AppText(
                                text: schedule.openTime,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AppText(
                          text: "to",
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ),
                      InkWell(
                        onTap: () => _pickScheduleTime(schedule, false),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(6),
                            color: backgroundColor,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              AppText(
                                text: schedule.closeTime,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      AppText(
                        text: "Not Available on this day",
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ],
                  ],
                ),
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
    final isDesktop = screenWidth >= 800;
    final dialogWidth = isDesktop ? 860.0 : (screenWidth * 0.95);
    final dialogHeight = isDesktop ? 850.0 : (screenHeight * 0.92);

    return Consumer<VetsListProvider>(
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

                // Scrollable Form Sections
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalCredentialsSection(),
                        const SizedBox(height: 24),
                        _buildProfessionalBioSection(),
                        const SizedBox(height: 24),
                        _buildPetCategoriesSection(),
                        const SizedBox(height: 24),
                        _buildLicensesSection(),
                        const SizedBox(height: 24),
                        _buildWorkingHoursSection(),
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
                      text: "Save & Update Veterinarian",
                      isLoading: provider.isUpdating,
                      height: 42,
                      width: 230,
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
