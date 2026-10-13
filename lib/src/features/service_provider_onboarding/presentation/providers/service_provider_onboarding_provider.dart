import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/taxonomy/domain/entities/pet_category_entity.dart';
import '../../../../shared/taxonomy/domain/entities/service_entity.dart';
import '../../../../shared/taxonomy/domain/entities/speciality_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/service_provider_onboarding_entity.dart';
import '../../domain/usecases/service_provider_onboarding_usecases.dart';

class DayScheduleItem {
  final int dayIndex;
  final String dayName;
  bool isAvailable;
  String openTime;
  String closeTime;

  DayScheduleItem({
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

  AvailableDayEntity toEntity() {
    return AvailableDayEntity(
      dayIndex: dayIndex,
      isAvailable: isAvailable,
      openTime: isAvailable ? openTime : null,
      closeTime: isAvailable ? closeTime : null,
      open: isAvailable ? openMinutes : null,
      close: isAvailable ? closeMinutes : null,
    );
  }
}

class DegreeFormItem {
  String degreeImageDataURI = '';
  String institutionTitle = '';
  String degreeTitle = '';
  String duration = '';
  String startDate = '';
  String? endDate = '';
  final ValueNotifier<bool> isCurrentlyStudyingNotifier = ValueNotifier<bool>(
    false,
  );
  String? fileName;

  bool get isCurrentlyStudyingHere => isCurrentlyStudyingNotifier.value;
  set isCurrentlyStudyingHere(bool val) {
    isCurrentlyStudyingNotifier.value = val;
    if (val) {
      endDate = null;
    }
  }

  DegreeEntity toEntity() {
    return DegreeEntity(
      degreeImageDataURI: degreeImageDataURI,
      institutionTitle: institutionTitle,
      degreeTitle: degreeTitle,
      duration: duration,
      startDate: startDate,
      endDate: isCurrentlyStudyingHere ? null : endDate,
      currentlyStudyingHere: isCurrentlyStudyingHere ? 'yes' : 'no',
    );
  }
}

class LicenseFormItem {
  String licenseImageDataURI = '';
  String state = '';
  String stateAbbreviation = '';
  String licenseNumber = '';
  String licenseExpiryDate = '';
  String? fileName;

  LicenseEntity toEntity() {
    return LicenseEntity(
      licenseImageDataURI: licenseImageDataURI,
      state: state,
      stateAbbreviation: stateAbbreviation,
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
    );
  }
}

class WorkExperienceFormItem {
  String jobImageDataURI = '';
  String jobTitle = '';
  String jobOrganizationTitle = '';
  String jobYearsOfExperience = '';
  String jobOrganizationAddress = '';
  String jobStartDate = '';
  String? jobEndDate;
  final ValueNotifier<bool> isCurrentlyWorkingNotifier = ValueNotifier<bool>(
    false,
  );
  String? fileName;

  bool get isCurrentlyWorkingHere => isCurrentlyWorkingNotifier.value;
  set isCurrentlyWorkingHere(bool val) {
    isCurrentlyWorkingNotifier.value = val;
    if (val) {
      jobEndDate = null;
    }
  }

  WorkExperienceEntity toEntity() {
    return WorkExperienceEntity(
      jobImageDataURI: jobImageDataURI,
      jobTitle: jobTitle,
      jobOrganizationTitle: jobOrganizationTitle,
      jobYearsOfExperience: jobYearsOfExperience,
      jobOrganizationAddress: jobOrganizationAddress,
      jobStartDate: jobStartDate,
      jobEndDate: isCurrentlyWorkingHere ? null : jobEndDate,
      jobCurrentlyWorkingHere: isCurrentlyWorkingHere ? 'yes' : 'no',
    );
  }
}

class ServiceProviderOnboardingProvider extends ChangeNotifier {
  final ServiceProviderOnboardingUseCases useCases;
  final TaxonomyUseCases taxonomyUseCases;

  ServiceProviderOnboardingProvider({
    required this.useCases,
    required this.taxonomyUseCases,
  }) {
    _initDefaultAvailableDays();
    _initDefaultItems();
    fetchPetCategories();
    fetchSpecialities();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String fullName = '';
  String email = '';
  String phone = '';
  String countryCode = '';
  String countryName = '';
  String password = '';
  String confirmPassword = '';
  String designation = '';
  String bio = '';
  String timeZone = 'America/New_York';
  String gender = 'Male';
  List<String> knownLanguages = ['English'];
  String? profileImageDataURI;
  String? profileImageFileName;

  String businessName = '';
  String businessEmail = '';
  String businessPhone = '';
  String businessZIPCode = '';
  String latitude = '';
  String longitude = '';
  String? businessImageDataURI;
  String? businessImageFileName;

  num pricePerAppointment = 0;
  num startingPricePerAppointment = 0;
  String currencyCode = 'USD';

  List<PetCategoryEntity> petCategories = [];
  bool isPetCategoriesLoading = false;
  List<String> selectedPetCategories = [];

  List<SpecialityEntity> specialities = [];
  bool isSpecialitiesLoading = false;
  String specialityObjectId = '';
  String? get selectedSpecialityId =>
      specialityObjectId.isNotEmpty ? specialityObjectId : null;

  List<ServiceEntity> services = [];
  bool isServicesLoading = false;
  List<String> selectedServices = [];

  List<String> selectedServiceLocations = ['Home', 'Office'];
  final List<String> availableLocations = const ['Home', 'Office'];

  final List<String> allLanguages = const [
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

  final List<DegreeFormItem> degrees = [];
  final List<LicenseFormItem> licenses = [];
  final List<WorkExperienceFormItem> workExperiences = [];

  final List<DayScheduleItem> availableDays = [];

  void _initDefaultAvailableDays() {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    availableDays.clear();
    for (int i = 0; i < 7; i++) {
      availableDays.add(
        DayScheduleItem(dayIndex: i, dayName: days[i], isAvailable: i != 0),
      );
    }
  }

  void _initDefaultItems() {
    if (degrees.isEmpty) degrees.add(DegreeFormItem());
    if (licenses.isEmpty) licenses.add(LicenseFormItem());
    if (workExperiences.isEmpty) workExperiences.add(WorkExperienceFormItem());
  }

  void addDegree() {
    degrees.add(DegreeFormItem());
    notifyListeners();
  }

  void removeDegree(int index) {
    if (degrees.length > 1) {
      degrees.removeAt(index);
      notifyListeners();
    }
  }

  void toggleDegreeCurrentlyStudying(int index, bool val) {
    if (index >= 0 && index < degrees.length) {
      degrees[index].isCurrentlyStudyingHere = val;
    }
  }

  void addLicense() {
    licenses.add(LicenseFormItem());
    notifyListeners();
  }

  void removeLicense(int index) {
    if (licenses.length > 1) {
      licenses.removeAt(index);
      notifyListeners();
    }
  }

  void addWorkExperience() {
    workExperiences.add(WorkExperienceFormItem());
    notifyListeners();
  }

  void removeWorkExperience(int index) {
    if (workExperiences.length > 1) {
      workExperiences.removeAt(index);
      notifyListeners();
    }
  }

  void toggleJobCurrentlyWorking(int index, bool val) {
    if (index >= 0 && index < workExperiences.length) {
      workExperiences[index].isCurrentlyWorkingHere = val;
    }
  }

  void setTimeZone(String tz) {
    timeZone = tz;
    notifyListeners();
  }

  void setGender(String g) {
    gender = g;
    notifyListeners();
  }

  void toggleLanguage(String lang) {
    if (knownLanguages.contains(lang)) {
      if (knownLanguages.length > 1) {
        knownLanguages.remove(lang);
      }
    } else {
      knownLanguages.add(lang);
    }
    notifyListeners();
  }

  void toggleServiceLocation(String loc) {
    if (selectedServiceLocations.contains(loc)) {
      if (selectedServiceLocations.length > 1) {
        selectedServiceLocations.remove(loc);
      }
    } else {
      selectedServiceLocations.add(loc);
    }
    notifyListeners();
  }

  void toggleDayAvailability(int index, bool val) {
    if (index >= 0 && index < availableDays.length) {
      availableDays[index].isAvailable = val;
      notifyListeners();
    }
  }

  Future<void> selectDayTime(
    BuildContext context,
    int index,
    bool isOpenTime,
  ) async {
    if (index < 0 || index >= availableDays.length) return;
    final day = availableDays[index];
    final currentStr = isOpenTime ? day.openTime : day.closeTime;
    final parts = currentStr.split(':');
    final initialHour = parts.isNotEmpty
        ? (int.tryParse(parts[0]) ?? (isOpenTime ? 9 : 17))
        : (isOpenTime ? 9 : 17);
    final initialMinute = parts.length > 1
        ? (int.tryParse(parts[1]) ?? 30)
        : 30;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (isOpenTime) {
        day.openTime = formatted;
      } else {
        day.closeTime = formatted;
      }
      notifyListeners();
    }
  }

  Future<void> fetchPetCategories() async {
    isPetCategoriesLoading = true;
    notifyListeners();
    try {
      petCategories = await taxonomyUseCases.getPetCategories();
    } catch (e) {
      debugPrint('Error fetching pet categories: $e');
    } finally {
      isPetCategoriesLoading = false;
      notifyListeners();
    }
  }

  void togglePetCategory(String catId) {
    if (selectedPetCategories.contains(catId)) {
      selectedPetCategories.remove(catId);
    } else {
      selectedPetCategories.add(catId);
    }
    notifyListeners();
  }

  Future<void> fetchSpecialities() async {
    isSpecialitiesLoading = true;
    notifyListeners();
    try {
      specialities = await taxonomyUseCases.getSpecialities();
    } catch (e) {
      debugPrint('Error fetching specialities: $e');
    } finally {
      isSpecialitiesLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectSpeciality(String id) async {
    if (specialityObjectId == id) return;
    specialityObjectId = id;
    services.clear();
    notifyListeners();
    await fetchServices(id);
  }

  Future<void> fetchServices(String specialityId) async {
    isServicesLoading = true;
    notifyListeners();
    try {
      services = await taxonomyUseCases.getServices(
        specialityObjectId: specialityId,
      );
    } catch (e) {
      debugPrint('Error fetching services: $e');
    } finally {
      isServicesLoading = false;
      notifyListeners();
    }
  }

  void toggleServiceSelection(String serviceId) {
    if (selectedServices.contains(serviceId)) {
      selectedServices.remove(serviceId);
    } else {
      selectedServices.add(serviceId);
    }
    notifyListeners();
  }

  Future<void> pickProfileImage() async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'webp']);
    if (result != null) {
      profileImageDataURI = result['dataUri'];
      profileImageFileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<void> pickBusinessImage() async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'webp']);
    if (result != null) {
      businessImageDataURI = result['dataUri'];
      businessImageFileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<void> pickDegreeImage(int index) async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && index < degrees.length) {
      degrees[index].degreeImageDataURI = result['dataUri']!;
      degrees[index].fileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<void> pickLicenseImage(int index) async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && index < licenses.length) {
      licenses[index].licenseImageDataURI = result['dataUri']!;
      licenses[index].fileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<void> pickJobImage(int index) async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && index < workExperiences.length) {
      workExperiences[index].jobImageDataURI = result['dataUri']!;
      workExperiences[index].fileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<Map<String, String>?> _pickFileBytes(
    List<String> allowedExtensions,
  ) async {
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
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
          final dataUri = 'data:$mime;base64,$base64String';
          return {'dataUri': dataUri, 'fileName': platformFile.name};
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
    return null;
  }

  Future<bool> submitData(BuildContext context) async {
    if (fullName.trim().isEmpty) {
      showToast(context, 'Full Name is required', isError: true);
      return false;
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      showToast(context, 'Valid email is required', isError: true);
      return false;
    }
    if (phone.trim().isEmpty) {
      showToast(context, 'Phone number is required', isError: true);
      return false;
    }
    if (password.trim().isEmpty || password.length < 6) {
      showToast(
        context,
        'Password must be at least 6 characters',
        isError: true,
      );
      return false;
    }
    if (password != confirmPassword) {
      showToast(context, 'Passwords do not match', isError: true);
      return false;
    }
    if (bio.trim().isEmpty) {
      showToast(context, 'Professional biography is required', isError: true);
      return false;
    }

    if (businessName.trim().isEmpty) {
      showToast(context, 'Business Name is required', isError: true);
      return false;
    }
    if (businessEmail.trim().isEmpty || !businessEmail.contains('@')) {
      showToast(context, 'Valid Business Email is required', isError: true);
      return false;
    }
    if (businessPhone.trim().isEmpty) {
      showToast(context, 'Business Phone is required', isError: true);
      return false;
    }
    if (businessZIPCode.trim().isEmpty) {
      showToast(context, 'Business ZIP Code is required', isError: true);
      return false;
    }

    if (selectedPetCategories.isEmpty) {
      showToast(
        context,
        'Please select at least one pet category',
        isError: true,
      );
      return false;
    }
    if (selectedServices.isEmpty) {
      showToast(
        context,
        'Please select at least one service offered',
        isError: true,
      );
      return false;
    }
    if (selectedServiceLocations.isEmpty) {
      showToast(
        context,
        'Please select at least one service location',
        isError: true,
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final entity = ServiceProviderOnboardingEntity(
        profileImageDataURI: profileImageDataURI,
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        countryCode: countryCode.trim(),
        countryName: countryName.trim(),
        password: password,
        confirmPassword: confirmPassword,
        designation: designation.trim().isNotEmpty ? designation.trim() : null,
        timeZone: timeZone,
        bio: bio.trim(),
        gender: gender,
        knownLanguages: knownLanguages,
        businessImageDataURI: businessImageDataURI,
        businessName: businessName.trim(),
        businessEmail: businessEmail.trim(),
        businessPhone: businessPhone.trim(),
        businessZIPCode: businessZIPCode.trim(),
        latitude: latitude.trim(),
        longitude: longitude.trim(),
        pricePerAppointment: PricePerAppointmentEntity(
          price: pricePerAppointment,
          currencyCode: currencyCode,
        ),
        startingPricePerAppointment: PricePerAppointmentEntity(
          price: startingPricePerAppointment,
          currencyCode: currencyCode,
        ),
        degrees: degrees.map((d) => d.toEntity()).toList(),
        licenses: licenses.map((l) => l.toEntity()).toList(),
        workExperiences: workExperiences.map((w) => w.toEntity()).toList(),
        availableDays: availableDays.map((a) => a.toEntity()).toList(),
        petCategories: selectedPetCategories,
        servicesOffered: selectedServices,
        serviceLocations: selectedServiceLocations,
      );

      final result = await useCases.submitServiceProviderDataEntry(entity);

      if (context.mounted) {
        if (result.success) {
          showToast(
            context,
            result.message.isNotEmpty
                ? result.message
                : 'Service Provider registered successfully!',
          );
        } else {
          showToast(context, result.message, isError: true);
        }
      }
      return result.success;
    } catch (e) {
      if (context.mounted) {
        showToast(context, 'Submission failed: $e', isError: true);
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
