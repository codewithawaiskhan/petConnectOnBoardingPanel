import '../../domain/entities/update_doctor_entity.dart';

class UpdateDoctorLicenseModel extends UpdateDoctorLicenseEntity {
  const UpdateDoctorLicenseModel({
    super.licenseImageDataURI,
    super.state,
    super.stateAbbreviation,
    super.licenseNumber,
    super.licenseExpiryDate,
  });

  factory UpdateDoctorLicenseModel.fromEntity(UpdateDoctorLicenseEntity entity) {
    return UpdateDoctorLicenseModel(
      licenseImageDataURI: entity.licenseImageDataURI,
      state: entity.state,
      stateAbbreviation: entity.stateAbbreviation,
      licenseNumber: entity.licenseNumber,
      licenseExpiryDate: entity.licenseExpiryDate,
    );
  }

  factory UpdateDoctorLicenseModel.fromJson(Map<String, dynamic> json) {
    return UpdateDoctorLicenseModel(
      licenseImageDataURI: json['licenseImageDataURI']?.toString(),
      state: json['state']?.toString(),
      stateAbbreviation: json['stateAbbreviation']?.toString(),
      licenseNumber: json['licenseNumber']?.toString(),
      licenseExpiryDate: json['licenseExpiryDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (licenseImageDataURI != null && licenseImageDataURI!.isNotEmpty) {
      map['licenseImageDataURI'] = licenseImageDataURI;
    }
    if (state != null && state!.isNotEmpty) map['state'] = state;
    if (stateAbbreviation != null && stateAbbreviation!.isNotEmpty) {
      map['stateAbbreviation'] = stateAbbreviation;
    }
    if (licenseNumber != null && licenseNumber!.isNotEmpty) {
      map['licenseNumber'] = licenseNumber;
    }
    if (licenseExpiryDate != null && licenseExpiryDate!.isNotEmpty) {
      map['licenseExpiryDate'] = licenseExpiryDate;
    }
    return map;
  }
}

class UpdateDoctorAvailableDayModel extends UpdateDoctorAvailableDayEntity {
  const UpdateDoctorAvailableDayModel({
    super.isAvailable,
    super.openTime,
    super.closeTime,
    super.open,
    super.close,
  });

  factory UpdateDoctorAvailableDayModel.fromEntity(
    UpdateDoctorAvailableDayEntity entity,
  ) {
    return UpdateDoctorAvailableDayModel(
      isAvailable: entity.isAvailable,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      open: entity.open,
      close: entity.close,
    );
  }

  factory UpdateDoctorAvailableDayModel.fromJson(Map<String, dynamic> json) {
    return UpdateDoctorAvailableDayModel(
      isAvailable: json['isAvailable'] as bool?,
      openTime: json['openTime']?.toString(),
      closeTime: json['closeTime']?.toString(),
      open: json['open']?.toString(),
      close: json['close']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (isAvailable != null) map['isAvailable'] = isAvailable;
    if (openTime != null && openTime!.isNotEmpty) map['openTime'] = openTime;
    if (closeTime != null && closeTime!.isNotEmpty) map['closeTime'] = closeTime;
    if (open != null && open!.isNotEmpty) map['open'] = open;
    if (close != null && close!.isNotEmpty) map['close'] = close;
    return map;
  }
}

class UpdateDoctorPriceModel extends UpdateDoctorPriceEntity {
  const UpdateDoctorPriceModel({
    super.price,
    super.currencyCode,
  });

  factory UpdateDoctorPriceModel.fromEntity(UpdateDoctorPriceEntity entity) {
    return UpdateDoctorPriceModel(
      price: entity.price,
      currencyCode: entity.currencyCode,
    );
  }

