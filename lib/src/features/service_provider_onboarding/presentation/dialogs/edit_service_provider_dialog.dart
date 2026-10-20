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
import '../../../../shared/taxonomy/domain/entities/service_entity.dart';
import '../../../../shared/taxonomy/domain/entities/speciality_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../../domain/entities/service_provider_onboarding_entity.dart';
import '../../domain/entities/update_service_provider_entity.dart';
import '../providers/service_providers_list_provider.dart';

class _EditDegreeItem {
  String? degreeImageDataURI;
  String? fileName;
  final String? existingImageUrl;
  final TextEditingController institutionController;
  final TextEditingController degreeTitleController;
  final TextEditingController durationController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  bool isCurrentlyStudyingHere;

  _EditDegreeItem({
    String? institution,
    String? title,
    String? duration,
    String? startDate,
    String? endDate,
  })  : isCurrentlyStudyingHere = false,
        existingImageUrl = null,
        institutionController = TextEditingController(text: institution ?? ''),
        degreeTitleController = TextEditingController(text: title ?? ''),
        durationController = TextEditingController(text: duration ?? ''),
        startDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(startDate),
        ),
        endDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(endDate),
        );

  void dispose() {
    institutionController.dispose();
    degreeTitleController.dispose();
    durationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  UpdateServiceProviderDegreeEntity? toEntity() {
    final inst = institutionController.text.trim();
    final title = degreeTitleController.text.trim();
    final dur = durationController.text.trim();
    final start = startDateController.text.trim();
    final end = endDateController.text.trim();

    if (inst.isEmpty &&
        title.isEmpty &&
        dur.isEmpty &&
        start.isEmpty &&
        end.isEmpty &&
        degreeImageDataURI == null) {
      return null;
    }

    return UpdateServiceProviderDegreeEntity(
      degreeImageDataURI: degreeImageDataURI,
      institutionTitle: inst.isNotEmpty ? inst : null,
      degreeTitle: title.isNotEmpty ? title : null,
      duration: dur.isNotEmpty ? dur : null,
      startDate: start.isNotEmpty ? start : null,
      endDate: isCurrentlyStudyingHere ? null : (end.isNotEmpty ? end : null),
      currentlyStudyingHere: isCurrentlyStudyingHere ? 'yes' : 'no',
    );
  }
}

class _EditLicenseItem {
  String? licenseImageDataURI;
  String? fileName;
  final String? existingImageUrl;
  final TextEditingController stateController;
  final TextEditingController stateAbbrController;
  final TextEditingController licenseNumberController;
  final TextEditingController expiryDateController;

  _EditLicenseItem({
    String? state,
    String? stateAbbreviation,
    String? licenseNumber,
    String? expiryDate,
    this.existingImageUrl,
  })  : stateController = TextEditingController(text: state ?? ''),
        stateAbbrController =
            TextEditingController(text: stateAbbreviation ?? ''),
        licenseNumberController =
            TextEditingController(text: licenseNumber ?? ''),
        expiryDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(expiryDate),
        );

  void dispose() {
    stateController.dispose();
    stateAbbrController.dispose();
    licenseNumberController.dispose();
    expiryDateController.dispose();
  }

  UpdateServiceProviderLicenseEntity? toEntity() {
    final state = stateController.text.trim();
    final stateAbbr = stateAbbrController.text.trim();
    final number = licenseNumberController.text.trim();
    final expiry = expiryDateController.text.trim();
    if (state.isEmpty &&
        stateAbbr.isEmpty &&
        number.isEmpty &&
        expiry.isEmpty &&
        licenseImageDataURI == null) {
      return null;
    }
    return UpdateServiceProviderLicenseEntity(
      state: state.isNotEmpty ? state : null,
      stateAbbreviation: stateAbbr.isNotEmpty ? stateAbbr : null,
      licenseNumber: number.isNotEmpty ? number : null,
      licenseExpiryDate: expiry.isNotEmpty ? expiry : null,
      licenseImageDataURI: licenseImageDataURI,
    );
  }
}

