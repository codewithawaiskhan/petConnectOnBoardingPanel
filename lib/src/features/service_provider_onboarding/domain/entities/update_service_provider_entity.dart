class UpdateServiceProviderDegreeEntity {
  final String? degreeImageDataURI;
  final String? institutionTitle;
  final String? degreeTitle;
  final String? duration;
  final String? startDate;
  final String? endDate;
  final String? currentlyStudyingHere;

  const UpdateServiceProviderDegreeEntity({
    this.degreeImageDataURI,
    this.institutionTitle,
    this.degreeTitle,
    this.duration,
    this.startDate,
    this.endDate,
    this.currentlyStudyingHere,
  });
}

class UpdateServiceProviderWorkExperienceEntity {
  final String? jobImageDataURI;
  final String? jobTitle;
  final String? jobOrganizationTitle;
  final String? jobYearsOfExperience;
  final String? jobOrganizationAddress;
  final String? jobStartDate;
  final String? jobEndDate;
  final String? jobCurrentlyWorkingHere;

  const UpdateServiceProviderWorkExperienceEntity({
    this.jobImageDataURI,
    this.jobTitle,
    this.jobOrganizationTitle,
    this.jobYearsOfExperience,
    this.jobOrganizationAddress,
    this.jobStartDate,
    this.jobEndDate,
    this.jobCurrentlyWorkingHere,
  });
}

class UpdateServiceProviderLicenseEntity {
  final String? licenseImageDataURI;
  final String? state;
  final String? stateAbbreviation;
  final String? licenseNumber;
  final String? licenseExpiryDate;

  const UpdateServiceProviderLicenseEntity({
    this.licenseImageDataURI,
    this.state,
    this.stateAbbreviation,
    this.licenseNumber,
    this.licenseExpiryDate,
  });
}

class UpdateServiceProviderAvailableDayEntity {
  final bool? isAvailable;
  final String? openTime;
  final String? closeTime;
  final String? open;
  final String? close;

  const UpdateServiceProviderAvailableDayEntity({
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.open,
    this.close,
  });
}

class UpdateServiceProviderPriceEntity {
  final num? price;
  final String? currencyCode;

  const UpdateServiceProviderPriceEntity({
    this.price,
    this.currencyCode,
  });
}

class UpdateServiceProviderEntity {
  final String? profileImageDataURI;
  final String? businessImageDataURI;
  final String? designation;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? countryName;
  final String? gender;
  final String? password;
  final String? address;
  final String? city;
  final String? province;
  final String? businessName;
  final String? businessEmail;
  final String? businessPhone;
  final String? latitude;
  final String? longitude;
  final dynamic businessZIPCode;
  final List<UpdateServiceProviderDegreeEntity>? degrees;
  final List<UpdateServiceProviderLicenseEntity>? licenses;
  final List<UpdateServiceProviderWorkExperienceEntity>? workExperiences;
  final List<String>? petCategories;
  final String? specialityObjectId;
  final List<String>? servicesOffered;
  final String? otherService;
  final String? bio;
  final String? timeZone;
  final List<String>? knownLanguages;
  final List<UpdateServiceProviderAvailableDayEntity>? availableDays;
  final List<String>? serviceLocations;
  final UpdateServiceProviderPriceEntity? startingPricePerAppointment;
  final UpdateServiceProviderPriceEntity? pricePerAppointment;

  const UpdateServiceProviderEntity({
    this.profileImageDataURI,
    this.businessImageDataURI,
    this.designation,
    this.fullName,
    this.email,
    this.phone,
    this.countryCode,
    this.countryName,
    this.gender,
    this.password,
    this.address,
    this.city,
    this.province,
    this.businessName,
    this.businessEmail,
    this.businessPhone,
    this.latitude,
    this.longitude,
    this.businessZIPCode,
    this.degrees,
    this.licenses,
    this.workExperiences,
    this.petCategories,
    this.specialityObjectId,
    this.servicesOffered,
    this.otherService,
    this.bio,
    this.timeZone,
    this.knownLanguages,
    this.availableDays,
    this.serviceLocations,
    this.startingPricePerAppointment,
    this.pricePerAppointment,
  });
}
