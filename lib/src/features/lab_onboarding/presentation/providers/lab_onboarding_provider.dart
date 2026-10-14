import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/taxonomy/domain/entities/pet_category_entity.dart';
import '../../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../../domain/entities/lab_entity.dart';
import '../../domain/entities/lab_onboarding_entity.dart';
import '../../domain/usecases/lab_onboarding_usecases.dart';

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
    this.openTime = '09:00',
    this.closeTime = '17:00',
  });

  LabOnboardingAvailableDayEntity toEntity() {
    return LabOnboardingAvailableDayEntity(
      dayIndex: dayIndex,
      isAvailable: isAvailable,
      openTime: isAvailable ? openTime : null,
      closeTime: isAvailable ? closeTime : null,
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

  LabOnboardingLicenseEntity toEntity() {
    return LabOnboardingLicenseEntity(
      licenseImageDataURI: licenseImageDataURI,
      state: state,
      stateAbbreviation:
          stateAbbreviation.isNotEmpty ? stateAbbreviation : null,
      licenseNumber: licenseNumber,
      licenseExpiryDate:
          licenseExpiryDate.isNotEmpty ? licenseExpiryDate : null,
    );
  }
}

class LabOnboardingProvider extends ChangeNotifier {
  final LabOnboardingUseCases useCases;
  final TaxonomyUseCases taxonomyUseCases;

  LabOnboardingProvider({
    required this.useCases,
    required this.taxonomyUseCases,
  }) {
    _initDefaultAvailableDays();
    _initLicenses();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDataLoaded = false;
  bool get isDataLoaded => _isDataLoaded;

  String? profileImageBase64;
  String? profileImageFileName;

  String selectedTimeZone = 'America/New_York';
  String selectedLabType = 'Veterinary Diagnostic Lab';

  final List<String> availableLabTypes = const [
    'Veterinary Diagnostic Lab',
    'Clinical Pathology Lab',
    'Molecular & Genetic Lab',
    'Microbiology Lab',
    'Toxicology Lab',
    'General Veterinary Reference Lab',
  ];

  final List<String> availableServiceLocations = const ['Home', 'Office'];
  final List<String> selectedServiceLocations = ['Home', 'Office'];

  final List<String> availableTurnAroundTimes = const [
    'Same Day',
    '24 Hours',
    '2-3 Days',
    '3-5 Days',
    'Depends on test',
  ];
  String selectedTurnAroundTime = '2-3 Days';

  void toggleServiceLocation(String loc) {
    if (selectedServiceLocations.contains(loc)) {
      selectedServiceLocations.remove(loc);
    } else {
      selectedServiceLocations.add(loc);
    }
    notifyListeners();
  }

  void setTurnAroundTime(String val) {
    selectedTurnAroundTime = val;
    notifyListeners();
  }

  final List<LicenseFormItem> licenses = [];
  final List<DayScheduleItem> availableDays = [];

  List<PetCategoryEntity> availablePetCategories = [];
  final List<String> selectedPetCategoryIds = [];

  List<LabTestCategoryEntity> availableLabTestCategories = [];
  final List<String> selectedLabTestCategoryIds = [];

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
    for (int i = 0; i < days.length; i++) {
      availableDays.add(
        DayScheduleItem(
          dayIndex: i,
          dayName: days[i],
          isAvailable: i != 0,
        ),
      );
    }
  }

  void _initLicenses() {
    if (licenses.isEmpty) {
      licenses.add(LicenseFormItem());
    }
  }

  Future<void> loadTaxonomyData() async {
    if (_isDataLoaded) return;
    try {
      final petCats = await taxonomyUseCases.getPetCategories();
      availablePetCategories = petCats;
    } catch (_) {}

    try {
      final testCatsResp = await useCases.getLabTestCategories(pageSize: 100);
      availableLabTestCategories = testCatsResp.docs;
    } catch (_) {}

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final ext = file.extension ?? 'png';
          final base64String = base64Encode(file.bytes!);
          profileImageBase64 = 'data:image/$ext;base64,$base64String';
          profileImageFileName = file.name;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to select lab image: $e');
    }
  }

  void removeProfileImage() {
    profileImageBase64 = null;
    profileImageFileName = null;
    notifyListeners();
  }

  Future<void> pickLicenseImage(int index) async {
    if (index < 0 || index >= licenses.length) return;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final ext = file.extension ?? 'png';
          final base64String = base64Encode(file.bytes!);
          licenses[index].licenseImageDataURI =
              'data:image/$ext;base64,$base64String';
          licenses[index].fileName = file.name;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to select license file: $e');
    }
  }

  void addLicense() {
    licenses.add(LicenseFormItem());
    notifyListeners();
  }

  void removeLicense(int index) {
    if (licenses.length > 1 && index >= 0 && index < licenses.length) {
      licenses.removeAt(index);
      notifyListeners();
    }
  }

  void togglePetCategory(String id) {
    if (selectedPetCategoryIds.contains(id)) {
      selectedPetCategoryIds.remove(id);
    } else {
      selectedPetCategoryIds.add(id);
    }
    notifyListeners();
  }

  void toggleLabTestCategory(String id) {
    if (selectedLabTestCategoryIds.contains(id)) {
      selectedLabTestCategoryIds.remove(id);
    } else {
      selectedLabTestCategoryIds.add(id);
    }
    notifyListeners();
  }

  void toggleDayAvailability(int index, bool val) {
    updateDayAvailability(index, val);
  }

  void updateDayAvailability(int index, bool val) {
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
        ? (int.tryParse(parts[1]) ?? 0)
        : 0;

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

  void setTimeZone(String tz) {
    selectedTimeZone = tz;
    notifyListeners();
  }

  void setLabType(String type) {
    selectedLabType = type;
    notifyListeners();
  }

  Future<bool> submitLab(
    BuildContext context, {
    required String title,
    required String email,
    required String phone,
    String? businessEmail,
    String? businessPhone,
    required String countryCode,
    required String countryName,
    required String password,
    required String confirmPassword,
    required String bio,
    required String address,
    required String city,
    String? state,
    String? province,
    required String zipCode,
    required String latitude,
    required String longitude,
    String? designation,
  }) async {

    if (title.trim().isEmpty) {
      showToast(context, 'Please enter the diagnostic lab name', isError: true);
      return false;
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      showToast(context, 'Please enter a valid email address', isError: true);
      return false;
    }
    if (phone.trim().isEmpty) {
      showToast(context, 'Please enter a valid contact phone number', isError: true);
      return false;
    }
    if (countryCode.trim().isEmpty) {
      showToast(context, 'Please enter country code (e.g. US)', isError: true);
      return false;
    }
    if (countryName.trim().isEmpty) {
      showToast(context, 'Please enter country name (e.g. United States)', isError: true);
      return false;
    }
    if (password.length < 6) {
      showToast(context, 'Password must be at least 6 characters', isError: true);
      return false;
    }
    if (password != confirmPassword) {
      showToast(context, 'Passwords do not match', isError: true);
      return false;
    }
    if (address.trim().isEmpty) {
      showToast(context, 'Please enter the lab physical address', isError: true);
      return false;
    }
    if (city.trim().isEmpty) {
      showToast(context, 'Please enter the lab city', isError: true);
      return false;
    }
    if (zipCode.trim().isEmpty) {
      showToast(context, 'Please enter the ZIP/Postal code', isError: true);
      return false;
    }
    if (latitude.trim().isEmpty) {
      showToast(context, 'Please enter facility latitude coordinate', isError: true);
      return false;
    }
    if (longitude.trim().isEmpty) {
      showToast(context, 'Please enter facility longitude coordinate', isError: true);
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final validLicenses =
          licenses
              .where((l) => l.licenseNumber.trim().isNotEmpty)
              .map((l) => l.toEntity())
              .toList();

      final entity = LabOnboardingEntity(
        title: title.trim(),
        email: email.trim(),
        phone: phone.trim(),
        businessEmail: businessEmail?.trim().isNotEmpty == true
            ? businessEmail!.trim()
            : email.trim(),
        businessPhone: businessPhone?.trim().isNotEmpty == true
            ? businessPhone!.trim()
            : phone.trim(),
        countryCode: countryCode.trim(),
        countryName: countryName.trim(),
        password: password,
        confirmPassword: confirmPassword,
        labType: selectedLabType,
        designation: designation?.trim().isNotEmpty == true
            ? designation!.trim()
            : 'Lab Director',
        bio: bio.trim().isNotEmpty
            ? bio.trim()
            : 'Veterinary clinical diagnostic laboratory providing full test catalog and sample screening.',
        address: address.trim(),
        city: city.trim(),
        state: state?.trim().isNotEmpty == true ? state!.trim() : 'New York',
        province: province?.trim().isNotEmpty == true
            ? province!.trim()
            : (state?.trim().isNotEmpty == true ? state!.trim() : 'New York'),
        zipCode: zipCode.trim(),
        latitude: latitude.trim(),
        longitude: longitude.trim(),
        timeZone: selectedTimeZone,
        serviceLocations: List<String>.from(selectedServiceLocations),
        averageTurnAroundTime: selectedTurnAroundTime,
        profileImageDataURI: profileImageBase64,
        licenses: validLicenses,
        petCategories: List<String>.from(selectedPetCategoryIds),
        labTestCategories: List<String>.from(selectedLabTestCategoryIds),
        availableDays: availableDays.map((d) => d.toEntity()).toList(),
      );

      final resp = await useCases.submitLabDataEntry(entity);
      if (resp.success) {
        if (context.mounted) {
          showToast(
            context,
            resp.message.isNotEmpty
                ? resp.message
                : 'Lab onboarded successfully!',
          );
        }
        resetForm();
        return true;
      } else {
        if (context.mounted) {
          showToast(
            context,
            resp.message.isNotEmpty ? resp.message : 'Failed to onboard lab',
            isError: true,
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        showToast(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    profileImageBase64 = null;
    profileImageFileName = null;
    selectedPetCategoryIds.clear();
    selectedLabTestCategoryIds.clear();
    selectedServiceLocations.clear();
    selectedServiceLocations.addAll(['Home', 'Office']);
    selectedTurnAroundTime = '2-3 Days';
    licenses.clear();
    _initLicenses();
    _initDefaultAvailableDays();
    notifyListeners();
  }
}