  factory UpdateDoctorPriceModel.fromJson(Map<String, dynamic> json) {
    return UpdateDoctorPriceModel(
      price: json['price'] is num
          ? json['price'] as num
          : num.tryParse(json['price']?.toString() ?? ''),
      currencyCode: json['currencyCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (price != null) map['price'] = price;
    if (currencyCode != null && currencyCode!.isNotEmpty) {
      map['currencyCode'] = currencyCode;
    }
    return map;
  }
}

class UpdateDoctorModel extends UpdateDoctorEntity {
  const UpdateDoctorModel({
    super.profileImageDataURI,
    super.designation,
    super.fullName,
    super.phone,
    super.email,
    super.password,
    super.knownLanguages,
    super.city,
    super.province,
    super.countryCode,
    super.countryName,
    super.gender,
    super.bio,
    super.licenses,
    super.petCategories,
    super.specialityObjectId,
    super.servicesOffered,
    super.timeZone,
    super.availableDays,
    super.pricePerAppointment,
  });

  factory UpdateDoctorModel.fromEntity(UpdateDoctorEntity entity) {
    return UpdateDoctorModel(
      profileImageDataURI: entity.profileImageDataURI,
      designation: entity.designation,
      fullName: entity.fullName,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
      knownLanguages: entity.knownLanguages != null
          ? List<String>.from(entity.knownLanguages!)
          : null,
      city: entity.city,
      province: entity.province,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
      gender: entity.gender,
      bio: entity.bio,
      licenses: entity.licenses
          ?.map((l) => UpdateDoctorLicenseModel.fromEntity(l))
          .toList(),
      petCategories: entity.petCategories != null
          ? List<String>.from(entity.petCategories!)
          : null,
      specialityObjectId: entity.specialityObjectId,
      servicesOffered: entity.servicesOffered != null
          ? List<String>.from(entity.servicesOffered!)
          : null,
      timeZone: entity.timeZone,
      availableDays: entity.availableDays
          ?.map((d) => UpdateDoctorAvailableDayModel.fromEntity(d))
          .toList(),
      pricePerAppointment: entity.pricePerAppointment != null
          ? UpdateDoctorPriceModel.fromEntity(entity.pricePerAppointment!)
          : null,
    );
  }

  factory UpdateDoctorModel.fromJson(Map<String, dynamic> json) {
    return UpdateDoctorModel(
      profileImageDataURI: json['profileImageDataURI']?.toString(),
      designation: json['designation']?.toString(),
      fullName: json['fullName']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      knownLanguages: (json['knownLanguages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      gender: json['gender']?.toString(),
      bio: json['bio']?.toString(),
      licenses: (json['licenses'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => UpdateDoctorLicenseModel.fromJson(e))
          .toList(),
      petCategories: (json['petCategories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      specialityObjectId: json['specialityObjectId']?.toString(),
      servicesOffered: (json['servicesOffered'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      timeZone: json['timeZone']?.toString(),
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => UpdateDoctorAvailableDayModel.fromJson(e))
          .toList(),
      pricePerAppointment: json['pricePerAppointment'] is Map<String, dynamic>
          ? UpdateDoctorPriceModel.fromJson(
              json['pricePerAppointment'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (profileImageDataURI != null && profileImageDataURI!.isNotEmpty) {
      map['profileImageDataURI'] = profileImageDataURI;
    }
    if (designation != null && designation!.isNotEmpty) {
      map['designation'] = designation;
    }
    if (fullName != null && fullName!.isNotEmpty) map['fullName'] = fullName;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (email != null && email!.isNotEmpty) map['email'] = email;
    if (password != null && password!.isNotEmpty) map['password'] = password;
    if (knownLanguages != null && knownLanguages!.isNotEmpty) {
      map['knownLanguages'] = knownLanguages;
    }
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (province != null && province!.isNotEmpty) map['province'] = province;
    if (countryCode != null && countryCode!.isNotEmpty) {
      map['countryCode'] = countryCode;
    }
    if (countryName != null && countryName!.isNotEmpty) {
      map['countryName'] = countryName;
    }
    if (gender != null && gender!.isNotEmpty) map['gender'] = gender;
    if (bio != null && bio!.isNotEmpty) map['bio'] = bio;
    if (licenses != null && licenses!.isNotEmpty) {
      map['licenses'] = licenses!
          .map((l) => l is UpdateDoctorLicenseModel
              ? l.toJson()
              : UpdateDoctorLicenseModel.fromEntity(l).toJson())
          .toList();
    }
    if (petCategories != null && petCategories!.isNotEmpty) {
      map['petCategories'] = petCategories;
    }
    if (specialityObjectId != null && specialityObjectId!.isNotEmpty) {
      map['specialityObjectId'] = specialityObjectId;
    }
    if (servicesOffered != null && servicesOffered!.isNotEmpty) {
      map['servicesOffered'] = servicesOffered;
    }
    if (timeZone != null && timeZone!.isNotEmpty) map['timeZone'] = timeZone;
    if (availableDays != null && availableDays!.isNotEmpty) {
      map['availableDays'] = availableDays!
          .map((d) => d is UpdateDoctorAvailableDayModel
              ? d.toJson()
              : UpdateDoctorAvailableDayModel.fromEntity(d).toJson())
          .toList();
    }
    if (pricePerAppointment != null) {
      map['pricePerAppointment'] =
          pricePerAppointment is UpdateDoctorPriceModel
              ? (pricePerAppointment as UpdateDoctorPriceModel).toJson()
              : UpdateDoctorPriceModel.fromEntity(pricePerAppointment!).toJson();
    }
    return map;
  }
}
