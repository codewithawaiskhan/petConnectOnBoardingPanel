import '../../domain/entities/service_provider_list_entity.dart';

class ServiceProviderUserModel extends ServiceProviderUserEntity {
  const ServiceProviderUserModel({
    required super.id,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory ServiceProviderUserModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderUserModel(
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

class ServiceProviderPriceModel extends ServiceProviderPriceEntity {
  const ServiceProviderPriceModel({super.price, super.currencyCode});

  factory ServiceProviderPriceModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderPriceModel(
      price: json['price'] as num?,
      currencyCode: json['currencyCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'currencyCode': currencyCode,
  };
}

class ServiceProviderLicenseItemModel extends ServiceProviderLicenseItemEntity {
  const ServiceProviderLicenseItemModel({
    super.id,
    super.state,
    super.stateAbbreviation,
    super.number,
    super.image,
    super.expiryDate,
  });

  factory ServiceProviderLicenseItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderLicenseItemModel(
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

class ServiceProviderPetCategoryItemModel
    extends ServiceProviderPetCategoryItemEntity {
  const ServiceProviderPetCategoryItemModel({
    super.id,
    super.petCategory,
    super.title,
  });

  factory ServiceProviderPetCategoryItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceProviderPetCategoryItemModel(
      id: json['_id']?.toString(),
      petCategory: json['petCategory']?.toString(),
      title: json['title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'petCategory': petCategory,
    'title': title,
  };
}

class ServiceProviderOfferedServiceItemModel
    extends ServiceProviderOfferedServiceItemEntity {
  const ServiceProviderOfferedServiceItemModel({
    super.id,
    super.serviceProviderService,
    super.title,
  });

  factory ServiceProviderOfferedServiceItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceProviderOfferedServiceItemModel(
      id: json['_id']?.toString(),
      serviceProviderService: json['serviceProviderService']?.toString(),
      title: json['title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'serviceProviderService': serviceProviderService,
    'title': title,
  };
}

class ServiceProviderItemModel extends ServiceProviderItemEntity {
  const ServiceProviderItemModel({
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
    super.address,
    super.city,
    super.province,
    super.countryCode,
    super.countryName,
    super.latitude,
    super.longitude,
    super.starsSum,
    super.totalReviews,
    super.averageRating,
    super.favourites,
    super.bookingsCompleted,
    super.yearsOfWorkExperience,
    super.knownLanguages = const [],
    super.wallet,
    required super.status,
    super.statusChangeReason,
    super.businessEmail,
    super.businessName,
    super.businessZIPCode,
    super.businessPhone,
    required super.email,
    super.phone,
    super.businessImage,
    super.timeZone,
    super.pricePerAppointment,
    super.startingPricePerAppointment,
    super.licenses = const [],
    super.petCategories = const [],
    super.serviceLocations = const [],
    super.servicesOffered = const [],
    super.otherService,
    super.createdAt,
    super.updatedAt,
  });

  factory ServiceProviderItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderItemModel(
      id: json['_id']?.toString() ?? '',
      autoIncrementId: json['autoIncrementId'] is int
          ? json['autoIncrementId'] as int
          : int.tryParse(json['autoIncrementId']?.toString() ?? ''),
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      slug: json['slug']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? ServiceProviderUserModel.fromJson(
              json['user'] as Map<String, dynamic>,
            )
          : null,
      gender: json['gender']?.toString(),
      bio: json['bio']?.toString(),
      fullName: json['fullName']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
      designation: json['designation']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      starsSum: json['starsSum'] as num?,
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews'] as int
          : int.tryParse(json['totalReviews']?.toString() ?? ''),
      averageRating: json['averageRating'] as num?,
      favourites: json['favourites'] is int
          ? json['favourites'] as int
          : int.tryParse(json['favourites']?.toString() ?? ''),
      bookingsCompleted: json['bookingsCompleted'] is int
          ? json['bookingsCompleted'] as int
          : int.tryParse(json['bookingsCompleted']?.toString() ?? ''),
      yearsOfWorkExperience: json['yearsOfWorkExperience'] is int
          ? json['yearsOfWorkExperience'] as int
          : int.tryParse(json['yearsOfWorkExperience']?.toString() ?? ''),
      knownLanguages:
          (json['knownLanguages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      wallet: json['wallet']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      statusChangeReason: json['statusChangeReason']?.toString(),
      businessEmail: json['businessEmail']?.toString(),
      businessName: json['businessName']?.toString(),
      businessZIPCode: json['businessZIPCode'],
      businessPhone: json['businessPhone']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      businessImage: json['businessImage']?.toString(),
      timeZone: json['timeZone']?.toString(),
      pricePerAppointment: json['pricePerAppointment'] is Map<String, dynamic>
          ? ServiceProviderPriceModel.fromJson(
              json['pricePerAppointment'] as Map<String, dynamic>,
            )
          : null,
      startingPricePerAppointment:
          json['startingPricePerAppointment'] is Map<String, dynamic>
          ? ServiceProviderPriceModel.fromJson(
              json['startingPricePerAppointment'] as Map<String, dynamic>,
            )
          : null,
      licenses:
          (json['licenses'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<ServiceProviderLicenseItemEntity>(
                (e) => ServiceProviderLicenseItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      petCategories:
          (json['petCategories'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<ServiceProviderPetCategoryItemEntity>(
                (e) => ServiceProviderPetCategoryItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      serviceLocations:
          (json['serviceLocations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      servicesOffered:
          (json['servicesOffered'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map<ServiceProviderOfferedServiceItemEntity>(
                (e) => ServiceProviderOfferedServiceItemModel.fromJson(e),
              )
              .toList() ??
          const [],
      otherService: json['otherService']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class ServiceProviderListResponseModel
    extends ServiceProviderListResponseEntity {
  const ServiceProviderListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.pages,
    required super.page,
  });

  factory ServiceProviderListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawDocs = data['docs'] as List<dynamic>? ?? [];

    final List<ServiceProviderItemEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<ServiceProviderItemEntity>(
          (e) => ServiceProviderItemModel.fromJson(e),
        )
        .toList();

    return ServiceProviderListResponseModel(
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

class ServiceProviderDetailResponseModel
    extends ServiceProviderDetailResponseEntity {
  const ServiceProviderDetailResponseModel({
    required super.success,
    required super.message,
    super.serviceProvider,
  });

  factory ServiceProviderDetailResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
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

    return ServiceProviderDetailResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
      serviceProvider: docMap != null
          ? ServiceProviderItemModel.fromJson(docMap)
          : null,
    );
  }
}
