class UpdateDoctorLicenseEntity {
  final String? licenseImageDataURI;
  final String? state;
  final String? stateAbbreviation;
  final String? licenseNumber;
  final String? licenseExpiryDate;

  const UpdateDoctorLicenseEntity({
    this.licenseImageDataURI,
    this.state,
    this.stateAbbreviation,
    this.licenseNumber,
    this.licenseExpiryDate,
  });
}

class UpdateDoctorAvailableDayEntity {
  final bool? isAvailable;
  final String? openTime;
  final String? closeTime;
  final String? open;
  final String? close;

  const UpdateDoctorAvailableDayEntity({
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.open,
    this.close,
  });
}

class UpdateDoctorPriceEntity {
  final num? price;
  final String? currencyCode;

  const UpdateDoctorPriceEntity({
    this.price,
    this.currencyCode,
  });
}

class UpdateDoctorEntity {
  final String? profileImageDataURI;
  final String? designation;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? password;
  final List<String>? knownLanguages;
  final String? city;
  final String? province;
  final String? countryCode;
  final String? countryName;
  final String? gender;
  final String? bio;
  final List<UpdateDoctorLicenseEntity>? licenses;
  final List<String>? petCategories;
  final String? specialityObjectId;
  final List<String>? servicesOffered;
  final String? timeZone;
  final List<UpdateDoctorAvailableDayEntity>? availableDays;
  final UpdateDoctorPriceEntity? pricePerAppointment;

  const UpdateDoctorEntity({
    this.profileImageDataURI,
    this.designation,
    this.fullName,
    this.phone,
    this.email,
    this.password,
    this.knownLanguages,
    this.city,
    this.province,
    this.countryCode,
    this.countryName,
    this.gender,
    this.bio,
    this.licenses,
    this.petCategories,
    this.specialityObjectId,
    this.servicesOffered,
    this.timeZone,
    this.availableDays,
    this.pricePerAppointment,
  });
}
