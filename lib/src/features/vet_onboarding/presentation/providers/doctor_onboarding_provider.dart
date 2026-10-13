import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/taxonomy/domain/entities/service_entity.dart';
import '../../../../shared/taxonomy/domain/entities/speciality_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/doctor_onboarding_entity.dart';
import '../../domain/usecases/vet_onboarding_usecases.dart';

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

class ClinicFormItem {
  String clinicImageDataURI = '';
  String title = '';
  String latitude = '';
  String longitude = '';
  String clinicPhone = '';
  String address = '';
  String city = '';
  String province = '';
  String? fileName;

  ClinicEntity toEntity() {
    return ClinicEntity(
      clinicImageDataURI: clinicImageDataURI,
      title: title,
      latitude: latitude,
      longitude: longitude,
      clinicPhone: clinicPhone,
      address: address,
      city: city,
      province: province,
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

class DoctorOnboardingProvider extends ChangeNotifier {
  final VetOnboardingUseCases useCases;
  final TaxonomyUseCases taxonomyUseCases;

  DoctorOnboardingProvider({
    required this.useCases,
    required this.taxonomyUseCases,
  }) {
    _initDefaultAvailableDays();
    _initDefaultItems();
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
  String? profileImageDataURI;
  String? profileImageFileName;

  List<String> selectedPetCategories = ['681362c4f0fea77adde87550'];
  String specialityObjectId = '';
  List<String> servicesOffered = [];

  List<SpecialityEntity> specialities = [];
  List<ServiceEntity> services = [];
  bool isSpecialitiesLoading = false;
  bool isServicesLoading = false;

  String? get selectedSpecialityId =>
      specialityObjectId.isNotEmpty ? specialityObjectId : null;
  List<String> get selectedServices => servicesOffered;

  num price = 0;
  String currencyCode = 'USD';

  final List<DegreeFormItem> degrees = [];
  final List<ClinicFormItem> clinics = [];
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
    if (degrees.isEmpty) {
      degrees.add(DegreeFormItem());
    }
    if (clinics.isEmpty) {
      clinics.add(ClinicFormItem());
    }
    if (licenses.isEmpty) {
      licenses.add(LicenseFormItem());
    }
    if (workExperiences.isEmpty) {
      workExperiences.add(WorkExperienceFormItem());
    }
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

  void addClinic() {
    clinics.add(ClinicFormItem());
    notifyListeners();
  }

  void removeClinic(int index) {
    if (clinics.length > 1) {
      clinics.removeAt(index);
      notifyListeners();
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

  void toggleDayAvailability(int index, bool val) {
    if (index >= 0 && index < availableDays.length) {
      availableDays[index].isAvailable = val;
      notifyListeners();
    }
  }

  void updateDayTimes(int index, String open, String close) {
    if (index >= 0 && index < availableDays.length) {
      availableDays[index].openTime = open;
      availableDays[index].closeTime = close;
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
    servicesOffered.clear();
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
    if (servicesOffered.contains(serviceId)) {
      servicesOffered.remove(serviceId);
    } else {
      servicesOffered.add(serviceId);
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

  Future<void> pickDegreeImage(int index) async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && index < degrees.length) {
      degrees[index].degreeImageDataURI = result['dataUri']!;
      degrees[index].fileName = result['fileName'];
      notifyListeners();
    }
  }

  Future<void> pickClinicImage(int index) async {
    final result = await _pickFileBytes(['jpg', 'jpeg', 'png']);
    if (result != null && index < clinics.length) {
      clinics[index].clinicImageDataURI = result['dataUri']!;
      clinics[index].fileName = result['fileName'];
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
    if (specialityObjectId.trim().isEmpty) {
      showToast(
        context,
        'Please select your medical speciality',
        isError: true,
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final entity = DoctorOnboardingEntity(
        profileImageDataURI: profileImageDataURI,
        designation: designation.trim().isNotEmpty ? designation : null,
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        countryCode: countryCode,
        countryName: countryName,
        password: password,
        confirmPassword: confirmPassword,
        degrees: degrees.map((e) => e.toEntity()).toList(),
        clinics: clinics.map((e) => e.toEntity()).toList(),
        licenses: licenses.map((e) => e.toEntity()).toList(),
        workExperiences: workExperiences.map((e) => e.toEntity()).toList(),
        petCategories: selectedPetCategories,
        specialityObjectId: specialityObjectId,
        servicesOffered: servicesOffered,
        bio: bio.trim(),
        timeZone: timeZone,
        availableDays: availableDays.map((e) => e.toEntity()).toList(),
        pricePerAppointment: PricePerAppointmentEntity(
          price: price,
          currencyCode: currencyCode,
        ),
      );

      final response = await useCases.submitDoctorDataEntry(entity);

      if (context.mounted) {
        showToast(context, response.message);
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        showToast(context, e.toString(), isError: true);
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