class _EditWorkExperienceItem {
  String? jobImageDataURI;
  String? fileName;
  final String? existingImageUrl;
  final TextEditingController jobTitleController;
  final TextEditingController organizationTitleController;
  final TextEditingController yearsOfExpController;
  final TextEditingController organizationAddressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  bool isCurrentlyWorkingHere;

  _EditWorkExperienceItem({
    String? jobTitle,
    String? orgTitle,
    String? yearsOfExp,
    String? orgAddress,
    String? startDate,
    String? endDate,
  })  : isCurrentlyWorkingHere = false,
        existingImageUrl = null,
        jobTitleController = TextEditingController(text: jobTitle ?? ''),
        organizationTitleController =
            TextEditingController(text: orgTitle ?? ''),
        yearsOfExpController = TextEditingController(text: yearsOfExp ?? ''),
        organizationAddressController =
            TextEditingController(text: orgAddress ?? ''),
        startDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(startDate),
        ),
        endDateController = TextEditingController(
          text: MiniFunctions().formatDateToYMD(endDate),
        );

  void dispose() {
    jobTitleController.dispose();
    organizationTitleController.dispose();
    yearsOfExpController.dispose();
    organizationAddressController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  UpdateServiceProviderWorkExperienceEntity? toEntity() {
    final title = jobTitleController.text.trim();
    final org = organizationTitleController.text.trim();
    final years = yearsOfExpController.text.trim();
    final addr = organizationAddressController.text.trim();
    final start = startDateController.text.trim();
    final end = endDateController.text.trim();

    if (title.isEmpty &&
        org.isEmpty &&
        years.isEmpty &&
        addr.isEmpty &&
        start.isEmpty &&
        end.isEmpty &&
        jobImageDataURI == null) {
      return null;
    }

    return UpdateServiceProviderWorkExperienceEntity(
      jobImageDataURI: jobImageDataURI,
      jobTitle: title.isNotEmpty ? title : null,
      jobOrganizationTitle: org.isNotEmpty ? org : null,
      jobYearsOfExperience: years.isNotEmpty ? years : null,
      jobOrganizationAddress: addr.isNotEmpty ? addr : null,
      jobStartDate: start.isNotEmpty ? start : null,
      jobEndDate: isCurrentlyWorkingHere ? null : (end.isNotEmpty ? end : null),
      jobCurrentlyWorkingHere: isCurrentlyWorkingHere ? 'yes' : 'no',
    );
  }
}

class _EditDayScheduleItem {
  final int dayIndex;
  final String dayName;
  bool isAvailable;
  String openTime;
  String closeTime;

  _EditDayScheduleItem({
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

  UpdateServiceProviderAvailableDayEntity toEntity() {
    return UpdateServiceProviderAvailableDayEntity(
      isAvailable: isAvailable,
      openTime: isAvailable ? openTime : null,
      closeTime: isAvailable ? closeTime : null,
      open: isAvailable ? openMinutes : null,
      close: isAvailable ? closeMinutes : null,
    );
  }
}

class EditServiceProviderDialog extends StatefulWidget {
  final ServiceProviderItemEntity serviceProvider;

  const EditServiceProviderDialog({
    super.key,
    required this.serviceProvider,
  });

  static Future<bool?> show(
    BuildContext context, {
    required ServiceProviderItemEntity serviceProvider,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          EditServiceProviderDialog(serviceProvider: serviceProvider),
    );
  }

  @override
  State<EditServiceProviderDialog> createState() =>
      _EditServiceProviderDialogState();
}

class _EditServiceProviderDialogState extends State<EditServiceProviderDialog>
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

  static const List<String> _allLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Arabic',
    'Mandarin',
    'Urdu',
    'Portuguese',
    'Russian',
  ];

  static const List<String> _availableLocations = ['Home', 'Office'];

  static const List<String> _daysNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Personal Information Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _designationController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _bioController;

  // Business & Location Controllers
  late final TextEditingController _businessNameController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessPhoneController;
  late final TextEditingController _businessZipController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  // Services & Pricing Controllers
  late final TextEditingController _startingPriceController;
  late final TextEditingController _priceController;

