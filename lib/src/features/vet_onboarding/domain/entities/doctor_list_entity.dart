import 'doctor_onboarding_entity.dart';

class DoctorUserEntity {
  final String id;
  final String? image;
  final String? status;
  final List<String> roles;

  const DoctorUserEntity({
    required this.id,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class DoctorPriceEntity {
  final num? price;
  final String? currencyCode;

  const DoctorPriceEntity({this.price, this.currencyCode});
}

class DoctorSpecialityItemEntity {
  final String id;
  final String title;
  final String? image;
  final String? status;

  const DoctorSpecialityItemEntity({
    required this.id,
    required this.title,
    this.image,
    this.status,
  });
}

class DoctorServiceItemEntity {
  final String id;
  final String? serviceId;
  final String? serviceName;
  final String? status;

  const DoctorServiceItemEntity({
    required this.id,
    this.serviceId,
    this.serviceName,
    this.status,
  });
}

class DoctorClinicItemEntity {
  final String id;
  final String? title;
  final String? address;
  final String? city;
  final String? province;
  final String? countryName;
  final String? phone;
  final String? status;
  final String? image;

  const DoctorClinicItemEntity({
    required this.id,
    this.title,
    this.address,
    this.city,
    this.province,
    this.countryName,
    this.phone,
    this.status,
    this.image,
  });
}

class DoctorLicenseItemEntity {
  final String? id;
  final String? state;
  final String? stateAbbreviation;
  final String? number;
  final String? image;
  final String? expiryDate;

  const DoctorLicenseItemEntity({
    this.id,
    this.state,
    this.stateAbbreviation,
    this.number,
    this.image,
    this.expiryDate,
  });
}

class DoctorItemEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final String? slug;
  final DoctorUserEntity? user;
  final String? gender;
  final String? bio;
  final String fullName;
  final String? displayName;
  final String? designation;
  final String? doctorCategory;
  final String email;
  final String? phone;
  final String? city;
  final String? province;
  final String? countryCode;
  final String? countryName;
  final num? starsSum;
  final int? totalReviews;
  final num? averageRating;
  final int? favourites;
  final int? appointmentsCompleted;
  final int? yearsOfWorkExperience;
  final List<String> knownLanguages;
  final String? wallet;
  final String status;
  final String? statusChangeReason;
  final String? specialitiesStatus;
  final String? specialitiesStatusChangeReason;
  final List<DoctorSpecialityItemEntity> specialities;
  final List<DoctorClinicItemEntity> clinics;
  final List<String> petCategories;
  final List<DoctorServiceItemEntity> services;
  final List<DoctorLicenseItemEntity> licenses;
  final List<AvailableDayEntity> availableDays;
  final DoctorPriceEntity? pricePerAppointment;
  final String? timeZone;
  final String? createdAt;
  final String? updatedAt;

  const DoctorItemEntity({
    required this.id,
    this.autoIncrementId,
    this.longAutoIncrementId,
    this.slug,
    this.user,
    this.gender,
    this.bio,
    required this.fullName,
    this.displayName,
    this.designation,
    this.doctorCategory,
    required this.email,
    this.phone,
    this.city,
    this.province,
    this.countryCode,
    this.countryName,
    this.starsSum,
    this.totalReviews,
    this.averageRating,
    this.favourites,
    this.appointmentsCompleted,
    this.yearsOfWorkExperience,
    this.knownLanguages = const [],
    this.wallet,
    required this.status,
    this.statusChangeReason,
    this.specialitiesStatus,
    this.specialitiesStatusChangeReason,
    this.specialities = const [],
    this.clinics = const [],
    this.petCategories = const [],
    this.services = const [],
    this.licenses = const [],
    this.availableDays = const [],
    this.pricePerAppointment,
    this.timeZone,
    this.createdAt,
    this.updatedAt,
  });
}

class DoctorListResponseEntity {
  final bool success;
  final String message;
  final List<DoctorItemEntity> docs;
  final int docsCount;
  final int pages;
  final int page;

  const DoctorListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.pages,
    required this.page,
  });
}

class DoctorDetailResponseEntity {
  final bool success;
  final String message;
  final DoctorItemEntity? doctor;

  const DoctorDetailResponseEntity({
    required this.success,
    required this.message,
    this.doctor,
  });
}
