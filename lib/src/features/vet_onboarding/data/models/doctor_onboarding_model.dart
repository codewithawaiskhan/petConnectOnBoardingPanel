import '../../domain/entities/doctor_onboarding_entity.dart';

class DegreeModel extends DegreeEntity {
  const DegreeModel({
    required super.degreeImageDataURI,
    required super.institutionTitle,
    required super.degreeTitle,
    required super.duration,
    required super.startDate,
    super.endDate,
    super.currentlyStudyingHere,
  });

  factory DegreeModel.fromJson(Map<String, dynamic> json) {
    return DegreeModel(
      degreeImageDataURI: json['degreeImageDataURI']?.toString() ?? '',
      institutionTitle: json['institutionTitle']?.toString() ?? '',
      degreeTitle: json['degreeTitle']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString(),
      currentlyStudyingHere: json['currentlyStudyingHere']?.toString() ?? 'no',
    );
  }

  factory DegreeModel.fromEntity(DegreeEntity entity) {
    return DegreeModel(
      degreeImageDataURI: entity.degreeImageDataURI,
      institutionTitle: entity.institutionTitle,
      degreeTitle: entity.degreeTitle,
      duration: entity.duration,
      startDate: entity.startDate,
      endDate: entity.endDate,
      currentlyStudyingHere: entity.currentlyStudyingHere,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'degreeImageDataURI': degreeImageDataURI,
      'institutionTitle': institutionTitle,
      'degreeTitle': degreeTitle,
      'duration': duration,
      'startDate': startDate,
      'currentlyStudyingHere': currentlyStudyingHere,
    };
    if (endDate != null && endDate!.trim().isNotEmpty) {
      map['endDate'] = endDate;
    }
    return map;
  }
}

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.clinicImageDataURI,
    required super.title,
    required super.latitude,
    required super.longitude,
    required super.clinicPhone,
    required super.address,
    required super.city,
    required super.province,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      clinicImageDataURI: json['clinicImageDataURI']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      clinicPhone: json['clinicPhone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      province: json['province']?.toString() ?? '',
    );
  }

  factory ClinicModel.fromEntity(ClinicEntity entity) {
    return ClinicModel(
      clinicImageDataURI: entity.clinicImageDataURI,
      title: entity.title,
      latitude: entity.latitude,
      longitude: entity.longitude,
      clinicPhone: entity.clinicPhone,
      address: entity.address,
      city: entity.city,
      province: entity.province,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicImageDataURI': clinicImageDataURI,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'clinicPhone': clinicPhone,
      'address': address,
      'city': city,
      'province': province,
    };
  }
}

class LicenseModel extends LicenseEntity {
  const LicenseModel({
    required super.licenseImageDataURI,
    required super.state,
    required super.stateAbbreviation,
    required super.licenseNumber,
    required super.licenseExpiryDate,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      licenseImageDataURI: json['licenseImageDataURI']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      stateAbbreviation: json['stateAbbreviation']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      licenseExpiryDate: json['licenseExpiryDate']?.toString() ?? '',
    );
  }

  factory LicenseModel.fromEntity(LicenseEntity entity) {
    return LicenseModel(
      licenseImageDataURI: entity.licenseImageDataURI,
      state: entity.state,
      stateAbbreviation: entity.stateAbbreviation,
      licenseNumber: entity.licenseNumber,
      licenseExpiryDate: entity.licenseExpiryDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseImageDataURI': licenseImageDataURI,
      'state': state,
      'stateAbbreviation': stateAbbreviation,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate,
    };
  }
}

class WorkExperienceModel extends WorkExperienceEntity {
  const WorkExperienceModel({
    required super.jobImageDataURI,
    required super.jobTitle,
    required super.jobOrganizationTitle,
    required super.jobYearsOfExperience,
    required super.jobOrganizationAddress,
    required super.jobStartDate,
    super.jobEndDate,
    super.jobCurrentlyWorkingHere,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      jobImageDataURI: json['jobImageDataURI']?.toString() ?? '',
      jobTitle: json['jobTitle']?.toString() ?? '',
      jobOrganizationTitle: json['jobOrganizationTitle']?.toString() ?? '',
      jobYearsOfExperience: json['jobYearsOfExperience']?.toString() ?? '',
      jobOrganizationAddress: json['jobOrganizationAddress']?.toString() ?? '',
      jobStartDate: json['jobStartDate']?.toString() ?? '',
      jobEndDate: json['jobEndDate']?.toString(),
      jobCurrentlyWorkingHere: json['jobCurrentlyWorkingHere']?.toString() ?? 'no',
    );
  }

