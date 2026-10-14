class LabOnboardingLicenseEntity {
  final String licenseImageDataURI;
  final String state;
  final String? stateAbbreviation;
  final String licenseNumber;
  final String? licenseExpiryDate;

  const LabOnboardingLicenseEntity({
    required this.licenseImageDataURI,
    required this.state,
    this.stateAbbreviation,
    required this.licenseNumber,
    this.licenseExpiryDate,
  });
}

class LabOnboardingAvailableDayEntity {
  final int dayIndex;
  final bool isAvailable;
  final String? openTime;
  final String? closeTime;

  const LabOnboardingAvailableDayEntity({
    required this.dayIndex,
    required this.isAvailable,
    this.openTime,
    this.closeTime,
  });
}

class LabOnboardingEntity {
  final String title;
  final String email;
  final String phone;
  final String? businessEmail;
  final String? businessPhone;
  final String countryCode;
  final String countryName;
  final String password;
  final String confirmPassword;
  final String labType;
  final String? designation;
  final String bio;
  final String address;
  final String city;
  final String? state;
  final String? province;
  final String zipCode;
  final String latitude;
  final String longitude;
  final String timeZone;
  final List<String> serviceLocations;
  final String? averageTurnAroundTime;
  final String? profileImageDataURI;
  final List<LabOnboardingLicenseEntity> licenses;
  final List<String> petCategories;
  final List<String> labTestCategories;
  final List<LabOnboardingAvailableDayEntity> availableDays;

  const LabOnboardingEntity({
    required this.title,
    required this.email,
    required this.phone,
    this.businessEmail,
    this.businessPhone,
    required this.countryCode,
    required this.countryName,
    required this.password,
    required this.confirmPassword,
    required this.labType,
    this.designation,
    required this.bio,
    required this.address,
    required this.city,
    this.state,
    this.province,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.timeZone,
    this.serviceLocations = const [],
    this.averageTurnAroundTime,
    this.profileImageDataURI,
    required this.licenses,
    required this.petCategories,
    required this.labTestCategories,
    required this.availableDays,
  });
}

class LabDataEntryResponseEntity {
  final bool success;
  final String message;
  final String? labId;
  final String? userId;

  const LabDataEntryResponseEntity({
    required this.success,
    required this.message,
    this.labId,
    this.userId,
  });
}
