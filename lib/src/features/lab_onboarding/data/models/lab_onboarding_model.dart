import '../../domain/entities/lab_onboarding_entity.dart';

class LabOnboardingLicenseModel extends LabOnboardingLicenseEntity {
  const LabOnboardingLicenseModel({
    required super.licenseImageDataURI,
    required super.state,
    super.stateAbbreviation,
    required super.licenseNumber,
    super.licenseExpiryDate,
  });

  factory LabOnboardingLicenseModel.fromEntity(
    LabOnboardingLicenseEntity entity,
  ) {
    return LabOnboardingLicenseModel(
      licenseImageDataURI: entity.licenseImageDataURI,
      state: entity.state,
      stateAbbreviation: entity.stateAbbreviation,
      licenseNumber: entity.licenseNumber,
      licenseExpiryDate: entity.licenseExpiryDate,
    );
  }

  factory LabOnboardingLicenseModel.fromJson(Map<String, dynamic> json) {
    return LabOnboardingLicenseModel(
      licenseImageDataURI: json['image']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      stateAbbreviation: json['stateAbbreviation']?.toString(),
      licenseNumber: json['number']?.toString() ?? '',
      licenseExpiryDate: json['expiryDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'licenseImageDataURI': licenseImageDataURI,
    'state': state,
    if (stateAbbreviation != null) 'stateAbbreviation': stateAbbreviation,
    'licenseNumber': licenseNumber,
    if (licenseExpiryDate != null) 'licenseExpiryDate': licenseExpiryDate,
  };
}

class LabOnboardingAvailableDayModel extends LabOnboardingAvailableDayEntity {
  const LabOnboardingAvailableDayModel({
    required super.dayIndex,
    required super.isAvailable,
    super.openTime,
    super.closeTime,
  });

  factory LabOnboardingAvailableDayModel.fromEntity(
    LabOnboardingAvailableDayEntity entity,
  ) {
    return LabOnboardingAvailableDayModel(
      dayIndex: entity.dayIndex,
      isAvailable: entity.isAvailable,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
    );
  }

  factory LabOnboardingAvailableDayModel.fromJson(
    Map<String, dynamic> json,
    int index,
  ) {
    return LabOnboardingAvailableDayModel(
      dayIndex: json['dayIndex'] is int ? json['dayIndex'] as int : index,
      isAvailable: json['isAvailable'] == true || json['isAvailable'] == 'true',
      openTime: json['openTime']?.toString() ?? json['open']?.toString(),
      closeTime: json['closeTime']?.toString() ?? json['close']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final partsOpen = (openTime ?? '09:00').split(':');
    final openMins = partsOpen.length == 2
        ? ((int.tryParse(partsOpen[0]) ?? 0) * 60 +
                (int.tryParse(partsOpen[1]) ?? 0))
            .toString()
        : '540';
    final partsClose = (closeTime ?? '17:00').split(':');
    final closeMins = partsClose.length == 2
        ? ((int.tryParse(partsClose[0]) ?? 0) * 60 +
                (int.tryParse(partsClose[1]) ?? 0))
            .toString()
        : '1020';

    return {
      'dayIndex': dayIndex,
      'isAvailable': isAvailable,
      'openTime': isAvailable ? (openTime ?? '09:00') : '09:00',
      'closeTime': isAvailable ? (closeTime ?? '17:00') : '17:00',
      if (isAvailable) 'open': openMins,
      if (isAvailable) 'close': closeMins,
    };
  }
}

class LabOnboardingModel extends LabOnboardingEntity {
  const LabOnboardingModel({
    required super.title,
    required super.email,
    required super.phone,
    super.businessEmail,
    super.businessPhone,
    required super.countryCode,
    required super.countryName,
    required super.password,
    required super.confirmPassword,
    required super.labType,
    super.designation,
    required super.bio,
    required super.address,
    required super.city,
    super.state,
    super.province,
    required super.zipCode,
    required super.latitude,
    required super.longitude,
    required super.timeZone,
    super.serviceLocations = const [],
    super.averageTurnAroundTime,
    super.profileImageDataURI,
    required super.licenses,
    required super.petCategories,
    required super.labTestCategories,
    required super.availableDays,
  });

  factory LabOnboardingModel.fromEntity(LabOnboardingEntity entity) {
    return LabOnboardingModel(
      title: entity.title,
      email: entity.email,
      phone: entity.phone,
      businessEmail: entity.businessEmail,
      businessPhone: entity.businessPhone,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      labType: entity.labType,
      designation: entity.designation,
      bio: entity.bio,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      province: entity.province,
      zipCode: entity.zipCode,
      latitude: entity.latitude,
      longitude: entity.longitude,
      timeZone: entity.timeZone,
      serviceLocations: entity.serviceLocations,
      averageTurnAroundTime: entity.averageTurnAroundTime,
      profileImageDataURI: entity.profileImageDataURI,
      licenses: entity.licenses,
      petCategories: entity.petCategories,
      labTestCategories: entity.labTestCategories,
      availableDays: entity.availableDays,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'fullName': title,
      'email': email,
      'phone': phone,
      'businessEmail': businessEmail?.trim().isNotEmpty == true
          ? businessEmail!.trim()
          : email,
      'businessPhone': businessPhone?.trim().isNotEmpty == true
          ? businessPhone!.trim()
          : phone,
      'countryCode': countryCode,
      'countryName': countryName,
      'password': password,
      'confirmPassword': confirmPassword,
      'labType': labType,
      'bio': bio,
      'address': address,
      'city': city,
      if (province != null && province!.trim().isNotEmpty)
        'province': province!.trim()
      else if (state != null && state!.trim().isNotEmpty)
        'province': state!.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'zipCode': int.tryParse(zipCode) ?? zipCode,
      'timeZone': timeZone,
      'licenses': licenses
          .map(
            (e) => e is LabOnboardingLicenseModel
                ? e.toJson()
                : LabOnboardingLicenseModel.fromEntity(e).toJson(),
          )
          .toList(),
      'petCategories': petCategories,
      'labTestCategories': labTestCategories,
      'availableDays': availableDays
          .map(
            (e) => e is LabOnboardingAvailableDayModel
                ? e.toJson()
                : LabOnboardingAvailableDayModel.fromEntity(e).toJson(),
          )
          .toList(),
      if (serviceLocations.isNotEmpty) 'serviceLocations': serviceLocations,
      if (averageTurnAroundTime != null &&
          averageTurnAroundTime!.trim().isNotEmpty)
        'averageTurnAroundTime': averageTurnAroundTime!.trim(),
    };

    if (profileImageDataURI != null &&
        profileImageDataURI!.trim().isNotEmpty) {
      map['profileImageDataURI'] = profileImageDataURI;
    }
    if (designation != null && designation!.trim().isNotEmpty) {
      map['designation'] = designation;
    }
    return map;
  }
}

class LabDataEntryResponseModel extends LabDataEntryResponseEntity {
  const LabDataEntryResponseModel({
    required super.success,
    required super.message,
    super.labId,
    super.userId,
  });

  factory LabDataEntryResponseModel.fromJson(Map<String, dynamic> json) {
    String? labId;
    String? userId;

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      labId = data['labId']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString();
      userId = data['userId']?.toString() ??
          (data['user'] is Map ? data['user']['_id']?.toString() : null);
    }

    return LabDataEntryResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: json['message']?.toString() ?? 'Lab registered successfully',
      labId: labId,
      userId: userId,
    );
  }
}
