class DegreeEntity {
  final String degreeImageDataURI;
  final String institutionTitle;
  final String degreeTitle;
  final String duration;
  final String startDate;
  final String? endDate;
  final String currentlyStudyingHere; // "yes" or "no"

  const DegreeEntity({
    required this.degreeImageDataURI,
    required this.institutionTitle,
    required this.degreeTitle,
    required this.duration,
    required this.startDate,
    this.endDate,
    this.currentlyStudyingHere = 'no',
  });
}

class LicenseEntity {
  final String licenseImageDataURI;
  final String state;
  final String stateAbbreviation;
  final String licenseNumber;
  final String licenseExpiryDate;

  const LicenseEntity({
    required this.licenseImageDataURI,
    required this.state,
    required this.stateAbbreviation,
    required this.licenseNumber,
    required this.licenseExpiryDate,
  });
}

class WorkExperienceEntity {
  final String jobImageDataURI;
  final String jobTitle;
  final String jobOrganizationTitle;
  final String jobYearsOfExperience;
  final String jobOrganizationAddress;
  final String jobStartDate;
  final String? jobEndDate;
  final String jobCurrentlyWorkingHere; // "yes" or "no"

  const WorkExperienceEntity({
    required this.jobImageDataURI,
    required this.jobTitle,
    required this.jobOrganizationTitle,
    required this.jobYearsOfExperience,
    required this.jobOrganizationAddress,
    required this.jobStartDate,
    this.jobEndDate,
    this.jobCurrentlyWorkingHere = 'no',
  });
}

class AvailableDayEntity {
  final int dayIndex; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  final bool isAvailable;
  final String? openTime;
  final String? closeTime;
  final String? open; // total minutes elapsed since midnight (0 to 1439)
  final String? close; // total minutes elapsed since midnight (0 to 1439)

  const AvailableDayEntity({
    required this.dayIndex,
    required this.isAvailable,
    this.openTime,
    this.closeTime,
    this.open,
    this.close,
  });
}

class PricePerAppointmentEntity {
  final num price;
  final String currencyCode;

  const PricePerAppointmentEntity({
    required this.price,
    this.currencyCode = 'USD',
  });
}

class ServiceProviderOnboardingEntity {
  // Basic Details
  final String? profileImageDataURI;
  final String fullName;
  final String email;
  final String phone;
  final String countryCode;
  final String countryName;
  final String password;
  final String confirmPassword;
  final String? designation;
  final String timeZone;
  final String bio;
  final String gender;
  final List<String> knownLanguages;

  // Business Details
  final String? businessImageDataURI;
  final String businessName;
  final String businessEmail;
  final String businessPhone;
  final String businessZIPCode;
  final String latitude;
  final String longitude;

  // Pricing
  final PricePerAppointmentEntity pricePerAppointment;
  final PricePerAppointmentEntity startingPricePerAppointment;

  // Nested Lists & Taxonomies
  final List<DegreeEntity> degrees;
  final List<LicenseEntity> licenses;
  final List<WorkExperienceEntity> workExperiences;
  final List<AvailableDayEntity> availableDays;
  final List<String> petCategories;
  final List<String> servicesOffered;
  final List<String> serviceLocations;

  const ServiceProviderOnboardingEntity({
    this.profileImageDataURI,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.countryName,
    required this.password,
    required this.confirmPassword,
    this.designation,
    required this.timeZone,
    required this.bio,
    required this.gender,
    required this.knownLanguages,
    this.businessImageDataURI,
    required this.businessName,
    required this.businessEmail,
    required this.businessPhone,
    required this.businessZIPCode,
    required this.latitude,
    required this.longitude,
    required this.pricePerAppointment,
    required this.startingPricePerAppointment,
    required this.degrees,
    required this.licenses,
    required this.workExperiences,
    required this.availableDays,
    required this.petCategories,
    required this.servicesOffered,
    required this.serviceLocations,
  });
}

class ServiceProviderDataEntryResponseEntity {
  final bool success;
  final String message;
  final String? serviceProviderId;
  final String? userId;

  const ServiceProviderDataEntryResponseEntity({
    required this.success,
    required this.message,
    this.serviceProviderId,
    this.userId,
  });
}
