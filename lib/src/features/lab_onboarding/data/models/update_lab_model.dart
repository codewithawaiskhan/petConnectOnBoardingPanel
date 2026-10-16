import '../../domain/entities/update_lab_entity.dart';

class UpdateLabLicenseModel extends UpdateLabLicenseEntity {
  const UpdateLabLicenseModel({
    super.licenseImageDataURI,
    super.state,
    super.stateAbbreviation,
    super.licenseNumber,
    super.licenseExpiryDate,
  });

  factory UpdateLabLicenseModel.fromEntity(UpdateLabLicenseEntity entity) {
    return UpdateLabLicenseModel(
      licenseImageDataURI: entity.licenseImageDataURI,
      state: entity.state,
      stateAbbreviation: entity.stateAbbreviation,
      licenseNumber: entity.licenseNumber,
      licenseExpiryDate: entity.licenseExpiryDate,
    );
  }

  factory UpdateLabLicenseModel.fromJson(Map<String, dynamic> json) {
    return UpdateLabLicenseModel(
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

class UpdateLabAvailableDayModel extends UpdateLabAvailableDayEntity {
  const UpdateLabAvailableDayModel({
    super.isAvailable,
    super.openTime,
    super.closeTime,
    super.open,
    super.close,
  });

  factory UpdateLabAvailableDayModel.fromEntity(
    UpdateLabAvailableDayEntity entity,
  ) {
    return UpdateLabAvailableDayModel(
      isAvailable: entity.isAvailable,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      open: entity.open,
      close: entity.close,
    );
  }

  factory UpdateLabAvailableDayModel.fromJson(Map<String, dynamic> json) {
    return UpdateLabAvailableDayModel(
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

class UpdateLabModel extends UpdateLabEntity {
  const UpdateLabModel({
    super.profileImageDataURI,
    super.designation,
    super.fullName,
    super.email,
    super.phone,
    super.countryCode,
    super.countryName,
    super.password,
    super.title,
    super.businessEmail,
    super.businessPhone,
    super.labType,
    super.address,
    super.city,
    super.province,
    super.latitude,
    super.longitude,
    super.zipCode,
    super.licenses,
    super.petCategories,
    super.labTestCategories,
    super.otherCategory,
    super.bio,
    super.timeZone,
    super.availableDays,
    super.serviceLocations,
    super.averageTurnAroundTime,
  });

  factory UpdateLabModel.fromEntity(UpdateLabEntity entity) {
    return UpdateLabModel(
      profileImageDataURI: entity.profileImageDataURI,
      designation: entity.designation,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
      password: entity.password,
      title: entity.title,
      businessEmail: entity.businessEmail,
      businessPhone: entity.businessPhone,
      labType: entity.labType,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      latitude: entity.latitude,
      longitude: entity.longitude,
      zipCode: entity.zipCode,
      licenses: entity.licenses
          ?.map((l) => UpdateLabLicenseModel.fromEntity(l))
          .toList(),
      petCategories: entity.petCategories != null
          ? List<String>.from(entity.petCategories!)
          : null,
      labTestCategories: entity.labTestCategories != null
          ? List<String>.from(entity.labTestCategories!)
          : null,
      otherCategory: entity.otherCategory,
      bio: entity.bio,
      timeZone: entity.timeZone,
      availableDays: entity.availableDays
          ?.map((d) => UpdateLabAvailableDayModel.fromEntity(d))
          .toList(),
      serviceLocations: entity.serviceLocations != null
          ? List<String>.from(entity.serviceLocations!)
          : null,
      averageTurnAroundTime: entity.averageTurnAroundTime,
    );
  }

  factory UpdateLabModel.fromJson(Map<String, dynamic> json) {
    return UpdateLabModel(
      profileImageDataURI: json['profileImageDataURI']?.toString(),
      designation: json['designation']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      password: json['password']?.toString(),
      title: json['title']?.toString(),
      businessEmail: json['businessEmail']?.toString(),
      businessPhone: json['businessPhone']?.toString(),
      labType: json['labType']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      zipCode: json['zipCode'],
      licenses: (json['licenses'] as List<dynamic>?)
          ?.map((e) => UpdateLabLicenseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      petCategories: (json['petCategories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      labTestCategories: (json['labTestCategories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      otherCategory: json['otherCategory']?.toString(),
      bio: json['bio']?.toString(),
      timeZone: json['timeZone']?.toString(),
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.map(
            (e) =>
                UpdateLabAvailableDayModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      serviceLocations: (json['serviceLocations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      averageTurnAroundTime: json['averageTurnAroundTime']?.toString(),
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
    if (email != null && email!.isNotEmpty) map['email'] = email;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (countryCode != null && countryCode!.isNotEmpty) {
      map['countryCode'] = countryCode;
    }
    if (countryName != null && countryName!.isNotEmpty) {
      map['countryName'] = countryName;
    }
    if (password != null && password!.isNotEmpty) map['password'] = password;
    if (title != null && title!.isNotEmpty) map['title'] = title;
    if (businessEmail != null && businessEmail!.isNotEmpty) {
      map['businessEmail'] = businessEmail;
    }
    if (businessPhone != null && businessPhone!.isNotEmpty) {
      map['businessPhone'] = businessPhone;
    }
    if (labType != null && labType!.isNotEmpty) map['labType'] = labType;
    if (address != null && address!.isNotEmpty) map['address'] = address;
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (province != null && province!.isNotEmpty) map['province'] = province;
    if (latitude != null && latitude!.isNotEmpty) map['latitude'] = latitude;
    if (longitude != null && longitude!.isNotEmpty) {
      map['longitude'] = longitude;
    }
    if (zipCode != null) {
      if (zipCode is int) {
        map['zipCode'] = zipCode;
      } else if (int.tryParse(zipCode.toString()) != null) {
        map['zipCode'] = int.parse(zipCode.toString());
      } else {
        map['zipCode'] = zipCode;
      }
    }
    if (licenses != null && licenses!.isNotEmpty) {
      map['licenses'] = licenses!
          .map(
            (l) => l is UpdateLabLicenseModel
                ? l.toJson()
                : UpdateLabLicenseModel.fromEntity(l).toJson(),
          )
          .toList();
    }
    if (petCategories != null && petCategories!.isNotEmpty) {
      map['petCategories'] = petCategories;
    }
    if (labTestCategories != null && labTestCategories!.isNotEmpty) {
      map['labTestCategories'] = labTestCategories;
    }
    if (otherCategory != null && otherCategory!.isNotEmpty) {
      map['otherCategory'] = otherCategory;
    }
    if (bio != null && bio!.isNotEmpty) map['bio'] = bio;
    if (timeZone != null && timeZone!.isNotEmpty) map['timeZone'] = timeZone;
    if (availableDays != null && availableDays!.isNotEmpty) {
      map['availableDays'] = availableDays!
          .map(
            (d) => d is UpdateLabAvailableDayModel
                ? d.toJson()
                : UpdateLabAvailableDayModel.fromEntity(d).toJson(),
          )
          .toList();
    }
    if (serviceLocations != null && serviceLocations!.isNotEmpty) {
      map['serviceLocations'] = serviceLocations;
    }
    if (averageTurnAroundTime != null && averageTurnAroundTime!.isNotEmpty) {
      map['averageTurnAroundTime'] = averageTurnAroundTime;
    }
    return map;
  }
}
