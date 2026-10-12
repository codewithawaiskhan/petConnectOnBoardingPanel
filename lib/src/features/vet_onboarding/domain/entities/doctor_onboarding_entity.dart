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

class ClinicEntity {
  final String clinicImageDataURI;
  final String title;
  final String latitude;
  final String longitude;
  final String clinicPhone;
  final String address;
  final String city;
  final String province;

  const ClinicEntity({
    required this.clinicImageDataURI,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.clinicPhone,
    required this.address,
    required this.city,
    required this.province,
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

class DoctorOnboardingEntity {
  final String? profileImageDataURI;
  final String? designation;
  final String fullName;
  final String email;
  final String phone;
  final String countryCode;
  final String countryName;
  final String password;
  final String confirmPassword;
  final List<DegreeEntity> degrees;
  final List<ClinicEntity> clinics;
  final List<LicenseEntity> licenses;
  final List<WorkExperienceEntity> workExperiences;
  final List<String> petCategories;
  final String specialityObjectId;
  final List<String> servicesOffered;
  final String bio;
  final String timeZone;
  final List<AvailableDayEntity> availableDays;
  final PricePerAppointmentEntity pricePerAppointment;

  const DoctorOnboardingEntity({
    this.profileImageDataURI,
    this.designation,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.countryName,
    required this.password,
    required this.confirmPassword,
    required this.degrees,
    required this.clinics,
    required this.licenses,
    required this.workExperiences,
    required this.petCategories,
    required this.specialityObjectId,
    required this.servicesOffered,
    required this.bio,
    required this.timeZone,
    required this.availableDays,
    required this.pricePerAppointment,
  });
}

class DoctorDataEntryResponseEntity {
  final bool success;
  final String message;
  final String? doctorId;
  final String? userId;

  const DoctorDataEntryResponseEntity({
    required this.success,
    required this.message,
    this.doctorId,
    this.userId,
  });
}