  factory WorkExperienceModel.fromEntity(WorkExperienceEntity entity) {
    return WorkExperienceModel(
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'jobImageDataURI': jobImageDataURI,
      'jobTitle': jobTitle,
      'jobOrganizationTitle': jobOrganizationTitle,
      'jobYearsOfExperience': jobYearsOfExperience,
      'jobOrganizationAddress': jobOrganizationAddress,
      'jobStartDate': jobStartDate,
      'jobCurrentlyWorkingHere': jobCurrentlyWorkingHere,
    };
    if (jobEndDate != null && jobEndDate!.trim().isNotEmpty) {
      map['jobEndDate'] = jobEndDate;
    }
    return map;
  }
}

class AvailableDayModel extends AvailableDayEntity {
  const AvailableDayModel({
    required super.dayIndex,
    required super.isAvailable,
    super.openTime,
    super.closeTime,
    super.open,
    super.close,
  });

  factory AvailableDayModel.fromJson(Map<String, dynamic> json, int dayIndex) {
    return AvailableDayModel(
      dayIndex: dayIndex,
      isAvailable: json['isAvailable'] as bool? ?? false,
      openTime: json['openTime']?.toString(),
      closeTime: json['closeTime']?.toString(),
      open: json['open']?.toString(),
      close: json['close']?.toString(),
    );
  }

  factory AvailableDayModel.fromEntity(AvailableDayEntity entity) {
    return AvailableDayModel(
      dayIndex: entity.dayIndex,
      isAvailable: entity.isAvailable,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      open: entity.open,
      close: entity.close,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'isAvailable': isAvailable,
    };
    if (openTime != null) map['openTime'] = openTime;
    if (closeTime != null) map['closeTime'] = closeTime;
    if (open != null) map['open'] = open;
    if (close != null) map['close'] = close;
    return map;
  }
}

class PricePerAppointmentModel extends PricePerAppointmentEntity {
  const PricePerAppointmentModel({
    required super.price,
    super.currencyCode,
  });

  factory PricePerAppointmentModel.fromJson(Map<String, dynamic> json) {
    return PricePerAppointmentModel(
      price: (json['price'] as num?) ?? 0,
      currencyCode: json['currencyCode']?.toString() ?? 'USD',
    );
  }

  factory PricePerAppointmentModel.fromEntity(PricePerAppointmentEntity entity) {
    return PricePerAppointmentModel(
      price: entity.price,
      currencyCode: entity.currencyCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'currencyCode': currencyCode,
    };
  }
}

class DoctorOnboardingModel extends DoctorOnboardingEntity {
  const DoctorOnboardingModel({
    super.profileImageDataURI,
    super.designation,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.countryCode,
    required super.countryName,
    required super.password,
    required super.confirmPassword,
    required super.degrees,
    required super.clinics,
    required super.licenses,
    required super.workExperiences,
    required super.petCategories,
    required super.specialityObjectId,
    required super.servicesOffered,
    required super.bio,
    required super.timeZone,
    required super.availableDays,
    required super.pricePerAppointment,
  });

  factory DoctorOnboardingModel.fromJson(Map<String, dynamic> json) {
    final degreesList = <DegreeModel>[];
    if (json['degrees'] is List) {
      for (final item in json['degrees']) {
        if (item is Map<String, dynamic>) {
          degreesList.add(DegreeModel.fromJson(item));
        }
      }
    }

    final clinicsList = <ClinicModel>[];
    if (json['clinics'] is List) {
      for (final item in json['clinics']) {
        if (item is Map<String, dynamic>) {
          clinicsList.add(ClinicModel.fromJson(item));
        }
      }
    }

    final licensesList = <LicenseModel>[];
    if (json['licenses'] is List) {
      for (final item in json['licenses']) {
        if (item is Map<String, dynamic>) {
          licensesList.add(LicenseModel.fromJson(item));
        }
      }
    }

    final experienceList = <WorkExperienceModel>[];
    if (json['workExperiences'] is List) {
      for (final item in json['workExperiences']) {
        if (item is Map<String, dynamic>) {
          experienceList.add(WorkExperienceModel.fromJson(item));
        }
      }
    }

    final petCats = <String>[];
    if (json['petCategories'] is List) {
      for (final item in json['petCategories']) {
        petCats.add(item.toString());
      }
    }

    final services = <String>[];
    if (json['servicesOffered'] is List) {
      for (final item in json['servicesOffered']) {
        services.add(item.toString());
      }
    }

    final availableDaysList = <AvailableDayModel>[];
    if (json['availableDays'] is List) {
      final list = json['availableDays'] as List;
      for (int i = 0; i < list.length; i++) {
        if (list[i] is Map<String, dynamic>) {
          availableDaysList.add(AvailableDayModel.fromJson(list[i], i));
        }
      }
    }

    final priceMap = json['pricePerAppointment'] is Map<String, dynamic>
        ? json['pricePerAppointment'] as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorOnboardingModel(
      profileImageDataURI: json['profileImageDataURI']?.toString(),
      designation: json['designation']?.toString(),
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      countryName: json['countryName']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      confirmPassword: json['confirmPassword']?.toString() ?? '',
      degrees: degreesList,
      clinics: clinicsList,
      licenses: licensesList,
      workExperiences: experienceList,
      petCategories: petCats,
      specialityObjectId: json['specialityObjectId']?.toString() ?? '',
      servicesOffered: services,
      bio: json['bio']?.toString() ?? '',
      timeZone: json['timeZone']?.toString() ?? 'America/New_York',
      availableDays: availableDaysList,
      pricePerAppointment: PricePerAppointmentModel.fromJson(priceMap),
    );
  }

