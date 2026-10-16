import '../../domain/entities/update_service_provider_entity.dart';

class UpdateServiceProviderDegreeModel
    extends UpdateServiceProviderDegreeEntity {
  const UpdateServiceProviderDegreeModel({
    super.degreeImageDataURI,
    super.institutionTitle,
    super.degreeTitle,
    super.duration,
    super.startDate,
    super.endDate,
    super.currentlyStudyingHere,
  });

  factory UpdateServiceProviderDegreeModel.fromEntity(
    UpdateServiceProviderDegreeEntity entity,
  ) {
    return UpdateServiceProviderDegreeModel(
      degreeImageDataURI: entity.degreeImageDataURI,
      institutionTitle: entity.institutionTitle,
      degreeTitle: entity.degreeTitle,
      duration: entity.duration,
      startDate: entity.startDate,
      endDate: entity.endDate,
      currentlyStudyingHere: entity.currentlyStudyingHere,
    );
  }

  factory UpdateServiceProviderDegreeModel.fromJson(Map<String, dynamic> json) {
    return UpdateServiceProviderDegreeModel(
      degreeImageDataURI: json['degreeImageDataURI']?.toString(),
      institutionTitle: json['institutionTitle']?.toString(),
      degreeTitle: json['degreeTitle']?.toString(),
      duration: json['duration']?.toString(),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      currentlyStudyingHere: json['currentlyStudyingHere']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (degreeImageDataURI != null && degreeImageDataURI!.isNotEmpty) {
      map['degreeImageDataURI'] = degreeImageDataURI;
    }
    if (institutionTitle != null && institutionTitle!.isNotEmpty) {
      map['institutionTitle'] = institutionTitle;
    }
    if (degreeTitle != null && degreeTitle!.isNotEmpty) {
      map['degreeTitle'] = degreeTitle;
    }
    if (duration != null && duration!.isNotEmpty) {
      map['duration'] = duration;
    }
    if (startDate != null && startDate!.isNotEmpty) {
      map['startDate'] = startDate;
    }
    if (endDate != null && endDate!.isNotEmpty) {
      map['endDate'] = endDate;
    }
    if (currentlyStudyingHere != null && currentlyStudyingHere!.isNotEmpty) {
      map['currentlyStudyingHere'] = currentlyStudyingHere;
    }
    return map;
  }
}

class UpdateServiceProviderWorkExperienceModel
    extends UpdateServiceProviderWorkExperienceEntity {
  const UpdateServiceProviderWorkExperienceModel({
    super.jobImageDataURI,
    super.jobTitle,
    super.jobOrganizationTitle,
    super.jobYearsOfExperience,
    super.jobOrganizationAddress,
    super.jobStartDate,
    super.jobEndDate,
    super.jobCurrentlyWorkingHere,
  });

  factory UpdateServiceProviderWorkExperienceModel.fromEntity(
    UpdateServiceProviderWorkExperienceEntity entity,
  ) {
    return UpdateServiceProviderWorkExperienceModel(
      jobImageDataURI: entity.jobImageDataURI,
      jobTitle: entity.jobTitle,
      jobOrganizationTitle: entity.jobOrganizationTitle,
      jobYearsOfExperience: entity.jobYearsOfExperience,
      jobOrganizationAddress: entity.jobOrganizationAddress,
      jobStartDate: entity.jobStartDate,
      jobEndDate: entity.jobEndDate,
      jobCurrentlyWorkingHere: entity.jobCurrentlyWorkingHere,
    );
  }

  factory UpdateServiceProviderWorkExperienceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateServiceProviderWorkExperienceModel(
      jobImageDataURI: json['jobImageDataURI']?.toString(),
      jobTitle: json['jobTitle']?.toString(),
      jobOrganizationTitle: json['jobOrganizationTitle']?.toString(),
      jobYearsOfExperience: json['jobYearsOfExperience']?.toString(),
      jobOrganizationAddress: json['jobOrganizationAddress']?.toString(),
      jobStartDate: json['jobStartDate']?.toString(),
      jobEndDate: json['jobEndDate']?.toString(),
      jobCurrentlyWorkingHere: json['jobCurrentlyWorkingHere']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (jobImageDataURI != null && jobImageDataURI!.isNotEmpty) {
      map['jobImageDataURI'] = jobImageDataURI;
    }
    if (jobTitle != null && jobTitle!.isNotEmpty) {
      map['jobTitle'] = jobTitle;
    }
    if (jobOrganizationTitle != null && jobOrganizationTitle!.isNotEmpty) {
      map['jobOrganizationTitle'] = jobOrganizationTitle;
    }
    if (jobYearsOfExperience != null && jobYearsOfExperience!.isNotEmpty) {
      map['jobYearsOfExperience'] = jobYearsOfExperience;
    }
    if (jobOrganizationAddress != null && jobOrganizationAddress!.isNotEmpty) {
      map['jobOrganizationAddress'] = jobOrganizationAddress;
    }
    if (jobStartDate != null && jobStartDate!.isNotEmpty) {
      map['jobStartDate'] = jobStartDate;
    }
    if (jobEndDate != null && jobEndDate!.isNotEmpty) {
      map['jobEndDate'] = jobEndDate;
    }
    if (jobCurrentlyWorkingHere != null && jobCurrentlyWorkingHere!.isNotEmpty) {
      map['jobCurrentlyWorkingHere'] = jobCurrentlyWorkingHere;
    }
    return map;
  }
}

class UpdateServiceProviderLicenseModel
    extends UpdateServiceProviderLicenseEntity {
  const UpdateServiceProviderLicenseModel({
    super.licenseImageDataURI,
    super.state,
    super.stateAbbreviation,
    super.licenseNumber,
    super.licenseExpiryDate,
  });

  factory UpdateServiceProviderLicenseModel.fromEntity(
    UpdateServiceProviderLicenseEntity entity,
  ) {
    return UpdateServiceProviderLicenseModel(
      licenseImageDataURI: entity.licenseImageDataURI,
      state: entity.state,
      stateAbbreviation: entity.stateAbbreviation,
      licenseNumber: entity.licenseNumber,
      licenseExpiryDate: entity.licenseExpiryDate,
    );
  }

  factory UpdateServiceProviderLicenseModel.fromJson(Map<String, dynamic> json) {
    return UpdateServiceProviderLicenseModel(
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

class UpdateServiceProviderAvailableDayModel
    extends UpdateServiceProviderAvailableDayEntity {
  const UpdateServiceProviderAvailableDayModel({
    super.isAvailable,
    super.openTime,
    super.closeTime,
    super.open,
    super.close,
  });

  factory UpdateServiceProviderAvailableDayModel.fromEntity(
    UpdateServiceProviderAvailableDayEntity entity,
  ) {
    return UpdateServiceProviderAvailableDayModel(
      isAvailable: entity.isAvailable,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      open: entity.open,
      close: entity.close,
    );
  }

  factory UpdateServiceProviderAvailableDayModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateServiceProviderAvailableDayModel(
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
    if (closeTime != null && closeTime!.isNotEmpty) {
      map['closeTime'] = closeTime;
    }
    if (open != null && open!.isNotEmpty) map['open'] = open;
    if (close != null && close!.isNotEmpty) map['close'] = close;
    return map;
  }
}

class UpdateServiceProviderPriceModel
    extends UpdateServiceProviderPriceEntity {
  const UpdateServiceProviderPriceModel({
    super.price,
    super.currencyCode,
  });

  factory UpdateServiceProviderPriceModel.fromEntity(
    UpdateServiceProviderPriceEntity entity,
  ) {
    return UpdateServiceProviderPriceModel(
      price: entity.price,
      currencyCode: entity.currencyCode,
    );
  }

  factory UpdateServiceProviderPriceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateServiceProviderPriceModel(
      price: json['price'] as num?,
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

class UpdateServiceProviderModel extends UpdateServiceProviderEntity {
  const UpdateServiceProviderModel({
    super.profileImageDataURI,
    super.businessImageDataURI,
    super.designation,
    super.fullName,
    super.email,
    super.phone,
    super.countryCode,
    super.countryName,
    super.gender,
    super.password,
    super.address,
    super.city,
    super.province,
    super.businessName,
    super.businessEmail,
    super.businessPhone,
    super.latitude,
    super.longitude,
    super.businessZIPCode,
    super.degrees,
    super.licenses,
    super.workExperiences,
    super.petCategories,
    super.specialityObjectId,
    super.servicesOffered,
    super.otherService,
    super.bio,
    super.timeZone,
    super.knownLanguages,
    super.availableDays,
    super.serviceLocations,
    super.startingPricePerAppointment,
    super.pricePerAppointment,
  });

  factory UpdateServiceProviderModel.fromEntity(
    UpdateServiceProviderEntity entity,
  ) {
    return UpdateServiceProviderModel(
      profileImageDataURI: entity.profileImageDataURI,
      businessImageDataURI: entity.businessImageDataURI,
      designation: entity.designation,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
      gender: entity.gender,
      password: entity.password,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      businessName: entity.businessName,
      businessEmail: entity.businessEmail,
      businessPhone: entity.businessPhone,
      latitude: entity.latitude,
      longitude: entity.longitude,
      businessZIPCode: entity.businessZIPCode,
      degrees: entity.degrees
          ?.map((d) => UpdateServiceProviderDegreeModel.fromEntity(d))
          .toList(),
      licenses: entity.licenses
          ?.map((l) => UpdateServiceProviderLicenseModel.fromEntity(l))
          .toList(),
      workExperiences: entity.workExperiences
          ?.map((w) => UpdateServiceProviderWorkExperienceModel.fromEntity(w))
          .toList(),
      petCategories: entity.petCategories != null
          ? List<String>.from(entity.petCategories!)
          : null,
      specialityObjectId: entity.specialityObjectId,
      servicesOffered: entity.servicesOffered != null
          ? List<String>.from(entity.servicesOffered!)
          : null,
      otherService: entity.otherService,
      bio: entity.bio,
      timeZone: entity.timeZone,
      knownLanguages: entity.knownLanguages != null
          ? List<String>.from(entity.knownLanguages!)
          : null,
      availableDays: entity.availableDays
          ?.map((d) => UpdateServiceProviderAvailableDayModel.fromEntity(d))
          .toList(),
      serviceLocations: entity.serviceLocations != null
          ? List<String>.from(entity.serviceLocations!)
          : null,
      startingPricePerAppointment: entity.startingPricePerAppointment != null
          ? UpdateServiceProviderPriceModel.fromEntity(
              entity.startingPricePerAppointment!,
            )
          : null,
      pricePerAppointment: entity.pricePerAppointment != null
          ? UpdateServiceProviderPriceModel.fromEntity(
              entity.pricePerAppointment!,
            )
          : null,
    );
  }

  factory UpdateServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return UpdateServiceProviderModel(
      profileImageDataURI: json['profileImageDataURI']?.toString(),
      businessImageDataURI: json['businessImageDataURI']?.toString(),
      designation: json['designation']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      gender: json['gender']?.toString(),
      password: json['password']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      businessName: json['businessName']?.toString(),
      businessEmail: json['businessEmail']?.toString(),
      businessPhone: json['businessPhone']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      businessZIPCode: json['businessZIPCode'],
      degrees: (json['degrees'] as List<dynamic>?)
          ?.map(
            (e) => UpdateServiceProviderDegreeModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      licenses: (json['licenses'] as List<dynamic>?)
          ?.map(
            (e) => UpdateServiceProviderLicenseModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      workExperiences: (json['workExperiences'] as List<dynamic>?)
          ?.map(
            (e) => UpdateServiceProviderWorkExperienceModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      petCategories: (json['petCategories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      specialityObjectId: json['specialityObjectId']?.toString(),
      servicesOffered: (json['servicesOffered'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      otherService: json['otherService']?.toString(),
      bio: json['bio']?.toString(),
      timeZone: json['timeZone']?.toString(),
      knownLanguages: (json['knownLanguages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.map(
            (e) => UpdateServiceProviderAvailableDayModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      serviceLocations: (json['serviceLocations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      startingPricePerAppointment:
          json['startingPricePerAppointment'] is Map<String, dynamic>
              ? UpdateServiceProviderPriceModel.fromJson(
                  json['startingPricePerAppointment'] as Map<String, dynamic>,
                )
              : null,
      pricePerAppointment: json['pricePerAppointment'] is Map<String, dynamic>
          ? UpdateServiceProviderPriceModel.fromJson(
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
    if (businessImageDataURI != null && businessImageDataURI!.isNotEmpty) {
      map['businessImageDataURI'] = businessImageDataURI;
    }
    if (designation != null && designation!.isNotEmpty) {
      map['designation'] = designation;
    }
    if (fullName != null && fullName!.isNotEmpty) map['fullName'] = fullName;
    if (email != null && email!.isNotEmpty) map['email'] = email;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (countryCode != null && countryCode!.isNotEmpty) {
      map['countryCode'] = countryCode;
    }
    if (countryName != null && countryName!.isNotEmpty) {
      map['countryName'] = countryName;
    }
    if (gender != null && gender!.isNotEmpty) map['gender'] = gender;
    if (password != null && password!.isNotEmpty) map['password'] = password;
    if (address != null && address!.isNotEmpty) map['address'] = address;
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (province != null && province!.isNotEmpty) map['province'] = province;
    if (businessName != null && businessName!.isNotEmpty) {
      map['businessName'] = businessName;
    }
    if (businessEmail != null && businessEmail!.isNotEmpty) {
      map['businessEmail'] = businessEmail;
    }
    if (businessPhone != null && businessPhone!.isNotEmpty) {
      map['businessPhone'] = businessPhone;
    }
    if (latitude != null && latitude!.isNotEmpty) map['latitude'] = latitude;
    if (longitude != null && longitude!.isNotEmpty) {
      map['longitude'] = longitude;
    }
    if (businessZIPCode != null) {
      if (businessZIPCode is int) {
        map['businessZIPCode'] = businessZIPCode;
      } else if (int.tryParse(businessZIPCode.toString()) != null) {
        map['businessZIPCode'] = int.parse(businessZIPCode.toString());
      } else {
        map['businessZIPCode'] = businessZIPCode;
      }
    }
    if (degrees != null && degrees!.isNotEmpty) {
      map['degrees'] = degrees!
          .map(
            (d) => d is UpdateServiceProviderDegreeModel
                ? d.toJson()
                : UpdateServiceProviderDegreeModel.fromEntity(d).toJson(),
          )
          .toList();
    }
    if (licenses != null && licenses!.isNotEmpty) {
      map['licenses'] = licenses!
          .map(
            (l) => l is UpdateServiceProviderLicenseModel
                ? l.toJson()
                : UpdateServiceProviderLicenseModel.fromEntity(l).toJson(),
          )
          .toList();
    }
    if (workExperiences != null && workExperiences!.isNotEmpty) {
      map['workExperiences'] = workExperiences!
          .map(
            (w) => w is UpdateServiceProviderWorkExperienceModel
                ? w.toJson()
                : UpdateServiceProviderWorkExperienceModel.fromEntity(w).toJson(),
          )
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
    if (otherService != null && otherService!.isNotEmpty) {
      map['otherService'] = otherService;
    }
    if (bio != null && bio!.isNotEmpty) map['bio'] = bio;
    if (timeZone != null && timeZone!.isNotEmpty) map['timeZone'] = timeZone;
    if (knownLanguages != null && knownLanguages!.isNotEmpty) {
      map['knownLanguages'] = knownLanguages;
    }
    if (availableDays != null && availableDays!.isNotEmpty) {
      map['availableDays'] = availableDays!
          .map(
            (d) => d is UpdateServiceProviderAvailableDayModel
                ? d.toJson()
                : UpdateServiceProviderAvailableDayModel.fromEntity(d).toJson(),
          )
          .toList();
    }
    if (serviceLocations != null && serviceLocations!.isNotEmpty) {
      map['serviceLocations'] = serviceLocations;
    }
    if (startingPricePerAppointment != null) {
      map['startingPricePerAppointment'] =
          startingPricePerAppointment is UpdateServiceProviderPriceModel
              ? (startingPricePerAppointment as UpdateServiceProviderPriceModel)
                  .toJson()
              : UpdateServiceProviderPriceModel.fromEntity(
                  startingPricePerAppointment!,
                ).toJson();
    }
    if (pricePerAppointment != null) {
      map['pricePerAppointment'] =
          pricePerAppointment is UpdateServiceProviderPriceModel
              ? (pricePerAppointment as UpdateServiceProviderPriceModel)
                  .toJson()
              : UpdateServiceProviderPriceModel.fromEntity(
                  pricePerAppointment!,
                ).toJson();
    }
    return map;
  }
}