  String _selectedGender = 'Male';
  String _selectedTimeZone = 'America/New_York';
  final List<String> _selectedLanguages = [];

  String? _profileImageDataURI;
  String? _profileImageFileName;

  String? _businessImageDataURI;
  String? _businessImageFileName;

  // Taxonomy states
  List<PetCategoryEntity> _petCategories = [];
  bool _isPetCategoriesLoading = false;
  final List<String> _selectedPetCategories = [];

  List<SpecialityEntity> _specialities = [];
  bool _isSpecialitiesLoading = false;
  String? _selectedSpecialityId;

  List<ServiceEntity> _services = [];
  bool _isServicesLoading = false;
  final List<String> _selectedServices = [];

  final List<String> _selectedLocations = ['Home', 'Office'];

  // Repeatable sections
  final List<_EditDegreeItem> _degrees = [];
  final List<_EditLicenseItem> _licenses = [];
  final List<_EditWorkExperienceItem> _workExperiences = [];
  final List<_EditDayScheduleItem> _availableDays = [];

  @override
  void initState() {
    super.initState();
    final p = widget.serviceProvider;

    _nameController = TextEditingController(text: p.fullName);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phone ?? '');
    _designationController = TextEditingController(text: p.designation ?? '');
    _countryCodeController = TextEditingController(text: p.countryCode ?? '');
    _countryNameController = TextEditingController(text: p.countryName ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _bioController = TextEditingController(text: p.bio ?? '');

    _businessNameController = TextEditingController(text: p.businessName ?? '');
    _businessEmailController =
        TextEditingController(text: p.businessEmail ?? '');
    _businessPhoneController =
        TextEditingController(text: p.businessPhone ?? '');
    _businessZipController =
        TextEditingController(text: p.businessZIPCode?.toString() ?? '');
    _latitudeController = TextEditingController(text: p.latitude ?? '');
    _longitudeController = TextEditingController(text: p.longitude ?? '');

    _startingPriceController = TextEditingController(
      text: p.startingPricePerAppointment?.price != null
          ? p.startingPricePerAppointment!.price.toString()
          : '',
    );
    _priceController = TextEditingController(
      text: p.pricePerAppointment?.price != null
          ? p.pricePerAppointment!.price.toString()
          : '',
    );

    if (p.gender != null && _genderOptions.contains(p.gender)) {
      _selectedGender = p.gender!;
    }
    if (p.timeZone != null && _timeZones.contains(p.timeZone)) {
      _selectedTimeZone = p.timeZone!;
    }

    if (p.knownLanguages.isNotEmpty) {
      _selectedLanguages.addAll(p.knownLanguages);
    } else {
      _selectedLanguages.add('English');
    }

    if (p.serviceLocations.isNotEmpty) {
      _selectedLocations.clear();
      _selectedLocations.addAll(p.serviceLocations);
    }

    // Populate Licenses
    if (p.licenses.isNotEmpty) {
      for (final lic in p.licenses) {
        _licenses.add(
          _EditLicenseItem(
            state: lic.state,
            stateAbbreviation: lic.stateAbbreviation,
            licenseNumber: lic.number,
            expiryDate: lic.expiryDate,
            existingImageUrl: lic.image,
          ),
        );
      }
    } else {
      _licenses.add(_EditLicenseItem());
    }

    // Populate Degrees (default at least 1)
    if (_degrees.isEmpty) {
      _degrees.add(_EditDegreeItem());
    }

    // Populate Work Experiences (default at least 1)
    if (_workExperiences.isEmpty) {
      _workExperiences.add(_EditWorkExperienceItem());
    }

    // Populate 7-day schedule
    _initSchedule(p.availableDays);

    // Fetch taxonomies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPetCategories();
      _fetchSpecialities();
    });
  }

  void _initSchedule(List<AvailableDayEntity> existingDays) {
    _availableDays.clear();
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
        _availableDays.add(
          _EditDayScheduleItem(
            dayIndex: i,
            dayName: name,
            isAvailable: matched.isAvailable,
            openTime: matched.openTime ?? '09:30',
            closeTime: matched.closeTime ?? '17:30',
          ),
        );
      } else {
        _availableDays.add(
          _EditDayScheduleItem(
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
    setState(() => _isPetCategoriesLoading = true);
    try {
      final cats = await sl<TaxonomyUseCases>().getPetCategories();
      if (mounted) {
        setState(() {
          _petCategories = cats;
          for (final existing in widget.serviceProvider.petCategories) {
            final existingId = existing.id ?? existing.petCategory;
            for (final cat in cats) {
              if (cat.id == existingId ||
                  cat.title.toLowerCase() == (existing.title ?? '').toLowerCase()) {
                if (!_selectedPetCategories.contains(cat.id)) {
                  _selectedPetCategories.add(cat.id);
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
  }

  Future<void> _fetchSpecialities() async {
    setState(() => _isSpecialitiesLoading = true);
    try {
      final specs = await sl<TaxonomyUseCases>().getSpecialities();
      if (mounted) {
        setState(() {
          _specialities = specs;
          if (specs.isNotEmpty) {
            _selectedSpecialityId = specs.first.id;
          }
        });

        if (_selectedSpecialityId != null) {
          await _fetchServices(_selectedSpecialityId!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching specialities: $e");
    } finally {
      if (mounted) setState(() => _isSpecialitiesLoading = false);
    }
  }

  Future<void> _fetchServices(String specialityId) async {
    setState(() => _isServicesLoading = true);
    try {
      final srvs = await sl<TaxonomyUseCases>().getServices(
        specialityObjectId: specialityId,
      );
      if (mounted) {
        setState(() {
          _services = srvs;
          for (final existing in widget.serviceProvider.servicesOffered) {
            final existingId = existing.id ?? existing.serviceProviderService;
            for (final s in srvs) {
              if (s.id == existingId ||
                  s.title.toLowerCase() == (existing.title ?? '').toLowerCase()) {
                if (!_selectedServices.contains(s.id)) {
                  _selectedServices.add(s.id);
                }
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching services: $e");
    } finally {
      if (mounted) setState(() => _isServicesLoading = false);
    }
  }

  void _onSpecialitySelected(String? newId) {
    if (newId == null || newId == _selectedSpecialityId) return;
    setState(() {
      _selectedSpecialityId = newId;
      _services.clear();
    });
    _fetchServices(newId);
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

  Future<void> _pickBusinessImage() async {
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
            _businessImageDataURI = 'data:$mime;base64,$base64String';
            _businessImageFileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) showToast(context, "Failed to pick image: $e", isError: true);
    }
  }

  Future<void> _pickDegreeImage(_EditDegreeItem item) async {
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
            item.degreeImageDataURI = 'data:$mime;base64,$base64String';
            item.fileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) showToast(context, "Failed to pick file: $e", isError: true);
    }
  }

  Future<void> _pickLicenseImage(_EditLicenseItem item) async {
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

  Future<void> _pickJobImage(_EditWorkExperienceItem item) async {
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
            item.jobImageDataURI = 'data:$mime;base64,$base64String';
            item.fileName = platformFile.name;
          });
        }
      }
    } catch (e) {
      if (mounted) showToast(context, "Failed to pick file: $e", isError: true);
    }
  }

  Future<void> _selectDayTime(
    _EditDayScheduleItem day,
    bool isOpenTime,
  ) async {
    final currentTimeStr = isOpenTime ? day.openTime : day.closeTime;
    final parts = currentTimeStr.split(':');
    final initialHour = parts.length == 2 ? int.tryParse(parts[0]) ?? 9 : 9;
    final initialMinute =
        parts.length == 2 ? int.tryParse(parts[1]) ?? 30 : 30;

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();

    _businessNameController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _businessZipController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    _startingPriceController.dispose();
    _priceController.dispose();

    for (final d in _degrees) {
      d.dispose();
    }
    for (final lic in _licenses) {
      lic.dispose();
    }
    for (final w in _workExperiences) {
      w.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit(ServiceProvidersListProvider provider) async {
    final fullName = _nameController.text.trim();
    if (fullName.isEmpty) {
      showToast(context, "Full Name is required", isError: true);
      return;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showToast(context, "Email Address is required", isError: true);
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

    final businessName = _businessNameController.text.trim();
    if (businessName.isEmpty) {
      showToast(context, "Business Name is required", isError: true);
      return;
    }

    final businessEmail = _businessEmailController.text.trim();
    if (businessEmail.isEmpty) {
      showToast(context, "Business Email is required", isError: true);
      return;
    }

    final businessPhone = _businessPhoneController.text.trim();
    if (businessPhone.isEmpty) {
      showToast(context, "Business Phone is required", isError: true);
      return;
    }

    final businessZip = _businessZipController.text.trim();
    if (businessZip.isEmpty) {
      showToast(context, "Business ZIP Code is required", isError: true);
      return;
    }

    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      showToast(context, "Standard Appointment Fee is required", isError: true);
      return;
    }

    final startingPriceText = _startingPriceController.text.trim();
    UpdateServiceProviderPriceEntity? startingPrice;
    if (startingPriceText.isNotEmpty) {
      startingPrice = UpdateServiceProviderPriceEntity(
        price: num.tryParse(startingPriceText) ?? 0,
        currencyCode: 'USD',
      );
    }

    final standardPrice = UpdateServiceProviderPriceEntity(
      price: num.tryParse(priceText) ?? 0,
      currencyCode: 'USD',
    );

    final validDegrees = _degrees
        .map((d) => d.toEntity())
        .whereType<UpdateServiceProviderDegreeEntity>()
        .toList();

    final validLicenses = _licenses
        .map((l) => l.toEntity())
        .whereType<UpdateServiceProviderLicenseEntity>()
        .toList();

    final validWorkExperiences = _workExperiences
        .map((w) => w.toEntity())
        .whereType<UpdateServiceProviderWorkExperienceEntity>()
        .toList();

    final availableDays = _availableDays.map((d) => d.toEntity()).toList();

    final entity = UpdateServiceProviderEntity(
      profileImageDataURI: _profileImageDataURI,
      businessImageDataURI: _businessImageDataURI,
      fullName: fullName,
      email: email,
      phone: phone,
      countryCode: _countryCodeController.text.trim().isNotEmpty
          ? _countryCodeController.text.trim()
          : null,
      countryName: _countryNameController.text.trim().isNotEmpty
          ? _countryNameController.text.trim()
          : null,
      designation: _designationController.text.trim().isNotEmpty
          ? _designationController.text.trim()
          : null,
      password: password.isNotEmpty ? password : null,
      gender: _selectedGender,
      timeZone: _selectedTimeZone,
      bio: _bioController.text.trim().isNotEmpty
          ? _bioController.text.trim()
          : null,
      knownLanguages: _selectedLanguages.isNotEmpty ? _selectedLanguages : null,
      businessName: businessName,
      businessEmail: businessEmail,
      businessPhone: businessPhone,
      businessZIPCode: businessZip,
      latitude: _latitudeController.text.trim().isNotEmpty
          ? _latitudeController.text.trim()
          : null,
      longitude: _longitudeController.text.trim().isNotEmpty
          ? _longitudeController.text.trim()
          : null,
      address: widget.serviceProvider.address,
      city: widget.serviceProvider.city,
      province: widget.serviceProvider.province,
      startingPricePerAppointment: startingPrice,
      pricePerAppointment: standardPrice,
      petCategories:
          _selectedPetCategories.isNotEmpty ? _selectedPetCategories : null,
      specialityObjectId: _selectedSpecialityId,
      servicesOffered:
          _selectedServices.isNotEmpty ? _selectedServices : null,
      serviceLocations:
          _selectedLocations.isNotEmpty ? _selectedLocations : null,
      availableDays: availableDays,
      degrees: validDegrees.isNotEmpty ? validDegrees : null,
      licenses: validLicenses.isNotEmpty ? validLicenses : null,
      workExperiences:
          validWorkExperiences.isNotEmpty ? validWorkExperiences : null,
    );

    final success = await provider.updateServiceProvider(
      context: context,
      id: widget.serviceProvider.id,
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
          text: "Edit Service Provider Details",
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 6),
        AppText(
          text:
              "Update profile verification, business registration, service offerings, and working schedules in one master entry.",
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  // SECTION 1: Personal Credentials
  Widget _buildPersonalCredentialsSection() {
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

          // Profile Photo Upload Banner (Exact Onboarding UI)
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
                  existingNetworkUrl: widget.serviceProvider.user?.image,
                  width: 70,
                  height: 70,
                  radius: 35,
                  fallbackIcon: Icons.account_circle,
                ),
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
                  onTap: _pickProfileImage,
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
              ),
            ),
            _buildField(
              label: "Email Address *",
              child: CustomTextField(
                controller: _emailController,
                hintText: "Enter official email address",
                textInputType: TextInputType.emailAddress,
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
              ),
            ),
            _buildField(
              label: "Designation / Title",
              child: CustomTextField(
                controller: _designationController,
                hintText: "Enter professional designation",
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
          const SizedBox(height: 16),

          _buildResponsiveRow([
            _buildField(
              label: "Password",
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
                hintText: "Confirm password",
                isObSecure: true,
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
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
                        setState(() => _selectedGender = val);
                      }
                    },
                  ),
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
          ]),
          const SizedBox(height: 16),

          _buildField(
            label: "Known Languages",
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allLanguages.map((lang) {
                final isSelected = _selectedLanguages.contains(lang);
                return FilterChip(
                  label: AppText(
                    text: lang,
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
                        _selectedLanguages.add(lang);
                      } else {
                        _selectedLanguages.remove(lang);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          _buildField(
            label: "Professional Bio / Summary *",
            child: CustomTextField(
              controller: _bioController,
              hintText: "Enter professional bio and summary...",
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 2: Business & Location Details
  Widget _buildBusinessDetailsSection() {
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

          // Storefront Photo Upload Banner (Exact Onboarding UI)
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
                  dataUri: _businessImageDataURI,
                  existingNetworkUrl: widget.serviceProvider.businessImage,
                  width: 80,
                  height: 60,
                  radius: 8,
                  fallbackIcon: Icons.storefront_outlined,
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
                      AppText(
                        text: _businessImageFileName ??
                            "JPEG or PNG up to 5MB. Click button to upload.",
                        fontSize: 12,
                        color: textSecondaryColor,
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
                  onTap: _pickBusinessImage,
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
              ),
            ),
            _buildField(
              label: "Business Email *",
              child: CustomTextField(
                controller: _businessEmailController,
                hintText: "Enter business email address",
                textInputType: TextInputType.emailAddress,
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
              ),
            ),
            _buildField(
              label: "Business ZIP Code *",
              child: CustomTextField(
                controller: _businessZipController,
                hintText: "Enter postal ZIP code",
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
              ),
            ),
            _buildField(
              label: "Longitude",
              child: CustomTextField(
                controller: _longitudeController,
                hintText: "Enter longitude coordinate",
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // SECTION 3: Services, Taxonomies & Pricing
  Widget _buildServicesAndPricingSection() {
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
            child: _isPetCategoriesLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _petCategories.isEmpty
                    ? AppText(
                        text: "No pet categories found.",
                        color: textSecondaryColor,
                        fontSize: 13,
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _petCategories.map((cat) {
                          final isSelected =
                              _selectedPetCategories.contains(cat.id);
                          return FilterChip(
                            label: AppText(
                              text: cat.title,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color:
                                  isSelected ? primaryColor : textPrimaryColor,
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
                                  _selectedPetCategories.add(cat.id);
                                } else {
                                  _selectedPetCategories.remove(cat.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          Row(
            children: [
              AppText(
                text: "Select Service Speciality Filter *",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              if (_isSpecialitiesLoading) ...[
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
                value: _specialities.any((s) => s.id == _selectedSpecialityId)
                    ? _selectedSpecialityId
                    : null,
                hint: AppText(
                  text: _isSpecialitiesLoading
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
                onChanged: _onSpecialitySelected,
                items: _specialities.map((spec) {
                  return DropdownMenuItem<String>(
                    value: spec.id,
                    child: AppText(text: spec.title, fontSize: 13),
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
                  text: "Services Offered *",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
                if (_isServicesLoading) ...[
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
              text: "Select the specialized care and grooming services you offer.",
              fontSize: 12,
              color: textSecondaryColor,
            ),
            const SizedBox(height: 12),
            if (_isServicesLoading)
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
                  text: "No services found for this speciality.",
                  fontSize: 13,
                  color: textSecondaryColor,
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _services.map((service) {
                  final isSelected = _selectedServices.contains(service.id);
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedServices.remove(service.id);
                        } else {
                          _selectedServices.add(service.id);
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

          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          _buildField(
            label: "Service Delivery Locations *",
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: _availableLocations.map((loc) {
                final isSelected = _selectedLocations.contains(loc);
                return FilterChip(
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
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedLocations.add(loc);
                      } else {
                        _selectedLocations.remove(loc);
                      }
                    });
                  },
                );
              }).toList(),
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
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // SECTION 4: Working Hours & Availability (7 Days)
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
          const SizedBox(height: 16),
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
                      color:
                          day.isAvailable ? textPrimaryColor : textSecondaryColor,
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
                    color:
                        day.isAvailable ? primaryColor : textSecondaryColor,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

  // SECTION 5: Educational Degrees & Certifications
  Widget _buildDegreesSection() {
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
                onTap: () {
                  setState(() => _degrees.add(_EditDegreeItem()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _degrees.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final degree = _degrees[index];
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
                          existingNetworkUrl: degree.existingImageUrl,
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
                                text: degree.fileName ??
                                    ((degree.existingImageUrl != null &&
                                            degree.existingImageUrl!.isNotEmpty)
                                        ? "Current Degree Document Attached"
                                        : "Upload Degree / Certificate Photo"),
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
                          onTap: () => _pickDegreeImage(degree),
                        ),
                        if (_degrees.length > 1) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                final removed = _degrees.removeAt(index);
                                removed.dispose();
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildResponsiveRow([
                      _buildField(
                        label: "Degree / Certificate Title",
                        child: CustomTextField(
                          controller: degree.degreeTitleController,
                          hintText: "Enter certificate or degree title",
                        ),
                      ),
                      _buildField(
                        label: "Institution / Academy",
                        child: CustomTextField(
                          controller: degree.institutionController,
                          hintText: "Enter issuing institution name",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildResponsiveRow([
                      _buildField(
                        label: "Duration",
                        child: CustomTextField(
                          controller: degree.durationController,
                          hintText: "Enter program duration",
                        ),
                      ),
                      _buildField(
                        label: "Start Date",
                        child: CustomDatePickerField(
                          controller: degree.startDateController,
                          hintText: "YYYY-MM-DD",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: degree.isCurrentlyStudyingHere,
                              activeColor: primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  degree.isCurrentlyStudyingHere = val ?? false;
                                  if (degree.isCurrentlyStudyingHere) {
                                    degree.endDateController.clear();
                                  }
                                });
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
                        if (!degree.isCurrentlyStudyingHere) ...[
                          const SizedBox(height: 8),
                          _buildField(
                            label: "End Date",
                            child: CustomDatePickerField(
                              controller: degree.endDateController,
                              hintText: "YYYY-MM-DD",
                            ),
                          ),
                        ],
                      ],
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

  // SECTION 6: Professional Licenses & Permits
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
                onTap: () {
                  setState(() => _licenses.add(_EditLicenseItem()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _licenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final license = _licenses[index];
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
                          existingNetworkUrl: license.existingImageUrl,
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
                                text: license.fileName ??
                                    ((license.existingImageUrl != null &&
                                            license.existingImageUrl!.isNotEmpty)
                                        ? "Current License Document Attached"
                                        : "Upload License Document Photo"),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: "Official certification / permit proof",
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
                          onTap: () => _pickLicenseImage(license),
                        ),
                        if (_licenses.length > 1) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                final removed = _licenses.removeAt(index);
                                removed.dispose();
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildResponsiveRow([
                      _buildField(
                        label: "State / Region",
                        child: CustomTextField(
                          controller: license.stateController,
                          hintText: "Enter state or province",
                        ),
                      ),
                      _buildField(
                        label: "State Abbreviation",
                        child: CustomTextField(
                          controller: license.stateAbbrController,
                          hintText: "Enter state abbreviation",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildResponsiveRow([
                      _buildField(
                        label: "License / Registration Number",
                        child: CustomTextField(
                          controller: license.licenseNumberController,
                          hintText: "Enter license number",
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
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SECTION 7: Work & Employment Experience
  Widget _buildWorkExperiencesSection() {
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
                onTap: () {
                  setState(() => _workExperiences.add(_EditWorkExperienceItem()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _workExperiences.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final job = _workExperiences[index];
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
                          existingNetworkUrl: job.existingImageUrl,
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
                                text: job.fileName ??
                                    ((job.existingImageUrl != null &&
                                            job.existingImageUrl!.isNotEmpty)
                                        ? "Current Experience Letter Attached"
                                        : "Upload Experience Letter Photo"),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: "Certificate of employment or experience letter",
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
                          onTap: () => _pickJobImage(job),
                        ),
                        if (_workExperiences.length > 1) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                final removed = _workExperiences.removeAt(index);
                                removed.dispose();
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildResponsiveRow([
                      _buildField(
                        label: "Job Title",
                        child: CustomTextField(
                          controller: job.jobTitleController,
                          hintText: "Enter job or role title",
                        ),
                      ),
                      _buildField(
                        label: "Organization / Company Name",
                        child: CustomTextField(
                          controller: job.organizationTitleController,
                          hintText: "Enter organization name",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildResponsiveRow([
                      _buildField(
                        label: "Years of Experience",
                        child: CustomTextField(
                          controller: job.yearsOfExpController,
                          hintText: "Enter years of experience",
                          textInputType: TextInputType.number,
                        ),
                      ),
                      _buildField(
                        label: "Organization Address",
                        child: CustomTextField(
                          controller: job.organizationAddressController,
                          hintText: "Enter organization physical address",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildField(
                      label: "Start Date",
                      child: CustomDatePickerField(
                        controller: job.startDateController,
                        hintText: "YYYY-MM-DD",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: job.isCurrentlyWorkingHere,
                              activeColor: primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  job.isCurrentlyWorkingHere = val ?? false;
                                  if (job.isCurrentlyWorkingHere) {
                                    job.endDateController.clear();
                                  }
                                });
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
                        if (!job.isCurrentlyWorkingHere) ...[
                          const SizedBox(height: 8),
                          _buildField(
                            label: "End Date",
                            child: CustomDatePickerField(
                              controller: job.endDateController,
                              hintText: "YYYY-MM-DD",
                            ),
                          ),
                        ],
                      ],
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth >= 1100 ? 980.0 : (screenWidth * 0.94);
    final dialogHeight = screenHeight * 0.92;

    return Consumer<ServiceProvidersListProvider>(
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

                // Scrollable Form Sections (Identical 7 Sections to Onboarding)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalCredentialsSection(),
                        const SizedBox(height: 24),
                        _buildBusinessDetailsSection(),
                        const SizedBox(height: 24),
                        _buildServicesAndPricingSection(),
                        const SizedBox(height: 24),
                        _buildWorkingHoursSection(),
                        const SizedBox(height: 24),
                        _buildDegreesSection(),
                        const SizedBox(height: 24),
                        _buildLicensesSection(),
                        const SizedBox(height: 24),
                        _buildWorkExperiencesSection(),
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
                      text: "Save & Update Provider",
                      isLoading: provider.isUpdating,
                      height: 42,
                      width: 220,
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
