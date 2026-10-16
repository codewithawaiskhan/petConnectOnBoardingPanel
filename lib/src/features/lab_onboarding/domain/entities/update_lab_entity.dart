class UpdateLabLicenseEntity {
  final String? licenseImageDataURI;
  final String? state;
  final String? stateAbbreviation;
  final String? licenseNumber;
  final String? licenseExpiryDate;

  const UpdateLabLicenseEntity({
    this.licenseImageDataURI,
    this.state,
    this.stateAbbreviation,
    this.licenseNumber,
    this.licenseExpiryDate,
  });
}

class UpdateLabAvailableDayEntity {
  final bool? isAvailable;
  final String? openTime;
  final String? closeTime;
  final String? open;
  final String? close;

  const UpdateLabAvailableDayEntity({
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.open,
    this.close,
  });
}

class UpdateLabEntity {
  final String? profileImageDataURI;
  final String? designation;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? countryName;
  final String? password;
  final String? title;
  final String? businessEmail;
  final String? businessPhone;
  final String? labType;
  final String? address;
  final String? city;
  final String? province;
  final String? latitude;
  final String? longitude;
  final dynamic zipCode;
  final List<UpdateLabLicenseEntity>? licenses;
  final List<String>? petCategories;
  final List<String>? labTestCategories;
  final String? otherCategory;
  final String? bio;
  final String? timeZone;
  final List<UpdateLabAvailableDayEntity>? availableDays;
  final List<String>? serviceLocations;
  final String? averageTurnAroundTime;

  const UpdateLabEntity({
    this.profileImageDataURI,
    this.designation,
    this.fullName,
    this.email,
    this.phone,
    this.countryCode,
    this.countryName,
    this.password,
    this.title,
    this.businessEmail,
    this.businessPhone,
    this.labType,
    this.address,
    this.city,
    this.province,
    this.latitude,
    this.longitude,
    this.zipCode,
    this.licenses,
    this.petCategories,
    this.labTestCategories,
    this.otherCategory,
    this.bio,
    this.timeZone,
    this.availableDays,
    this.serviceLocations,
    this.averageTurnAroundTime,
  });
}
