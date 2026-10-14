import '../../domain/entities/doctor_list_entity.dart';
import 'doctor_onboarding_model.dart';

class DoctorUserModel extends DoctorUserEntity {
  const DoctorUserModel({
    required super.id,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory DoctorUserModel.fromJson(Map<String, dynamic> json) {
    return DoctorUserModel(
      id: json['_id']?.toString() ?? '',
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'image': image,
    'status': status,
    'roles': roles,
  };
}

class DoctorPriceModel extends DoctorPriceEntity {
  const DoctorPriceModel({super.price, super.currencyCode});

  factory DoctorPriceModel.fromJson(Map<String, dynamic> json) {
    return DoctorPriceModel(
      price: json['price'] as num?,
      currencyCode: json['currencyCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'currencyCode': currencyCode,
  };
}

class DoctorSpecialityItemModel extends DoctorSpecialityItemEntity {
  const DoctorSpecialityItemModel({
    required super.id,
    required super.title,
    super.image,
    super.status,
  });

  factory DoctorSpecialityItemModel.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialityItemModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'image': image,
    'status': status,
  };
}

class DoctorServiceItemModel extends DoctorServiceItemEntity {
  const DoctorServiceItemModel({
    required super.id,
    super.serviceId,
    super.serviceName,
    super.status,
  });

  factory DoctorServiceItemModel.fromJson(Map<String, dynamic> json) {
    String? serviceId;
    String? serviceName;

    final rawService = json['service'];
    if (rawService is Map<String, dynamic>) {
      serviceId = rawService['_id']?.toString();
      serviceName =
          rawService['title']?.toString() ??
          rawService['name']?.toString() ??
          rawService['service']?.toString();
    } else if (rawService != null) {
      serviceId = rawService.toString();
    }

    serviceName ??= json['title']?.toString() ?? json['name']?.toString();

    return DoctorServiceItemModel(
      id: json['_id']?.toString() ?? '',
      serviceId: serviceId,
      serviceName: serviceName,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'status': status,
  };
}

class DoctorClinicItemModel extends DoctorClinicItemEntity {
  const DoctorClinicItemModel({
    required super.id,
    super.title,
    super.address,
    super.city,
    super.province,
    super.countryName,
    super.phone,
    super.status,
    super.image,
  });

  factory DoctorClinicItemModel.fromDynamic(dynamic item) {
    if (item is Map<String, dynamic>) {
      return DoctorClinicItemModel(
        id: item['_id']?.toString() ?? '',
        title: item['title']?.toString() ?? item['name']?.toString(),
        address: item['address']?.toString(),
        city: item['city']?.toString(),
        province: item['province']?.toString(),
        countryName: item['countryName']?.toString(),
        phone: item['phone']?.toString(),
        status: item['status']?.toString(),
        image: item['image']?.toString(),
      );
    }
    return DoctorClinicItemModel(id: item?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'address': address,
    'city': city,
    'province': province,
    'countryName': countryName,
    'phone': phone,
    'status': status,
    'image': image,
  };
}

class DoctorLicenseItemModel extends DoctorLicenseItemEntity {
  const DoctorLicenseItemModel({
    super.id,
    super.state,
    super.stateAbbreviation,
    super.number,
    super.image,
    super.expiryDate,
  });

  factory DoctorLicenseItemModel.fromJson(Map<String, dynamic> json) {
    return DoctorLicenseItemModel(
      id: json['_id']?.toString(),
      state: json['state']?.toString(),
      stateAbbreviation: json['stateAbbreviation']?.toString(),
      number: json['number']?.toString(),
      image: json['image']?.toString(),
      expiryDate: json['expiryDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'state': state,
    'stateAbbreviation': stateAbbreviation,
    'number': number,
    'image': image,
    'expiryDate': expiryDate,
  };
}

class DoctorItemModel extends DoctorItemEntity {
  const DoctorItemModel({
    required super.id,
    super.autoIncrementId,
    super.longAutoIncrementId,
    super.slug,
    super.user,
    super.gender,
    super.bio,
    required super.fullName,
    super.displayName,
    super.designation,
    super.doctorCategory,
    required super.email,
    super.phone,
    super.city,
    super.province,
    super.countryCode,
    super.countryName,
    super.starsSum,
    super.totalReviews,
    super.averageRating,
    super.favourites,
    super.appointmentsCompleted,
    super.yearsOfWorkExperience,
    super.knownLanguages = const [],
    super.wallet,
    required super.status,
    super.statusChangeReason,
    super.specialitiesStatus,
    super.specialitiesStatusChangeReason,
    super.specialities = const [],
    super.clinics = const [],
    super.petCategories = const [],
    super.services = const [],
    super.licenses = const [],
    super.availableDays = const [],
    super.pricePerAppointment,
    super.timeZone,
    super.createdAt,
    super.updatedAt,
  });

  factory DoctorItemModel.fromJson(Map<String, dynamic> json) {
    final resolvedStatus =
        json['status']?.toString() ??
        (json['user'] is Map<String, dynamic> &&
                (json['user'] as Map<String, dynamic>)['status']
                        ?.toString()
                        .toLowerCase() ==
                    'active'
            ? 'Approved'
            : (json['user'] is Map<String, dynamic>
                  ? (json['user'] as Map<String, dynamic>)['status']?.toString()
                  : null)) ??
        json['specialitiesStatus']?.toString() ??
        'Approved';

    return DoctorItemModel(
      id: json['_id']?.toString() ?? '',
      autoIncrementId: json['autoIncrementId'] is int
          ? json['autoIncrementId'] as int
          : int.tryParse(json['autoIncrementId']?.toString() ?? ''),
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      slug: json['slug']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? DoctorUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      gender: json['gender']?.toString(),
      bio: json['bio']?.toString(),
      fullName: json['fullName']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
      designation: json['designation']?.toString(),
      doctorCategory: json['doctorCategory']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      starsSum: json['starsSum'] as num?,
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews'] as int
          : int.tryParse(json['totalReviews']?.toString() ?? ''),
      averageRating: json['averageRating'] as num?,
      favourites: json['favourites'] is int
          ? json['favourites'] as int
          : int.tryParse(json['favourites']?.toString() ?? ''),
      appointmentsCompleted: json['appointmentsCompleted'] is int
          ? json['appointmentsCompleted'] as int
          : int.tryParse(json['appointmentsCompleted']?.toString() ?? ''),
      yearsOfWorkExperience: json['yearsOfWorkExperience'] is int
          ? json['yearsOfWorkExperience'] as int
          : int.tryParse(json['yearsOfWorkExperience']?.toString() ?? ''),
      knownLanguages:
          (json['knownLanguages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      wallet: json['wallet']?.toString(),
      status: resolvedStatus,
      statusChangeReason: json['statusChangeReason']?.toString(),
      specialitiesStatus: json['specialitiesStatus']?.toString(),
      specialitiesStatusChangeReason: json['specialitiesStatusChangeReason']
          ?.toString(),
      specialities:
          (json['specialities'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<DoctorSpecialityItemEntity>(
                (e) => DoctorSpecialityItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      clinics:
          (json['clinics'] as List<dynamic>?)
              ?.map<DoctorClinicItemEntity>(
                (e) => DoctorClinicItemModel.fromDynamic(e),
              )
              .toList() ??
          const [],
      petCategories:
          (json['petCategories'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? (e['title']?.toString() ?? e['_id']?.toString() ?? '')
                    : e.toString(),
              )
              .toList() ??
          const [],
      services:
          (json['services'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<DoctorServiceItemEntity>(
                (e) => DoctorServiceItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      licenses:
          (json['licenses'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<DoctorLicenseItemEntity>(
                (e) => DoctorLicenseItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      availableDays:
          (json['availableDays'] is List)
              ? (json['availableDays'] as List)
                  .asMap()
                  .entries
                  .map<AvailableDayModel>(
                    (entry) => AvailableDayModel.fromJson(
                      entry.value is Map<String, dynamic>
                          ? entry.value as Map<String, dynamic>
                          : <String, dynamic>{},
                      entry.key,
                    ),
                  )
                  .toList()
              : const [],
      pricePerAppointment: json['pricePerAppointment'] is Map<String, dynamic>
          ? DoctorPriceModel.fromJson(
              json['pricePerAppointment'] as Map<String, dynamic>,
            )
          : null,
      timeZone: json['timeZone']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class DoctorListResponseModel extends DoctorListResponseEntity {
  const DoctorListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.pages,
    required super.page,
  });

  factory DoctorListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawDocs = data['docs'] as List<dynamic>? ?? [];

    final List<DoctorItemEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<DoctorItemEntity>((e) => DoctorItemModel.fromJson(e))
        .toList();

    return DoctorListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: data['docsCount'] is int
          ? data['docsCount'] as int
          : int.tryParse(data['docsCount']?.toString() ?? '0') ??
                parsedDocs.length,
      pages: data['pages'] is int
          ? data['pages'] as int
          : int.tryParse(data['pages']?.toString() ?? '1') ?? 1,
      page: data['page'] is int
          ? data['page'] as int
          : int.tryParse(data['page']?.toString() ?? '1') ?? 1,
    );
  }
}

class DoctorDetailResponseModel extends DoctorDetailResponseEntity {
  const DoctorDetailResponseModel({
    required super.success,
    required super.message,
    super.doctor,
  });

  factory DoctorDetailResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? docMap;
    String msg = '';

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      msg = data['message']?.toString() ?? '';
      if (data['doc'] is Map<String, dynamic>) {
        docMap = data['doc'] as Map<String, dynamic>;
      } else if (data['_id'] != null || data['fullName'] != null) {
        docMap = data;
      }
    } else if (json['doc'] is Map<String, dynamic>) {
      docMap = json['doc'] as Map<String, dynamic>;
    } else if (json['_id'] != null || json['fullName'] != null) {
      docMap = json;
    }

    if (msg.isEmpty) {
      msg = json['message']?.toString() ?? '';
    }

    return DoctorDetailResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
      doctor: docMap != null ? DoctorItemModel.fromJson(docMap) : null,
    );
  }
}