  factory DoctorOnboardingModel.fromEntity(DoctorOnboardingEntity entity) {
    return DoctorOnboardingModel(
      profileImageDataURI: entity.profileImageDataURI,
      designation: entity.designation,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      degrees: entity.degrees.map<DegreeModel>((e) => DegreeModel.fromEntity(e)).toList(),
      clinics: entity.clinics.map<ClinicModel>((e) => ClinicModel.fromEntity(e)).toList(),
      licenses: entity.licenses.map<LicenseModel>((e) => LicenseModel.fromEntity(e)).toList(),
      workExperiences: entity.workExperiences.map<WorkExperienceModel>((e) => WorkExperienceModel.fromEntity(e)).toList(),
      petCategories: List<String>.from(entity.petCategories),
      specialityObjectId: entity.specialityObjectId,
      servicesOffered: List<String>.from(entity.servicesOffered),
      bio: entity.bio,
      timeZone: entity.timeZone,
      availableDays: entity.availableDays.map<AvailableDayModel>((e) => AvailableDayModel.fromEntity(e)).toList(),
      pricePerAppointment: PricePerAppointmentModel.fromEntity(entity.pricePerAppointment),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'countryCode': countryCode,
      'countryName': countryName,
      'password': password,
      'confirmPassword': confirmPassword,
      'degrees': degrees.map((e) => (e is DegreeModel ? e : DegreeModel.fromEntity(e)).toJson()).toList(),
      'clinics': clinics.map((e) => (e is ClinicModel ? e : ClinicModel.fromEntity(e)).toJson()).toList(),
      'licenses': licenses.map((e) => (e is LicenseModel ? e : LicenseModel.fromEntity(e)).toJson()).toList(),
      'workExperiences': workExperiences.map((e) => (e is WorkExperienceModel ? e : WorkExperienceModel.fromEntity(e)).toJson()).toList(),
      'petCategories': petCategories,
      'specialityObjectId': specialityObjectId,
      'servicesOffered': servicesOffered,
      'bio': bio,
      'timeZone': timeZone,
      'availableDays': availableDays.map((e) => (e is AvailableDayModel ? e : AvailableDayModel.fromEntity(e)).toJson()).toList(),
      'pricePerAppointment': (pricePerAppointment is PricePerAppointmentModel
              ? pricePerAppointment as PricePerAppointmentModel
              : PricePerAppointmentModel.fromEntity(pricePerAppointment))
          .toJson(),
    };

    if (profileImageDataURI != null && profileImageDataURI!.trim().isNotEmpty) {
      map['profileImageDataURI'] = profileImageDataURI;
    }
    if (designation != null && designation!.trim().isNotEmpty) {
      map['designation'] = designation;
    }
    return map;
  }
}

class DoctorDataEntryResponseModel extends DoctorDataEntryResponseEntity {
  const DoctorDataEntryResponseModel({
    required super.success,
    required super.message,
    super.doctorId,
    super.userId,
  });

  factory DoctorDataEntryResponseModel.fromJson(Map<String, dynamic> json) {
    String msg = 'Doctor data submitted successfully';
    String? docId;
    String? uId;

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['message'] != null) msg = data['message'].toString();
      if (data['doc'] is Map<String, dynamic>) {
        final doc = data['doc'] as Map<String, dynamic>;
        docId = doc['_id']?.toString() ?? doc['id']?.toString();
        uId = doc['user']?.toString();
      }
    } else if (json['message'] != null) {
      msg = json['message'].toString();
    }

    return DoctorDataEntryResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
      doctorId: docId,
      userId: uId,
    );
  }
}
